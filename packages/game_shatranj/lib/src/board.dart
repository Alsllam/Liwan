import 'dart:typed_data';

import 'package:game_core/game_core.dart';

import 'move.dart';
import 'pieces.dart';

// Piece codes (see pieces.dart).
const int shah = 1, firzan = 2, fil = 3, faras = 4, rukh = 5, baidaq = 6;

const _kingSteps = [
  (1, 0),
  (-1, 0),
  (0, 1),
  (0, -1),
  (1, 1),
  (1, -1),
  (-1, 1),
  (-1, -1)
];
const _diagonalSteps = [(1, 1), (1, -1), (-1, 1), (-1, -1)];
const _filLeaps = [(2, 2), (2, -2), (-2, 2), (-2, -2)];
const _farasLeaps = [
  (1, 2),
  (2, 1),
  (2, -1),
  (1, -2),
  (-1, -2),
  (-2, -1),
  (-2, 1),
  (-1, 2)
];
const _rukhRays = [(1, 0), (-1, 0), (0, 1), (0, -1)];

/// Precomputed target squares for the single-step and leaping pieces.
final List<List<int>> kingTargets = _targets(_kingSteps);
final List<List<int>> firzanTargets = _targets(_diagonalSteps);
final List<List<int>> filTargets = _targets(_filLeaps);
final List<List<int>> farasTargets = _targets(_farasLeaps);

List<List<int>> _targets(List<(int, int)> deltas) => List.unmodifiable([
      for (var sq = 0; sq < 64; sq++)
        List<int>.unmodifiable([
          for (final (df, dr) in deltas)
            if (_onBoard((sq & 7) + df, (sq >> 3) + dr)) sq + dr * 8 + df,
        ]),
    ]);

bool _onBoard(int f, int r) => f >= 0 && f < 8 && r >= 0 && r < 8;

int sideSign(Player p) => p == Player.first ? 1 : -1;

/// The forward direction of [p]'s baidaqs, in ranks.
int forward(Player p) => p == Player.first ? 1 : -1;

/// Rank on which [p]'s baidaq promotes (R9).
int promotionRank(Player p) => p == Player.first ? 7 : 0;

int findShah(Int8List board, Player p) {
  final code = shah * sideSign(p);
  for (var sq = 0; sq < 64; sq++) {
    if (board[sq] == code) return sq;
  }
  return -1;
}

/// Number of [p]'s men other than the shāh (R15: baidaqs count).
int menCount(Int8List board, Player p) {
  final s = sideSign(p);
  var n = 0;
  for (var sq = 0; sq < 64; sq++) {
    final v = board[sq] * s;
    if (v > 0 && v != shah) n++;
  }
  return n;
}

/// Whether [sq] is attacked by [by] (used for check, R11–R12).
bool isAttacked(Int8List board, int sq, Player by) {
  final s = sideSign(by);
  for (final t in kingTargets[sq]) {
    if (board[t] == shah * s) return true;
  }
  for (final t in firzanTargets[sq]) {
    if (board[t] == firzan * s) return true;
  }
  for (final t in filTargets[sq]) {
    if (board[t] == fil * s) return true;
  }
  for (final t in farasTargets[sq]) {
    if (board[t] == faras * s) return true;
  }
  final f0 = sq & 7, r0 = sq >> 3;
  for (final (df, dr) in _rukhRays) {
    var f = f0 + df, r = r0 + dr;
    while (_onBoard(f, r)) {
      final v = board[r * 8 + f];
      if (v != 0) {
        if (v == rukh * s) return true;
        break;
      }
      f += df;
      r += dr;
    }
  }
  // A baidaq attacks diagonally forward, so an attacker of [sq] stands one
  // rank behind it (from the attacker's point of view).
  final pr = r0 - forward(by);
  if (pr >= 0 && pr < 8) {
    if (f0 > 0 && board[pr * 8 + f0 - 1] == baidaq * s) return true;
    if (f0 < 7 && board[pr * 8 + f0 + 1] == baidaq * s) return true;
  }
  return false;
}

