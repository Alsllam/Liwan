// Proves the move generator by comparing perft counts with an independent
// reference implementation (test/support/reference.dart).
import 'dart:math';

import 'package:game_core/testing.dart';
import 'package:game_shatranj/game_shatranj.dart';
import 'package:test/test.dart';

import 'support/reference.dart';

const game = Shatranj(repetitionDraw: false, quietPlyLimit: null);

void main() {
  const positions = [
    Shatranj.standardFen,
    Shatranj.mirroredFen,
    'r3k2r/p1pq1p1p/bn2pnp1/2pPN3/1p2P3/2N2Q1p/PPPB1PPP/R3K2R w - - 0 1',
    '4k3/3p4/8/8/8/8/8/K2R4 w - - 0 1',
    '2K1k3/3p4/8/8/8/8/8/3R4 w - - 0 1',
    'k7/p1K5/P7/8/8/8/8/8 b - - 0 1',
    '8/3P1p2/8/2k5/8/5K2/1p6/8 w - - 0 1',
  ];

  for (final f in positions) {
    test('perft matches the reference to depth 3: $f', () {
      final engine = ShatranjState.fromFen(f);
      final ref = RefPosition.fromFen(f);
      for (var d = 1; d <= 3; d++) {
        expect(perft(game, engine, d), refPerft(ref, d), reason: 'depth $d');
      }
    });
  }

  test('known counts from the initial position', () {
    final s = game.initialState;
    expect(perft(game, s, 1), 16);
    expect(perft(game, s, 2), 256);
    expect(perft(game, s, 3),
        refPerft(RefPosition.fromFen(Shatranj.standardFen), 3));
  });

  test('perft matches the reference on 40 random middlegame positions', () {
    final random = Random(2026);
    var checked = 0;
    while (checked < 40) {
      var s = game.initialState;
      final plies = 10 + random.nextInt(60);
      for (var i = 0; i < plies && !game.result(s).isOver; i++) {
        final moves = game.legalMoves(s);
        s = game.apply(s, moves[random.nextInt(moves.length)]);
      }
      if (game.result(s).isOver) continue;
      final ref = RefPosition.fromFen(s.toFen());
      expect(perft(game, s, 2), refPerft(ref, 2), reason: s.toFen());
      checked++;
    }
  });
}
