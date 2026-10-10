import 'dart:math';

import 'package:game_core/game_core.dart';

import 'evaluation.dart';
import 'move.dart';
import 'rules.dart';
import 'state.dart';

/// The five AI levels for shatranj (`docs/GDD.md` §5.2).
abstract final class ShatranjLevels {
  /// مبتدئ — Beginner.
  static const beginner = AiLevel(id: 1, maxDepth: 1, noise: 250);

  /// متعلّم — Learner.
  static const learner = AiLevel(id: 2, maxDepth: 2, noise: 120);

  /// لاعب المجلس — Majlis player.
  static const majlis = AiLevel(id: 3, maxDepth: 3, noise: 40);

  /// خبير — Expert: full search for about one second.
  static const expert =
      AiLevel(id: 4, maxDepth: 64, noise: 0, maxTime: Duration(seconds: 1));

  /// أستاذ — Master ("aṣ-Ṣūlī"): full search for up to four seconds.
  static const master =
      AiLevel(id: 5, maxDepth: 64, noise: 0, maxTime: Duration(seconds: 4));

  static const all = [beginner, learner, majlis, expert, master];

  static AiLevel byId(int id) => all.firstWhere(
        (l) => l.id == id,
        orElse: () => throw ArgumentError.value(id, 'id', 'must be 1–5'),
      );
}

/// An AI opponent for [game], using `game_core` alpha-beta search.
AiPlayer<ShatranjState, ShatranjMove> shatranjAi(Shatranj game,
        {required Random random}) =>
    AiPlayer<ShatranjState, ShatranjMove>(
      game: game,
      evaluate: evaluateShatranj,
      random: random,
      moveScorer: scoreShatranjMove,
      isNoisy: isNoisyShatranjMove,
      stateKey: (s) => s.key,
    );
