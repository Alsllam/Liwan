import 'package:game_core/game_core.dart';

import 'board.dart';
import 'move.dart';
import 'state.dart';

/// Result of a stalemate (rules doc R14, decision D1).
enum StalemateRule {
  /// Classical shatranj: the player who stalemates wins. Default.
  stalematerWins,

  /// The Indian rule reported by al-ʿAdlī: the stalemated player wins.
  stalematedWins,

  /// Modern chess rule. Not historical for shatranj.
  draw,
}

/// Bare-king rule (rules doc R15–R17, decision D3).
enum BareKingRule {
  /// Counter-baring: the bared side gets one reply; baring back is a draw.
  /// Default.
  counterBareDraws,

  /// "Medina rule": the first player to bare the other wins at once.
  medina,
}

/// Starting arrangement of shāh and firzān (rules doc §3.1, decision D2).
enum ShatranjSetup {
  /// Shāh on e1/e8, firzān on d1/d8: the kings face each other. Default.
  standard,

  /// "Heritage setup": each shāh faces the enemy firzān
  /// (first player shāh e1, second player shāh d8).
  mirrored,
}

/// Result reason codes, for the UI and tutorials.
abstract final class ShatranjReason {
  static const checkmate = 'checkmate'; // R13
  static const stalemate = 'stalemate'; // R14
  static const bareKing = 'bare-king'; // R16
  static const bareKings = 'bare-kings'; // R20: shāh against shāh
  static const threefoldRepetition = 'threefold-repetition'; // R22a (house)
  static const moveLimit = 'move-limit'; // R22b (house)
}

/// Shatranj rules under a chosen variant configuration.
///
/// Defaults follow the decisions log in `docs/rules/README.md`.
final class Shatranj implements Game<ShatranjState, ShatranjMove> {
  const Shatranj({
    this.stalemate = StalemateRule.stalematerWins,
    this.bareKing = BareKingRule.counterBareDraws,
    this.setup = ShatranjSetup.standard,
    this.repetitionDraw = true,
    this.quietPlyLimit = 140,
  });

  final StalemateRule stalemate;
  final BareKingRule bareKing;
  final ShatranjSetup setup;

  /// House rule R22a: threefold repetition is a draw.
  final bool repetitionDraw;

  /// House rule R22b: plies with no capture and no baidaq move before a
  /// draw (140 = 70 moves each). Null turns the rule off.
  final int? quietPlyLimit;

  static const standardFen =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1';
  static const mirroredFen =
      'rnbkqbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1';

  @override
  String get id => 'shatranj';

  @override
  ShatranjState get initialState => ShatranjState.fromFen(
        setup == ShatranjSetup.standard ? standardFen : mirroredFen,
      );

  @override
  Player toMove(ShatranjState state) => state.toMove;

  @override
  List<ShatranjMove> legalMoves(ShatranjState state) =>
      result(state).isOver ? const [] : state.legalMoves;

  @override
  ShatranjState apply(ShatranjState state, ShatranjMove move) =>
      state.after(move);

  @override
  GameResult result(ShatranjState state) {
    final side = state.toMove; // the side to move
    final other = side.opponent; // the side that just moved
    final board = state.rawBoard;
    final sideBare = menCount(board, side) == 0;
    final otherBare = menCount(board, other) == 0;

    // R13 / R14: no legal move.
    if (state.legalMoves.isEmpty) {
      if (state.isCheck) return Win(other, ShatranjReason.checkmate);
      // R18: a move that bares and stalemates is a win for the baring side.
      if (sideBare && !otherBare) return Win(other, ShatranjReason.bareKing);
      return switch (stalemate) {
        StalemateRule.stalematerWins => Win(other, ShatranjReason.stalemate),
        StalemateRule.stalematedWins => Win(side, ShatranjReason.stalemate),
        StalemateRule.draw => const Draw(ShatranjReason.stalemate),
      };
    }

    // R20: shāh against shāh (after a counter-bare).
    if (sideBare && otherBare) return const Draw(ShatranjReason.bareKings);

    // R16–R17: the side to move has just been bared.
    if (sideBare) {
      if (bareKing == BareKingRule.medina) {
        return Win(other, ShatranjReason.bareKing);
      }
      // R17b: counter-baring is possible only if the baring side has exactly
      // one man left and the bared shāh can legally capture it now.
      if (menCount(board, other) == 1 &&
          state.legalMoves.any((m) => board[m.to] != 0)) {
        return GameResult.ongoing;
      }
      return Win(other, ShatranjReason.bareKing);
    }

    // R17: the side that just moved was bared and did not bare back.
    if (otherBare) return Win(side, ShatranjReason.bareKing);

    // R22a / R22b: house rules, named as such in the app.
    if (repetitionDraw && state.occurrences >= 3) {
      return const Draw(ShatranjReason.threefoldRepetition);
    }
    final limit = quietPlyLimit;
    if (limit != null && state.quietPlies >= limit) {
      return const Draw(ShatranjReason.moveLimit);
    }
    return GameResult.ongoing;
  }
}
