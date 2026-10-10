import 'package:game_core/game_core.dart';

/// Tic-tac-toe: perfect play is a draw. Board cells: 0 empty, 1 first, 2 second.
class TicTacToeState {
  const TicTacToeState(this.cells, this.toMove);

  final List<int> cells;
  final Player toMove;

  @override
  bool operator ==(Object other) =>
      other is TicTacToeState &&
      other.toMove == toMove &&
      _listEq(other.cells, cells);

  @override
  int get hashCode => Object.hash(toMove, Object.hashAll(cells));
}

bool _listEq(List<int> a, List<int> b) {
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

class TicTacToe implements Game<TicTacToeState, int> {
  static const _lines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], //
    [0, 3, 6], [1, 4, 7], [2, 5, 8], //
    [0, 4, 8], [2, 4, 6],
  ];

  @override
  String get id => 'tictactoe';

  @override
  TicTacToeState get initialState =>
      TicTacToeState(List.filled(9, 0), Player.first);

  @override
  Player toMove(TicTacToeState state) => state.toMove;

  @override
  List<int> legalMoves(TicTacToeState state) => result(state).isOver
      ? const []
      : [
          for (var i = 0; i < 9; i++)
            if (state.cells[i] == 0) i
        ];

  @override
  TicTacToeState apply(TicTacToeState state, int move) {
    final cells = List.of(state.cells)
      ..[move] = state.toMove == Player.first ? 1 : 2;
    return TicTacToeState(List.unmodifiable(cells), state.toMove.opponent);
  }

  @override
  GameResult result(TicTacToeState state) {
    for (final l in _lines) {
      final v = state.cells[l[0]];
      if (v != 0 && v == state.cells[l[1]] && v == state.cells[l[2]]) {
        return Win(v == 1 ? Player.first : Player.second, 'line');
      }
    }
    return state.cells.contains(0) ? GameResult.ongoing : const Draw('full');
  }
}

/// Nim with one heap, take 1–3; the player who takes the last stone wins.
/// The side to move wins exactly when heap % 4 != 0, by leaving a multiple of 4.
class NimState {
  const NimState(this.heap, this.toMove);

  final int heap;
  final Player toMove;

  @override
  bool operator ==(Object other) =>
      other is NimState && other.heap == heap && other.toMove == toMove;

  @override
  int get hashCode => Object.hash(heap, toMove);
}

class Nim implements Game<NimState, int> {
  Nim(this.start);

  final int start;

  @override
  String get id => 'nim';

  @override
  NimState get initialState => NimState(start, Player.first);

  @override
  Player toMove(NimState state) => state.toMove;

  @override
  List<int> legalMoves(NimState state) =>
      [for (var t = 1; t <= 3 && t <= state.heap; t++) t];

  @override
  NimState apply(NimState state, int move) =>
      NimState(state.heap - move, state.toMove.opponent);

  @override
  GameResult result(NimState state) => state.heap == 0
      ? Win(state.toMove.opponent, 'last-stone')
      : GameResult.ongoing;
}
