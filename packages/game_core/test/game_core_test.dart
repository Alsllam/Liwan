import 'dart:math';

import 'package:game_core/game_core.dart';
import 'package:game_core/testing.dart';
import 'package:test/test.dart';

import 'support/toy_games.dart';

int zero(Object state, Player perspective) => 0;

void main() {
  group('Player', () {
    test('opponent and sign', () {
      expect(Player.first.opponent, Player.second);
      expect(Player.second.opponent, Player.first);
      expect(Player.first.sign, 1);
      expect(Player.second.sign, -1);
    });
  });

  group('GameResult', () {
    test('value equality and isOver', () {
      expect(const Win(Player.first, 'x'), const Win(Player.first, 'x'));
      expect(const Win(Player.first, 'x') == const Win(Player.second, 'x'),
          isFalse);
      expect(const Draw('r'), const Draw('r'));
      expect(GameResult.ongoing.isOver, isFalse);
      expect(const Draw('r').isOver, isTrue);
    });
  });

  group('Game.play', () {
    final game = TicTacToe();
    test('applies a legal move', () {
      final s = game.play(game.initialState, 4);
      expect(s.cells[4], 1);
      expect(game.toMove(s), Player.second);
    });
    test('rejects an illegal move', () {
      final s = game.play(game.initialState, 4);
      expect(() => game.play(s, 4), throwsA(isA<IllegalMoveException>()));
    });
    test('rejects moves after the game is over', () {
      var s = game.initialState;
      for (final m in [0, 3, 1, 4, 2]) {
        s = game.play(s, m);
      }
      expect(game.result(s), const Win(Player.first, 'line'));
      expect(() => game.play(s, 5), throwsA(isA<IllegalMoveException>()));
    });
  });

  group('harness', () {
    test('perft counts tic-tac-toe move sequences', () {
      final game = TicTacToe();
      expect(perft(game, game.initialState, 1), 9);
      expect(perft(game, game.initialState, 2), 72);
      expect(perft(game, game.initialState, 3), 504);
      // Known total number of tic-tac-toe games: 255168.
      expect(perft(game, game.initialState, 9), lessThan(255168));
    });
    test('random playouts always terminate', () {
      final game = TicTacToe();
      final random = Random(1);
      for (var i = 0; i < 200; i++) {
        expect(randomPlayout(game, random).isOver, isTrue);
      }
    });
  });

  group('AlphaBetaSearch', () {
    test('perfect tic-tac-toe is a draw', () {
      final game = TicTacToe();
      final search =
          AlphaBetaSearch<TicTacToeState, int>(game: game, evaluate: zero);
      final r = search.search(game.initialState,
          limits: const SearchLimits(maxDepth: 9));
      expect(r.score, 0);
      expect(r.depth, 9);
    });

    test('takes an immediate win and blocks an immediate loss', () {
      final game = TicTacToe();
      final search =
          AlphaBetaSearch<TicTacToeState, int>(game: game, evaluate: zero);
      // X: 0,1  O: 3,4  — X to move wins at 2.
      var s = game.initialState;
      for (final m in [0, 3, 1, 4]) {
        s = game.apply(s, m);
      }
      expect(search.search(s, limits: const SearchLimits(maxDepth: 5)).bestMove,
          2);
      // X: 0,8  O: 4 — O to move... X threatens nothing; set up O must block.
      var t = game.initialState;
      for (final m in [0, 4, 1]) {
        t = game.apply(t, m);
      }
      expect(search.search(t, limits: const SearchLimits(maxDepth: 7)).bestMove,
          2);
    });

    test('solves Nim: leaves a multiple of four', () {
      for (var heap = 1; heap <= 15; heap++) {
        final game = Nim(heap);
        final search =
            AlphaBetaSearch<NimState, int>(game: game, evaluate: zero);
        final r = search.search(game.initialState,
            limits: SearchLimits(maxDepth: heap));
        if (heap % 4 == 0) {
          expect(r.score, lessThan(0), reason: 'heap $heap is lost');
        } else {
          expect(r.score, greaterThan(0), reason: 'heap $heap is won');
          expect((heap - r.bestMove!) % 4, 0, reason: 'heap $heap');
        }
      }
    });

    test('prefers the faster win', () {
      final game = Nim(3);
      final search = AlphaBetaSearch<NimState, int>(game: game, evaluate: zero);
      final r = search.search(game.initialState,
          limits: const SearchLimits(maxDepth: 5));
      expect(r.bestMove, 3);
      expect(r.score, winScore - 1);
    });

    test('exact root scores rank every move', () {
      final game = Nim(6);
      final search = AlphaBetaSearch<NimState, int>(game: game, evaluate: zero);
      final r = search.search(game.initialState,
          limits: const SearchLimits(maxDepth: 8), exactRootScores: true);
      expect(r.rootMoves.length, 3);
      expect(r.rootMoves.first.move, 2);
      expect(r.rootMoves.skip(1).every((m) => m.score < 0), isTrue);
    });

    test('respects the node budget', () {
      final game = TicTacToe();
      final search =
          AlphaBetaSearch<TicTacToeState, int>(game: game, evaluate: zero);
      final r = search.search(game.initialState,
          limits: const SearchLimits(maxDepth: 9, maxNodes: 2048));
      expect(r.bestMove, isNotNull);
      expect(r.depth, lessThan(9));
    });

    test('returns no move in a terminal position', () {
      final game = Nim(0);
      final search = AlphaBetaSearch<NimState, int>(game: game, evaluate: zero);
      expect(search.search(game.initialState).bestMove, isNull);
    });

    test('rejects a table size that is not a power of two', () {
      expect(
        () => AlphaBetaSearch<NimState, int>(
            game: Nim(3), evaluate: zero, tableSize: 1000),
        throwsArgumentError,
      );
    });
  });

  group('pickWithNoise', () {
    const moves = [
      ScoredMove('a', 50),
      ScoredMove('b', 45),
      ScoredMove('c', 0)
    ];
    test('noise 0 picks the best', () {
      expect(pickWithNoise(moves, 0, Random(1)), 'a');
    });
    test('noise widens the choice but never below the margin', () {
      final picked = {
        for (var i = 0; i < 50; i++) pickWithNoise(moves, 10, Random(i))
      };
      expect(picked, {'a', 'b'});
    });
    test('never throws away a forced win', () {
      const win = [ScoredMove('w', winScore - 3), ScoredMove('x', 0)];
      expect(pickWithNoise(win, 1 << 30, Random(1)), 'w');
    });
    test('avoids forced losses when another move exists', () {
      const lose = [ScoredMove('ok', -100), ScoredMove('bad', -winScore + 2)];
      final picked = {
        for (var i = 0; i < 30; i++) pickWithNoise(lose, 1 << 30, Random(i))
      };
      expect(picked, {'ok'});
    });
  });

  group('MctsSearch', () {
    test('finds the winning Nim move', () {
      for (final heap in [5, 6, 7, 9]) {
        final game = Nim(heap);
        final mcts = MctsSearch<NimState, int>(game: game, random: Random(7));
        final move = mcts.search(game.initialState,
            limits: const MctsLimits(iterations: 3000));
        expect((heap - move!) % 4, 0, reason: 'heap $heap');
      }
    });

    test('blocks an immediate tic-tac-toe loss', () {
      final game = TicTacToe();
      var t = game.initialState;
      for (final m in [0, 4, 1]) {
        t = game.apply(t, m);
      }
      final mcts =
          MctsSearch<TicTacToeState, int>(game: game, random: Random(3));
      expect(mcts.search(t, limits: const MctsLimits(iterations: 4000)), 2);
    });

    test('is reproducible with the same seed', () {
      final game = TicTacToe();
      int? run() =>
          MctsSearch<TicTacToeState, int>(game: game, random: Random(42))
              .search(game.initialState,
                  limits: const MctsLimits(iterations: 500));
      expect(run(), run());
    });
  });

  group('AiPlayer', () {
    test('uses alpha-beta or MCTS by level and always returns a legal move',
        () {
      final game = TicTacToe();
      final ai = AiPlayer<TicTacToeState, int>(
          game: game, evaluate: zero, random: Random(1));
      const levels = [
        AiLevel(id: 1, maxDepth: 1, noise: 1000),
        AiLevel(id: 5, maxDepth: 9, noise: 0),
        AiLevel(id: 3, maxDepth: 1, noise: 0, mctsIterations: 300),
      ];
      for (final level in levels) {
        final move = ai.chooseMove(game.initialState, level);
        expect(game.legalMoves(game.initialState), contains(move));
      }
    });

    test('the strongest level never loses tic-tac-toe to a random player', () {
      final game = TicTacToe();
      final random = Random(9);
      final ai = AiPlayer<TicTacToeState, int>(
          game: game, evaluate: zero, random: random);
      const level = AiLevel(id: 5, maxDepth: 9, noise: 0);
      for (var g = 0; g < 30; g++) {
        var s = game.initialState;
        final aiSide = g.isEven ? Player.first : Player.second;
        while (!game.result(s).isOver) {
          final moves = game.legalMoves(s);
          final m = game.toMove(s) == aiSide
              ? ai.chooseMove(s, level)
              : moves[random.nextInt(moves.length)];
          s = game.play(s, m);
        }
        final r = game.result(s);
        expect(r is Win && r.winner != aiSide, isFalse, reason: 'game $g');
      }
    });

    test('throws when there is no move', () {
      final game = Nim(0);
      final ai = AiPlayer<NimState, int>(
          game: game, evaluate: zero, random: Random(1));
      expect(
        () => ai.chooseMove(
            game.initialState, const AiLevel(id: 1, maxDepth: 1, noise: 0)),
        throwsStateError,
      );
    });
  });
}
