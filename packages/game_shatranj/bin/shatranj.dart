// Play shatranj against the Liwan AI on the command line.
//
//   dart run game_shatranj:shatranj --level 3 --side first
//   dart run game_shatranj:shatranj --selfplay 2,4 --games 4
//
// Moves are typed as from-square + to-square, e.g. `e2e3`.
import 'dart:io';
import 'dart:math';

import 'package:game_core/game_core.dart';
import 'package:game_shatranj/game_shatranj.dart';

const _usage = '''
Shatranj (شطرنج) — play against the Liwan AI.

Options:
  --level N          AI level 1–5 (1 beginner … 5 master). Default 3.
  --side first|second  Your side. First moves first. Default first.
  --seed N           Random seed for the AI. Default: random.
  --fen "..."        Start from a setup string.
  --medina           Medina bare-king rule (first to bare wins).
  --stalemate win|loss|draw   Stalemate result for the stalemating side. Default win.
  --mirrored         Heritage setup (each shāh faces the enemy firzān).
  --arabic           Describe moves in Arabic.
  --selfplay A,B     AI level A (first) vs AI level B (second), no human.
  --games N          Number of self-play games. Default 1.

Commands while playing:
  e2e3      play a move          moves   list legal moves
  hint      ask the AI           undo    take back your last move
  board     show the board       help    this text
  quit
''';

void main(List<String> args) {
  final opts = _parse(args);
  if (opts.containsKey('help')) {
    stdout.write(_usage);
    return;
  }
  final game = Shatranj(
    bareKing: opts.containsKey('medina')
        ? BareKingRule.medina
        : BareKingRule.counterBareDraws,
    stalemate: switch (opts['stalemate']) {
      'loss' => StalemateRule.stalematedWins,
      'draw' => StalemateRule.draw,
      _ => StalemateRule.stalematerWins,
    },
    setup: opts.containsKey('mirrored')
        ? ShatranjSetup.mirrored
        : ShatranjSetup.standard,
  );
  final seed = int.tryParse(opts['seed'] ?? '') ?? Random().nextInt(1 << 30);
  final arabic = opts.containsKey('arabic');
  final start = opts['fen'] != null
      ? ShatranjState.fromFen(opts['fen']!)
      : game.initialState;

  final selfplay = opts['selfplay'];
  if (selfplay != null) {
    final levels = selfplay.split(',').map(int.parse).toList();
    final games = int.tryParse(opts['games'] ?? '') ?? 1;
    _selfPlay(game, start, ShatranjLevels.byId(levels[0]),
        ShatranjLevels.byId(levels[1]), games, seed, arabic);
    return;
  }

  final level = ShatranjLevels.byId(int.tryParse(opts['level'] ?? '') ?? 3);
  final human = opts['side'] == 'second' ? Player.second : Player.first;
  _play(game, start, level, human, seed, arabic);
}

void _play(Shatranj game, ShatranjState start, AiLevel level, Player human,
    int seed, bool arabic) {
  final ai = shatranjAi(game, random: Random(seed));
  final history = <ShatranjState>[start];
  stdout.writeln(
      'Shatranj — you play ${human == Player.first ? 'first (red, bottom)' : 'second (indigo, top)'}; AI level ${level.id}; seed $seed.');
  stdout.writeln('Type "help" for commands.\n');
  _printBoard(history.last);

  while (true) {
    final s = history.last;
    final result = game.result(s);
    if (result.isOver) {
      stdout.writeln(_describeResult(result, human));
      return;
    }
    if (game.toMove(s) != human) {
      final watch = Stopwatch()..start();
      final m = ai.chooseMove(s, level);
      stdout.writeln(
          'AI: ${describeMove(s, m, arabic: arabic)}  (${watch.elapsedMilliseconds} ms)');
      history.add(game.apply(s, m));
      _printBoard(history.last);
      continue;
    }
    if (s.isCheck) stdout.writeln('شاه! Your shāh is in check.');
    stdout.write('Your move> ');
    final line = stdin.readLineSync()?.trim();
    if (line == null || line == 'quit') return;
    switch (line) {
      case '':
        continue;
      case 'help':
        stdout.write(_usage);
      case 'board':
        _printBoard(s);
      case 'moves':
        stdout.writeln(game
            .legalMoves(s)
            .map((m) => describeMove(s, m, arabic: arabic))
            .join(', '));
      case 'hint':
        final r = ai.analyse(s, ShatranjLevels.expert);
        stdout.writeln(
            'Hint: ${describeMove(s, r.bestMove!, arabic: arabic)} (score ${r.score}, depth ${r.depth})');
      case 'undo':
        if (history.length >= 3) {
          history.removeRange(history.length - 2, history.length);
          _printBoard(history.last);
        } else {
          stdout.writeln('Nothing to undo.');
        }
      default:
        try {
          final next = game.play(s, ShatranjMove.parse(line));
          history.add(next);
          _printBoard(next);
        } on FormatException {
          stdout.writeln('Type a move like e2e3, or "help".');
        } on IllegalMoveException {
          stdout.writeln(
              'That move is not legal here. Type "moves" to see the legal moves.');
        }
    }
  }
}

