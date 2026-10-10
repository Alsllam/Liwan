import 'package:game_core/game_core.dart';

import 'move.dart';
import 'pieces.dart';
import 'square.dart';
import 'state.dart';

/// JSON and text forms of shatranj states and moves.
///
/// The JSON form stores the position as a setup string plus the hash keys
/// of the earlier positions in the repetition window. Keys are 31-bit
/// Zobrist values computed the same way on the Dart VM and on the web.
final class ShatranjCodec implements GameCodec<ShatranjState, ShatranjMove> {
  const ShatranjCodec();

  static const version = 1;

  @override
  Map<String, Object?> encodeState(ShatranjState state) => {
        'game': 'shatranj',
        'v': version,
        'fen': state.toFen(),
        'history': state.history,
      };

  @override
  ShatranjState decodeState(Map<String, Object?> json) {
    if (json['game'] != 'shatranj') {
      throw const FormatException('Not a shatranj state.');
    }
    final fen = json['fen'];
    if (fen is! String) throw const FormatException('Missing "fen".');
    final base = ShatranjState.fromFen(fen);
    final history = [
      for (final k in json['history'] as List<Object?>? ?? const [])
        if (k is int) k else throw const FormatException('Bad "history".'),
    ];
    return ShatranjState.fromBoard(
      base.board,
      toMove: base.toMove,
      quietPlies: base.quietPlies,
      fullMove: base.fullMove,
      history: history,
    );
  }

  @override
  String encodeMove(ShatranjMove move) => move.notation;

  @override
  ShatranjMove decodeMove(String text) => ShatranjMove.parse(text);
}

/// A readable description of [move] played in [state], for the command
/// line, tutorials and move lists. Example: `Faras g1–f3` or
/// `فرس ز١–و٣`; captures use `×` and promotion adds `=Firzān`.
String describeMove(ShatranjState state, ShatranjMove move,
    {bool arabic = false}) {
  final piece = PieceType.fromCode(state.at(move.from));
  final capture = state.at(move.to) != 0;
  final promotes = piece == PieceType.baidaq &&
      Square.rank(move.to) == (state.at(move.from) > 0 ? 7 : 0);
  final name = arabic ? piece.arabicName : piece.englishName;
  final from = arabic ? Square.arabicName(move.from) : Square.name(move.from);
  final to = arabic ? Square.arabicName(move.to) : Square.name(move.to);
  final promo = promotes ? (arabic ? ' ← فرزان' : '=Firzān') : '';
  return '$name $from${capture ? '×' : '–'}$to$promo';
}
