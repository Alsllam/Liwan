import 'dart:typed_data';

import 'package:game_core/game_core.dart';

import 'board.dart';
import 'move.dart';
import 'pieces.dart';
import 'square.dart';

/// An immutable shatranj position plus the history needed for draw rules.
final class ShatranjState {
  ShatranjState._({
    required Int8List board,
    required this.toMove,
    required this.quietPlies,
    required this.fullMove,
    required List<int> history,
    required this.key,
  })  : _board = board,
        history = List.unmodifiable(history);

  /// Builds a state from a board, computing its hash key.
  factory ShatranjState.fromBoard(
    List<int> board, {
    required Player toMove,
    int quietPlies = 0,
    int fullMove = 1,
    List<int> history = const [],
  }) {
    if (board.length != 64) throw ArgumentError('A board has 64 squares.');
    final b = Int8List.fromList(board);
    return ShatranjState._(
      board: b,
      toMove: toMove,
      quietPlies: quietPlies,
      fullMove: fullMove,
      history: history,
      key: zobristKey(b, toMove),
    );
  }

  /// Parses the FEN-style setup string of rules doc §3.1, e.g.
  /// `rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1`.
  ///
  /// Letters: K shāh, Q firzān, B fīl, N faras, R rukh, P baidaq;
  /// uppercase = first player, `w` = first player to move. The castling and
  /// en-passant fields must be `-`.
  factory ShatranjState.fromFen(String fen) {
    final parts = fen.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) throw FormatException('Bad setup string "$fen".');
    final rows = parts[0].split('/');
    if (rows.length != 8) throw FormatException('Bad setup string "$fen".');
    final board = List<int>.filled(64, 0);
    for (var i = 0; i < 8; i++) {
      final rank = 7 - i;
      var file = 0;
      for (final ch in rows[i].split('')) {
        final n = int.tryParse(ch);
        if (n != null) {
          file += n;
        } else {
          if (file > 7) throw FormatException('Bad rank in "$fen".');
          final t = PieceType.fromFenLetter(ch);
          board[Square.of(file, rank)] =
              ch == ch.toUpperCase() ? t.code : -t.code;
          file++;
        }
      }
      if (file != 8) throw FormatException('Bad rank in "$fen".');
    }
    final toMove = switch (parts[1]) {
      'w' => Player.first,
      'b' => Player.second,
      _ => throw FormatException('Bad side to move in "$fen".'),
    };
    if (parts.length > 2 && parts[2] != '-') {
      throw FormatException('Shatranj has no castling (R8).');
    }
    if (parts.length > 3 && parts[3] != '-') {
      throw FormatException('Shatranj has no en passant (R7).');
    }
    final quiet = parts.length > 4 ? int.parse(parts[4]) : 0;
    final full = parts.length > 5 ? int.parse(parts[5]) : 1;
    return ShatranjState.fromBoard(board,
        toMove: toMove, quietPlies: quiet, fullMove: full);
  }

  final Int8List _board;

  /// The side to move.
  final Player toMove;

  /// Plies since the last capture or baidaq move (house rule R22b).
  final int quietPlies;

  /// Move number, starting at 1 and increasing after the second player moves.
  final int fullMove;

  /// Hash keys of earlier positions since the last capture or baidaq move,
  /// oldest first (house rule R22a). Only positions in this window can
  /// repeat, because captures and baidaq moves cannot be undone.
  final List<int> history;

  /// Zobrist hash of the board and side to move.
  final int key;

  /// The piece code on [sq]: 0 empty, +1…+6 first player, −1…−6 second
  /// player (see [PieceType.code]).
  int at(int sq) => _board[sq];

  /// A copy of the board.
  List<int> get board => List.of(_board);

  Int8List get rawBoard => _board;

  /// The piece on [sq], or null.
  ({PieceType type, Player owner})? pieceAt(int sq) {
    final v = _board[sq];
    if (v == 0) return null;
    return (
      type: PieceType.fromCode(v),
      owner: v > 0 ? Player.first : Player.second
    );
  }

  late final List<ShatranjMove> legalMoves =
      List.unmodifiable(legalMovesOf(_board, toMove));

  /// Whether the side to move is in check (R11).
  late final bool isCheck = inCheck(_board, toMove);

  /// How many times the current position has occurred, counting this one.
  int get occurrences => 1 + history.where((k) => k == key).length;

  /// The state after [move]. Does not check legality.
  ShatranjState after(ShatranjMove move) {
    final moving = _board[move.from];
    final captured = _board[move.to];
    final next = boardAfter(_board, move);
    final irreversible = captured != 0 || moving.abs() == baidaq;
    var k = key ^ zobristSecondToMove ^ zobristPiece(moving, move.from);
    if (captured != 0) k ^= zobristPiece(captured, move.to);
    k ^= zobristPiece(next[move.to], move.to);
    return ShatranjState._(
      board: next,
      toMove: toMove.opponent,
      quietPlies: irreversible ? 0 : quietPlies + 1,
      fullMove: toMove == Player.second ? fullMove + 1 : fullMove,
      history: irreversible ? const [] : [...history, key],
      key: k,
    );
  }

  /// The FEN-style setup string of this position.
  String toFen() {
    final rows = <String>[];
    for (var rank = 7; rank >= 0; rank--) {
      final sb = StringBuffer();
      var empty = 0;
      for (var file = 0; file < 8; file++) {
        final v = _board[Square.of(file, rank)];
        if (v == 0) {
          empty++;
          continue;
        }
        if (empty > 0) sb.write(empty);
        empty = 0;
        final letter = PieceType.fromCode(v).fenLetter;
        sb.write(v > 0 ? letter : letter.toLowerCase());
      }
      if (empty > 0) sb.write(empty);
      rows.add(sb.toString());
    }
    return '${rows.join('/')} ${toMove == Player.first ? 'w' : 'b'} - - $quietPlies $fullMove';
  }

  @override
  bool operator ==(Object other) {
    if (other is! ShatranjState ||
        other.key != key ||
        other.toMove != toMove ||
        other.quietPlies != quietPlies ||
        other.fullMove != fullMove ||
        other.history.length != history.length) {
      return false;
    }
    for (var i = 0; i < 64; i++) {
      if (other._board[i] != _board[i]) return false;
    }
    for (var i = 0; i < history.length; i++) {
      if (other.history[i] != history[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(key, quietPlies, history.length);

  @override
  String toString() => toFen();
}