bool inCheck(Int8List board, Player p) {
  final k = findShah(board, p);
  return k >= 0 && isAttacked(board, k, p.opponent);
}

/// Pseudo-legal moves for [side] (rules doc §3, R3–R10): legal except that
/// they may leave the mover's own shāh in check.
List<ShatranjMove> pseudoMoves(Int8List board, Player side) {
  final s = sideSign(side);
  final moves = <ShatranjMove>[];

  void addTargets(int from, List<int> targets) {
    for (final t in targets) {
      if (board[t] * s <= 0) moves.add(ShatranjMove(from, t)); // empty or enemy
    }
  }

  for (var sq = 0; sq < 64; sq++) {
    final v = board[sq] * s;
    if (v <= 0) continue;
    switch (v) {
      case shah:
        addTargets(sq, kingTargets[sq]);
      case firzan:
        addTargets(sq, firzanTargets[sq]);
      case fil:
        addTargets(
            sq, filTargets[sq]); // jumps: the middle square is ignored (R5)
      case faras:
        addTargets(sq, farasTargets[sq]);
      case rukh:
        final f0 = sq & 7, r0 = sq >> 3;
        for (final (df, dr) in _rukhRays) {
          var f = f0 + df, r = r0 + dr;
          while (_onBoard(f, r)) {
            final t = r * 8 + f;
            final w = board[t] * s;
            if (w > 0) break;
            moves.add(ShatranjMove(sq, t));
            if (w < 0) break;
            f += df;
            r += dr;
          }
        }
      case baidaq:
        final f0 = sq & 7, r1 = (sq >> 3) + forward(side);
        if (r1 < 0 || r1 > 7) break;
        // One step straight forward onto an empty square; never two (R6).
        if (board[r1 * 8 + f0] == 0) moves.add(ShatranjMove(sq, r1 * 8 + f0));
        // Captures one square diagonally forward (R4). No en passant (R7).
        for (final df in const [-1, 1]) {
          final f = f0 + df;
          if (f >= 0 && f < 8 && board[r1 * 8 + f] * s < 0) {
            moves.add(ShatranjMove(sq, r1 * 8 + f));
          }
        }
    }
  }
  return moves;
}

/// The board after [move] (no legality check). A baidaq reaching its last
/// rank becomes a firzān as part of the same move (R9).
Int8List boardAfter(Int8List board, ShatranjMove move) {
  final next = Int8List.fromList(board);
  var piece = next[move.from];
  if (piece.abs() == baidaq && (move.to >> 3) == (piece > 0 ? 7 : 0)) {
    piece = piece > 0 ? firzan : -firzan;
  }
  next[move.to] = piece;
  next[move.from] = 0;
  return next;
}

/// Legal moves: pseudo-legal moves that do not leave the mover's shāh in
/// check (R12).
List<ShatranjMove> legalMovesOf(Int8List board, Player side) => [
      for (final m in pseudoMoves(board, side))
        if (!inCheck(boardAfter(board, m), side)) m,
    ];

// ---- Zobrist hashing -----------------------------------------------------
// 31-bit values so that hashing gives the same numbers on the Dart VM and
// on the web (JavaScript bitwise operations are 32-bit).

final List<int> _zobrist = () {
  var x = 0x2545F491;
  int next() {
    x ^= (x << 13) & 0xFFFFFFFF;
    x ^= x >> 17;
    x ^= (x << 5) & 0xFFFFFFFF;
    return x & 0x7FFFFFFF;
  }

  return List<int>.unmodifiable([for (var i = 0; i < 13 * 64 + 1; i++) next()]);
}();

int zobristPiece(int piece, int sq) => _zobrist[(piece + 6) * 64 + sq];
final int zobristSecondToMove = _zobrist[13 * 64];

int zobristKey(Int8List board, Player toMove) {
  var k = toMove == Player.second ? zobristSecondToMove : 0;
  for (var sq = 0; sq < 64; sq++) {
    if (board[sq] != 0) k ^= zobristPiece(board[sq], sq);
  }
  return k;
}

PieceType pieceType(int code) => PieceType.fromCode(code);
