/// Shatranj (شطرنج), the medieval Arabic ancestor of chess: rules engine,
/// evaluation and AI for Liwan.
///
/// Rules follow `docs/rules/shatranj.md`; rule numbers (R1…R23) in the
/// comments refer to that document.
library;

export 'src/ai.dart';
export 'src/codec.dart';
export 'src/evaluation.dart'
    show evaluateShatranj, scoreShatranjMove, isNoisyShatranjMove, pieceValues;
export 'src/move.dart';
export 'src/pieces.dart';
export 'src/rules.dart';
export 'src/square.dart';
export 'src/state.dart';
