import 'dart:convert';
import 'dart:math';

import 'package:game_shatranj/game_shatranj.dart';
import 'package:test/test.dart';

void main() {
  const game = Shatranj();
  const codec = ShatranjCodec();

  test('states survive a JSON round-trip, including repetition history', () {
    final random = Random(3);
    for (var g = 0; g < 20; g++) {
      var s = game.initialState;
      for (var i = 0; i < 80 && !game.result(s).isOver; i++) {
        final json = jsonDecode(jsonEncode(codec.encodeState(s)))
            as Map<String, Object?>;
        final back = codec.decodeState(json);
        expect(back, s);
        expect(back.key, s.key);
        expect(game.result(back), game.result(s));
        final moves = game.legalMoves(s);
        s = game.apply(s, moves[random.nextInt(moves.length)]);
      }
    }
  });

  test('moves survive the wire form', () {
    for (final m in game.legalMoves(game.initialState)) {
      expect(codec.decodeMove(codec.encodeMove(m)), m);
    }
    expect(codec.encodeMove(ShatranjMove.parse('g1f3')), 'g1f3');
  });

  test('bad input is rejected', () {
    expect(() => codec.decodeMove('e2'), throwsFormatException);
    expect(() => codec.decodeMove('z9e4'), throwsFormatException);
    expect(() => codec.decodeState({'game': 'dama'}), throwsFormatException);
    expect(
        () => codec.decodeState({'game': 'shatranj'}), throwsFormatException);
    expect(
      () => codec.decodeState({
        'game': 'shatranj',
        'fen': Shatranj.standardFen,
        'history': ['x']
      }),
      throwsFormatException,
    );
  });

  test('moves are described in Arabic and English', () {
    final s = game.initialState;
    expect(describeMove(s, ShatranjMove.parse('g1f3')), 'Faras g1–f3');
    expect(
        describeMove(s, ShatranjMove.parse('g1f3'), arabic: true), 'فرس ز١–و٣');
    final p = ShatranjState.fromFen('k7/4P3/8/8/8/8/p7/7K w - - 0 1');
    expect(describeMove(p, ShatranjMove.parse('e7e8')), 'Baidaq e7–e8=Firzān');
    final c = ShatranjState.fromFen('k7/8/8/8/8/8/p7/R6K w - - 0 1');
    expect(describeMove(c, ShatranjMove.parse('a1a2')), 'Rukh a1×a2');
  });

  test('hash keys are pinned (same values on the VM and the web)', () {
    // Checked by compiling to JavaScript: 31-bit Zobrist keys give identical
    // values. Pinned here so an accidental change is caught.
    expect(game.initialState.key, 1547262615);
    expect(ShatranjState.fromFen('4k3/3p4/8/8/8/8/8/K2R4 w - - 0 1').key,
        1252642237);
  });
}
