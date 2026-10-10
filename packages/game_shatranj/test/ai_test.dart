import 'dart:math';

import 'package:game_core/game_core.dart';
import 'package:game_shatranj/game_shatranj.dart';
import 'package:test/test.dart';

void main() {
  const game = Shatranj();

  test('finds mate in one', () {
    final ai = shatranjAi(game, random: Random(1));
    final s = ShatranjState.fromFen('7k/8/6K1/8/8/7p/7P/R7 w - - 0 1');
    expect(ai.chooseMove(s, ShatranjLevels.majlis), ShatranjMove.parse('a1a8'));
  });

  test('finds a stalemate win when it is the fastest win (R14)', () {
    final ai = shatranjAi(game, random: Random(1));
    // Black: shāh a8, baidaq a7 blocked by a6. Kc6–c7 stalemates black.
    final s = ShatranjState.fromFen('k7/p7/P1K5/8/8/8/8/8 w - - 0 1');
    final r = ai.analyse(s, ShatranjLevels.majlis);
    expect(r.score, greaterThan(winScore - 10));
    final after = game.apply(s, r.bestMove!);
    expect(game.result(after),
        isA<Win>().having((w) => w.winner, 'winner', Player.first));
  });

  test('takes a free rukh', () {
    final ai = shatranjAi(game, random: Random(1));
    final s =
        ShatranjState.fromFen('4k3/pppp4/8/8/3r4/8/2N1PPPP/4K3 w - - 0 1');
    expect(ai.chooseMove(s, ShatranjLevels.majlis), ShatranjMove.parse('c2d4'));
  });

  test('every level returns a legal move from the opening', () {
    for (final level in ShatranjLevels.all) {
      final ai = shatranjAi(game, random: Random(level.id));
      final quick = AiLevel(
        id: level.id,
        maxDepth: level.maxDepth,
        noise: level.noise,
        maxTime: const Duration(milliseconds: 200),
      );
      final m = ai.chooseMove(game.initialState, quick);
      expect(game.legalMoves(game.initialState), contains(m));
    }
  });

  test('a stronger level beats a weaker one over a short match', () {
    final random = Random(5);
    final strong = shatranjAi(game, random: random);
    final weak = shatranjAi(game, random: random);
    var strongPoints = 0.0;
    const games = 6;
    for (var g = 0; g < games; g++) {
      final strongSide = g.isEven ? Player.first : Player.second;
      var s = game.initialState;
      for (var ply = 0; ply < 300 && !game.result(s).isOver; ply++) {
        final mover = game.toMove(s) == strongSide ? strong : weak;
        final level = game.toMove(s) == strongSide
            ? ShatranjLevels.majlis
            : ShatranjLevels.beginner;
        s = game.play(s, mover.chooseMove(s, level));
      }
      final r = game.result(s);
      if (r is Win && r.winner == strongSide) strongPoints += 1;
      if (r is Draw || r is Ongoing) strongPoints += 0.5;
    }
    expect(strongPoints, greaterThanOrEqualTo(games * 0.75));
  }, timeout: const Timeout(Duration(minutes: 5)));
}
