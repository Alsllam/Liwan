// Tests named after the rules in docs/rules/shatranj.md (R1…R23) and its
// test positions (§7.2, numbered TP1…TP17).
import 'package:game_core/game_core.dart';
import 'package:game_shatranj/game_shatranj.dart';
import 'package:test/test.dart';

const game = Shatranj();

ShatranjState fen(String f) => ShatranjState.fromFen(f);
int sq(String name) => Square.parse(name);
ShatranjMove mv(String text) => ShatranjMove.parse(text);
// Piece movement is checked on the raw move generator, so test positions may
// have a bare side (which would otherwise end the game at once, R16).
Set<String> targetsFrom(ShatranjState s, String from) => {
      for (final m in s.legalMoves)
        if (m.from == sq(from)) Square.name(m.to),
    };
ShatranjState playAll(ShatranjState s, List<String> moves,
    [Shatranj g = game]) {
  for (final m in moves) {
    s = g.play(s, mv(m));
  }
  return s;
}

void main() {
  group('§3.1 starting position', () {
    test('SP1 standard setup (D2-A): shāh e1/e8, firzān d1/d8', () {
      final s = game.initialState;
      expect(s.toFen(), Shatranj.standardFen);
      expect(s.pieceAt(sq('e1'))!.type, PieceType.shah);
      expect(s.pieceAt(sq('d1'))!.type, PieceType.firzan);
      expect(s.pieceAt(sq('e8'))!.type, PieceType.shah);
      expect(s.pieceAt(sq('d8'))!.type, PieceType.firzan);
      expect(s.pieceAt(sq('c1'))!.type, PieceType.fil);
      expect(s.toMove, Player.first);
    });

    test('TP1 the first player has 16 legal moves', () {
      final moves = game.legalMoves(game.initialState);
      expect(moves.length, 16);
      expect(targetsFrom(game.initialState, 'c1'), {'a3', 'e3'});
      expect(targetsFrom(game.initialState, 'f1'), {'d3', 'h3'});
      expect(targetsFrom(game.initialState, 'b1'), {'a3', 'c3'});
      expect(targetsFrom(game.initialState, 'd1'), isEmpty);
      expect(targetsFrom(game.initialState, 'e1'), isEmpty);
    });

    test('TP17 mirrored "heritage" setup (D2-C)', () {
      const mirrored = Shatranj(setup: ShatranjSetup.mirrored);
      final s = mirrored.initialState;
      expect(s.pieceAt(sq('e1'))!.type, PieceType.shah);
      expect(s.pieceAt(sq('d8'))!.type, PieceType.shah);
      expect(s.pieceAt(sq('e8'))!.type, PieceType.firzan);
      expect(mirrored.legalMoves(s).length, 16);
      final reply = mirrored.apply(s, mv('e2e3'));
      expect(mirrored.legalMoves(reply).length, 16);
    });
  });

  group('§3 piece movement', () {
    test('shāh steps one square in any direction', () {
      final s = fen('7k/8/8/8/3K4/8/8/8 w - - 0 1');
      expect(targetsFrom(s, 'd4'),
          {'c3', 'c4', 'c5', 'd3', 'd5', 'e3', 'e4', 'e5'});
    });

    test('TP4 firzān steps exactly one square diagonally', () {
      final s = fen('7k/8/8/8/3Q4/8/8/K7 w - - 0 1');
      expect(targetsFrom(s, 'd4'), {'c3', 'e3', 'c5', 'e5'});
    });

    test('TP2 fīl leaps two squares diagonally over an occupied square (R5)',
        () {
      final s = fen('4k3/8/8/8/8/8/1P6/B3K3 w - - 0 1');
      expect(targetsFrom(s, 'a1'), {'c3'});
    });

    test('TP3 a fīl from c1 can only ever reach 8 squares', () {
      final reached = <String>{'c1'};
      var frontier = {'c1'};
      while (frontier.isNotEmpty) {
        final next = <String>{};
        for (final from in frontier) {
          final s = fen('7k/8/8/8/8/8/8/K7 w - - 0 1');
          final b = s.board..[sq(from)] = PieceType.fil.code;
          final pos = ShatranjState.fromBoard(b, toMove: Player.first);
          for (final t in targetsFrom(pos, from)) {
            if (reached.add(t)) next.add(t);
          }
        }
        frontier = next;
      }
      expect(reached, {'a3', 'a7', 'c1', 'c5', 'e3', 'e7', 'g1', 'g5'});
    });

    test('faras moves like a knight and jumps', () {
      final s = fen('7k/8/8/8/8/8/PPP5/KN6 w - - 0 1');
      expect(targetsFrom(s, 'b1'), {'a3', 'c3', 'd2'});
    });

    test('rukh slides orthogonally and is blocked (R5)', () {
      final s = fen('7k/8/8/1p6/8/8/1P6/KR6 w - - 0 1');
      expect(targetsFrom(s, 'b1'), {'c1', 'd1', 'e1', 'f1', 'g1', 'h1'});
      final open = fen('7k/8/8/1p6/8/8/8/KR6 w - - 0 1');
      expect(targetsFrom(open, 'b1'), containsAll(['b2', 'b3', 'b4', 'b5']));
      expect(targetsFrom(open, 'b1'), isNot(contains('b6')));
    });

    test('R3 no piece may land on a friendly piece', () {
      final s = fen('7k/8/8/8/8/8/8/RN5K w - - 0 1');
      expect(targetsFrom(s, 'a1'), isNot(contains('b1')));
    });
  });

  group('baidaq', () {
    test('TP5 R6 one step forward only, never two', () {
      final s = fen('7k/8/8/8/8/8/4P3/K7 w - - 0 1');
      expect(targetsFrom(s, 'e2'), {'e3'});
    });

    test('R4 captures diagonally forward, not straight ahead', () {
      final s = fen('7k/8/8/8/3p1p2/4p3/4P3/K7 w - - 0 1');
      expect(targetsFrom(s, 'e2'), isEmpty);
      final t = fen('7k/8/8/8/8/3p1p2/4P3/K7 w - - 0 1');
      expect(targetsFrom(t, 'e2'), {'e3', 'd3', 'f3'});
    });

    test('second player baidaqs move down the board', () {
      final s = fen('k7/4p3/8/8/8/8/8/7K b - - 0 1');
      expect(targetsFrom(s, 'e7'), {'e6'});
    });

    test('R7 no en passant', () {
      // A black baidaq steps next to a white one: no capture "in passing".
      var s = fen('4k3/3p4/8/4P3/8/8/8/4K3 b - - 0 1');
      s = game.play(s, mv('d7d6'));
      s = game.play(s, mv('e1d1'));
      s = game.play(s, mv('d6d5'));
      expect(targetsFrom(s, 'e5'), {'e6'});
    });

    test('TP6 R9 promotes to a firzān only, on the last rank', () {
      final s = fen('8/4P3/8/p7/8/8/k7/7K w - - 0 1');
      final moves =
          game.legalMoves(s).where((m) => m.from == sq('e7')).toList();
      expect(moves, [mv('e7e8')]);
      final after = game.play(s, moves.single);
      expect(after.pieceAt(sq('e8'))!.type, PieceType.firzan);
      expect(after.pieceAt(sq('e8'))!.owner, Player.first);
    });

    test('R9a promotion is legal with a firzān already on the board', () {
      final s = fen('8/4P3/8/p7/8/8/k7/3Q3K w - - 0 1');
      final after = game.play(s, mv('e7e8'));
      expect(after.pieceAt(sq('e8'))!.type, PieceType.firzan);
      expect(after.pieceAt(sq('d1'))!.type, PieceType.firzan);
    });

    test('R9 a capturing promotion also becomes a firzān (second player)', () {
      final s = fen('k7/8/8/8/8/8/3p4/2R4K b - - 0 1');
      final after = game.play(s, mv('d2c1'));
      expect(after.pieceAt(sq('c1')),
          (type: PieceType.firzan, owner: Player.second));
    });

    test('R9b a new firzān has no special first leap', () {
      final s = game.play(fen('8/4P3/8/p7/8/8/k7/7K w - - 0 1'), mv('e7e8'));
      final t = game.play(s, mv('a2a3'));
      expect(targetsFrom(t, 'e8'), {'d7', 'f7'});
    });
  });

  group('R8 castling', () {
    test('TP7 no castling', () {
      final s = fen('4k3/8/8/8/8/8/8/4K2R w - - 0 1');
      expect(s.legalMoves, isNot(contains(mv('e1g1'))));
      expect(targetsFrom(s, 'e1'), {'d1', 'd2', 'e2', 'f1', 'f2'});
    });
  });

  group('check and mate', () {
    test('R11 check is detected', () {
      final s = fen('4k3/8/8/8/8/8/8/4R2K b - - 0 1');
      expect(s.isCheck, isTrue);
    });

    test('R12 moves that leave the shāh in check are illegal', () {
      // The pinned black rukh may not leave the e-file.
      final s = fen('4k3/4r3/8/8/8/8/8/4R2K b - - 0 1');
      expect(targetsFrom(s, 'e7'), {'e6', 'e5', 'e4', 'e3', 'e2', 'e1'});
    });

    test('R12 a shāh may not step next to the enemy shāh', () {
      final s = fen('8/8/8/3k4/8/3K4/8/8 w - - 0 1');
      expect(targetsFrom(s, 'd3'), isNot(contains('d4')));
      expect(targetsFrom(s, 'd3'), isNot(contains('c4')));
    });

    test('TP8 R13 checkmate: the checking side wins', () {
      final s = fen('R6k/p7/6K1/8/8/8/8/8 b - - 0 1');
      expect(game.result(s), const Win(Player.first, ShatranjReason.checkmate));
      expect(game.legalMoves(s), isEmpty);
    });

    test('R13 a mating move ends the game', () {
      final s = fen('7k/8/6K1/8/8/7p/7P/R7 w - - 0 1');
      final after = game.play(s, mv('a1a8'));
      expect(game.result(after),
          const Win(Player.first, ShatranjReason.checkmate));
    });
  });

  group('R14 stalemate (D1)', () {
    const stalemated = 'k7/p1K5/P7/8/8/8/8/8 b - - 0 1';
    test('TP9 default: the stalemating player wins', () {
      expect(game.result(fen(stalemated)),
          const Win(Player.first, ShatranjReason.stalemate));
    });
    test('TP9 Indian rule: the stalemated player wins', () {
      const g = Shatranj(stalemate: StalemateRule.stalematedWins);
      expect(g.result(fen(stalemated)),
          const Win(Player.second, ShatranjReason.stalemate));
    });
    test('TP9 modern rule: draw', () {
      const g = Shatranj(stalemate: StalemateRule.draw);
      expect(g.result(fen(stalemated)), const Draw(ShatranjReason.stalemate));
    });
  });

  group('R15–R19 bare king (D3)', () {
    test('TP10 R16 baring wins when the bared shāh cannot bare back', () {
      final s = game.play(fen('4k3/8/8/n7/8/8/8/R3K3 w - - 0 1'), mv('a1a5'));
      expect(game.result(s), const Win(Player.first, ShatranjReason.bareKing));
    });

    test('TP11 R17/R20 counter-baring is a draw', () {
      var s = game.play(fen('4k3/3p4/8/8/8/8/8/K2R4 w - - 0 1'), mv('d1d7'));
      expect(game.result(s), GameResult.ongoing,
          reason: 'black gets one reply');
      s = game.play(s, mv('e8d7'));
      expect(game.result(s), const Draw(ShatranjReason.bareKings));
    });

    test('TP11 R17 the bared side does not bare back: the baring side wins',
        () {
      var s = game.play(fen('4k3/3p4/8/8/8/8/8/K2R4 w - - 0 1'), mv('d1d7'));
      s = game.play(s, mv('e8f8'));
      expect(game.result(s), const Win(Player.first, ShatranjReason.bareKing));
    });

    test('TP11 R17a Medina rule: the first to bare wins at once', () {
      const medina = Shatranj(bareKing: BareKingRule.medina);
      final s =
          medina.play(fen('4k3/3p4/8/8/8/8/8/K2R4 w - - 0 1'), mv('d1d7'));
      expect(
          medina.result(s), const Win(Player.first, ShatranjReason.bareKing));
    });

    test('TP12 R17b a protected last man cannot be taken back', () {
      final s = game.play(fen('2K1k3/3p4/8/8/8/8/8/3R4 w - - 0 1'), mv('d1d7'));
      expect(game.result(s), const Win(Player.first, ShatranjReason.bareKing));
    });

    test('TP13 R19 a baring check answered by capturing the checker is a draw',
        () {
      var s = game.play(fen('4k3/4p3/8/8/8/8/8/4R2K w - - 0 1'), mv('e1e7'));
      expect(s.isCheck, isTrue);
      expect(game.result(s), GameResult.ongoing);
      s = game.play(s, mv('e8e7'));
      expect(game.result(s), const Draw(ShatranjReason.bareKings));
    });

    test('TP14 R18 mate takes priority over baring', () {
      final s = game.play(fen('n6k/8/6K1/8/8/8/8/R7 w - - 0 1'), mv('a1a8'));
      expect(game.result(s), const Win(Player.first, ShatranjReason.checkmate));
    });

    test('R18 a move that bares and stalemates wins for the baring side', () {
      // Black: shāh a8 and a faras on b1. Rxb1 bares black, and the black
      // shāh then has no legal move without being in check.
      final s = game.play(fen('k7/8/1K6/8/8/8/8/1n5R w - - 0 1'), mv('h1b1'));
      expect(s.isCheck, isFalse);
      expect(game.legalMoves(s), isEmpty);
      expect(game.result(s), const Win(Player.first, ShatranjReason.bareKing));
      const indian = Shatranj(stalemate: StalemateRule.stalematedWins);
      expect(
          indian.result(s), const Win(Player.first, ShatranjReason.bareKing));
    });

    test('R15 baidaqs count as men: a side with a baidaq is not bare', () {
      final s = fen('4k3/p7/8/8/8/8/8/R3K3 w - - 0 1');
      expect(game.result(s), GameResult.ongoing);
    });
  });

  group('R22 draws (house rules, D5)', () {
    test('TP15 R22a threefold repetition is a draw', () {
      final start = fen('4k3/7p/8/8/8/8/7P/R3K3 w - - 0 1');
      final shuffle = ['a1a2', 'e8d8', 'a2a1', 'd8e8'];
      var s = playAll(start, shuffle);
      expect(s.occurrences, 2);
      expect(game.result(s), GameResult.ongoing);
      s = playAll(s, shuffle);
      expect(s.occurrences, 3);
      expect(game.result(s), const Draw(ShatranjReason.threefoldRepetition));
    });

    test('R22a can be turned off', () {
      const g = Shatranj(repetitionDraw: false);
      final shuffle = ['a1a2', 'e8d8', 'a2a1', 'd8e8'];
      final s = playAll(
          fen('4k3/7p/8/8/8/8/7P/R3K3 w - - 0 1'), [...shuffle, ...shuffle], g);
      expect(g.result(s), GameResult.ongoing);
    });

    test('TP16 R22b 140 plies with no capture or baidaq move is a draw', () {
      final s = fen('4k3/7p/8/8/8/8/7P/R3K3 w - - 139 80');
      expect(game.result(s), GameResult.ongoing);
      final after = game.play(s, mv('a1b1'));
      expect(after.quietPlies, 140);
      expect(game.result(after), const Draw(ShatranjReason.moveLimit));
    });

    test('TP16 R22b the counter resets on captures and baidaq moves', () {
      var s = fen('4k3/p7/8/8/8/8/4P3/R3K3 w - - 50 30');
      s = game.play(s, mv('e2e3'));
      expect(s.quietPlies, 0);
      s = game.play(s, mv('e8d8'));
      expect(s.quietPlies, 1);
      s = game.play(s, mv('a1a7'));
      expect(s.quietPlies, 0);
      expect(s.history, isEmpty);
    });
  });

  group('R1 turns', () {
    test('players alternate and the full-move number advances', () {
      var s = game.initialState;
      s = game.play(s, mv('e2e3'));
      expect(s.toMove, Player.second);
      expect(s.fullMove, 1);
      s = game.play(s, mv('e7e6'));
      expect(s.toMove, Player.first);
      expect(s.fullMove, 2);
    });

    test('a move by the wrong side is rejected', () {
      expect(() => game.play(game.initialState, mv('e7e6')),
          throwsA(isA<IllegalMoveException>()));
    });
  });

  group('setup strings', () {
    test('parse and print round-trip', () {
      for (final f in [
        Shatranj.standardFen,
        Shatranj.mirroredFen,
        '4k3/3p4/8/8/8/8/8/K2R4 w - - 12 40',
        'k7/p1K5/P7/8/8/8/8/8 b - - 0 1',
      ]) {
        expect(fen(f).toFen(), f);
      }
    });

    test('castling and en-passant fields are rejected', () {
      expect(
          () => fen('4k3/8/8/8/8/8/8/4K2R w K - 0 1'), throwsFormatException);
      expect(
          () => fen('4k3/8/8/8/8/8/8/4K2R w - e3 0 1'), throwsFormatException);
      expect(() => fen('4k3/8/8/8/8/8/8 w - - 0 1'), throwsFormatException);
      expect(
          () => fen('4k3/8/8/8/8/8/8/4K2X w - - 0 1'), throwsFormatException);
    });
  });
}