void _selfPlay(Shatranj game, ShatranjState start, AiLevel a, AiLevel b,
    int games, int seed, bool arabic) {
  final results = <String, int>{};
  for (var g = 0; g < games; g++) {
    final first = shatranjAi(game, random: Random(seed + 2 * g));
    final second = shatranjAi(game, random: Random(seed + 2 * g + 1));
    var s = start;
    var plies = 0;
    while (!game.result(s).isOver) {
      final firstToMove = game.toMove(s) == Player.first;
      final m =
          (firstToMove ? first : second).chooseMove(s, firstToMove ? a : b);
      if (games == 1) {
        final number = '${plies ~/ 2 + 1}${firstToMove ? '.' : '...'}';
        stdout.writeln('$number ${describeMove(s, m, arabic: arabic)}');
      }
      s = game.apply(s, m);
      plies++;
    }
    final r = game.result(s);
    final label = switch (r) {
      Win(:final winner, :final reason) =>
        '${winner == Player.first ? 'level ${a.id} (first)' : 'level ${b.id} (second)'} wins by $reason',
      Draw(:final reason) => 'draw by $reason',
      Ongoing() => 'unfinished',
    };
    stdout.writeln('Game ${g + 1}: $label after $plies plies.');
    results[label.split(' by ').first] =
        (results[label.split(' by ').first] ?? 0) + 1;
  }
  if (games > 1) stdout.writeln('Summary: $results');
}

// Board letters (rules doc §3.1 diagram): K shāh, F firzān, E fīl,
// N faras, R rukh, P baidaq. Uppercase = first player (red).
const _letters = {1: 'K', 2: 'F', 3: 'E', 4: 'N', 5: 'R', 6: 'P'};

void _printBoard(ShatranjState s) {
  final sb = StringBuffer();
  for (var rank = 7; rank >= 0; rank--) {
    sb.write(' ${rank + 1}  ');
    for (var file = 0; file < 8; file++) {
      final v = s.at(Square.of(file, rank));
      sb.write(v == 0
          ? '. '
          : '${v > 0 ? _letters[v]! : _letters[-v]!.toLowerCase()} ');
    }
    if (rank == 7) sb.write('   K shāh شاه · F firzān فرزان · E fīl فيل');
    if (rank == 6) sb.write('   N faras فرس · R rukh رخ · P baidaq بيدق');
    if (rank == 5) sb.write('   UPPERCASE = first (red), lowercase = second');
    sb.writeln();
  }
  sb.writeln('    a b c d e f g h');
  sb.writeln(
      '    ${s.toMove == Player.first ? 'First' : 'Second'} to move · quiet plies ${s.quietPlies}/140');
  stdout.write(sb);
}

String _describeResult(GameResult r, Player human) => switch (r) {
      Win(:final winner, :final reason) =>
        '${winner == human ? 'You win' : 'The AI wins'} by ${_reasonText(reason)}.',
      Draw(:final reason) => 'Draw: ${_reasonText(reason)}.',
      Ongoing() => '',
    };

String _reasonText(String reason) => switch (reason) {
      ShatranjReason.checkmate => 'checkmate (shāh māt — شاه مات)',
      ShatranjReason.stalemate =>
        'stalemate (in shatranj the stalemating player wins)',
      ShatranjReason.bareKing => 'bare king (all men captured)',
      ShatranjReason.bareKings => 'shāh against shāh',
      ShatranjReason.threefoldRepetition =>
        'threefold repetition (Liwan house rule)',
      ShatranjReason.moveLimit =>
        '70 moves without a capture or baidaq move (Liwan house rule)',
      _ => reason,
    };

Map<String, String?> _parse(List<String> args) {
  final out = <String, String?>{};
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (!a.startsWith('--')) continue;
    final key = a.substring(2);
    const flags = {'medina', 'mirrored', 'arabic', 'help'};
    if (flags.contains(key)) {
      out[key] = null;
    } else if (i + 1 < args.length) {
      out[key] = args[++i];
    }
  }
  return out;
}
