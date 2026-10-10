// Random games: every game ends, and every state along the way is valid.
import 'dart:math';

import 'package:game_core/game_core.dart';
import 'package:game_core/testing.dart';
import 'package:game_shatranj/game_shatranj.dart';
import 'package:test/test.dart';

void checkInvariants(ShatranjState s) {
  var firstShah = 0, secondShah = 0, pieces = 0;
  for (var sq = 0; sq < 64; sq++) {
    final v = s.at(sq);
    if (v == 0) continue;
    pieces++;
    if (v == PieceType.shah.code) firstShah++;
    if (v == -PieceType.shah.code) secondShah++;
    // R10: no baidaq stands unpromoted on its last rank.
    if (v == PieceType.baidaq.code) expect(Square.rank(sq), lessThan(7));
    if (v == -PieceType.baidaq.code) expect(Square.rank(sq), greaterThan(0));
  }
  expect(firstShah, 1);
  expect(secondShah, 1);
  expect(pieces, lessThanOrEqualTo(32));
  // The side that just moved is never left in check (R12).
  final other = ShatranjState.fromBoard(s.board, toMove: s.toMove.opponent);
  expect(other.isCheck, isFalse, reason: s.toFen());
  // The incremental hash matches a full recomputation.
  expect(s.key, ShatranjState.fromBoard(s.board, toMove: s.toMove).key);
}

void main() {
  test('300 random games under default rules end and stay valid', () {
    const game = Shatranj();
    final random = Random(7);
    final reasons = <String, int>{};
    for (var i = 0; i < 300; i++) {
      final r = randomPlayout(game, random,
          maxPlies: 3000, invariant: checkInvariants);
      final reason = switch (r) {
        Win(:final reason) => reason,
        Draw(:final reason) => reason,
        Ongoing() => 'ongoing',
      };
      reasons[reason] = (reasons[reason] ?? 0) + 1;
    }
    // Random play reaches several different endings.
    expect(reasons.keys.length, greaterThanOrEqualTo(3), reason: '$reasons');
  });

  test('every variant configuration terminates', () {
    final random = Random(11);
    for (final stalemate in StalemateRule.values) {
      for (final bare in BareKingRule.values) {
        for (final setup in ShatranjSetup.values) {
          final game =
              Shatranj(stalemate: stalemate, bareKing: bare, setup: setup);
          for (var i = 0; i < 10; i++) {
            expect(randomPlayout(game, random, maxPlies: 3000).isOver, isTrue);
          }
        }
      }
    }
  });
}
