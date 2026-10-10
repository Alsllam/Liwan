// An independent, deliberately simple shatranj move generator used only to
// cross-check the engine (perft). It shares no code with lib/: it works on
// a FEN string with (file, rank) coordinates and recomputes everything.

typedef Sq = (int, int); // (file 0–7, rank 0–7)

class RefPosition {
  RefPosition(this.cells, this.white);

  factory RefPosition.fromFen(String fen) {
    final parts = fen.split(' ');
    final cells = <Sq, String>{};
    final rows = parts[0].split('/');
    for (var i = 0; i < 8; i++) {
      var f = 0;
      for (final ch in rows[i].split('')) {
        final n = int.tryParse(ch);
        if (n != null) {
          f += n;
        } else {
          cells[(f, 7 - i)] = ch;
          f++;
        }
      }
    }
    return RefPosition(cells, parts[1] == 'w');
  }

  final Map<Sq, String> cells;
  final bool white;

  static bool isWhite(String p) => p.toUpperCase() == p;
  static bool inside(int f, int r) => f >= 0 && f < 8 && r >= 0 && r < 8;

  /// Squares a piece of colour [w] standing on [s] could move to, ignoring
  /// check. [attacksOnly] gives baidaq capture squares even when empty.
  List<Sq> targets(Sq s, String p, {bool attacksOnly = false}) {
    final w = isWhite(p);
    final out = <Sq>[];
    final (f, r) = s;
    bool own(Sq t) => cells[t] != null && isWhite(cells[t]!) == w;
    void step(int df, int dr) {
      final t = (f + df, r + dr);
      if (inside(t.$1, t.$2) && !own(t)) out.add(t);
    }

    switch (p.toUpperCase()) {
      case 'K':
        for (final df in [-1, 0, 1]) {
          for (final dr in [-1, 0, 1]) {
            if (df != 0 || dr != 0) step(df, dr);
          }
        }
      case 'Q': // firzān
        for (final df in [-1, 1]) {
          for (final dr in [-1, 1]) {
            step(df, dr);
          }
        }
      case 'B': // fīl
        for (final df in [-2, 2]) {
          for (final dr in [-2, 2]) {
            step(df, dr);
          }
        }
      case 'N':
        for (final (df, dr) in [
          (1, 2),
          (2, 1),
          (-1, 2),
          (-2, 1),
          (1, -2),
          (2, -1),
          (-1, -2),
          (-2, -1)
        ]) {
          step(df, dr);
        }
      case 'R':
        for (final (df, dr) in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
          for (var k = 1; k < 8; k++) {
            final t = (f + df * k, r + dr * k);
            if (!inside(t.$1, t.$2) || own(t)) break;
            out.add(t);
            if (cells[t] != null) break;
          }
        }
      case 'P':
        final dir = w ? 1 : -1;
        for (final df in [-1, 1]) {
          final t = (f + df, r + dir);
          if (!inside(t.$1, t.$2)) continue;
          if (attacksOnly || (cells[t] != null && !own(t))) out.add(t);
        }
        if (!attacksOnly) {
          final t = (f, r + dir);
          if (inside(t.$1, t.$2) && cells[t] == null) out.add(t);
        }
    }
    return out;
  }

  bool attacked(Sq s, bool byWhite) {
    for (final e in cells.entries) {
      if (isWhite(e.value) != byWhite) continue;
      if (targets(e.key, e.value, attacksOnly: true).contains(s)) return true;
    }
    return false;
  }

  RefPosition play(Sq from, Sq to) {
    final next = Map.of(cells);
    var p = next.remove(from)!;
    if (p.toUpperCase() == 'P' && (to.$2 == 7 || to.$2 == 0)) {
      p = isWhite(p) ? 'Q' : 'q';
    }
    next[to] = p;
    return RefPosition(next, !white);
  }

  List<(Sq, Sq)> legal() {
    final out = <(Sq, Sq)>[];
    for (final e in cells.entries.toList()) {
      if (isWhite(e.value) != white) continue;
      for (final t in targets(e.key, e.value)) {
        final next = play(e.key, t);
        final king = next.cells.entries
            .firstWhere((x) => x.value == (white ? 'K' : 'k'))
            .key;
        if (!next.attacked(king, !white)) out.add((e.key, t));
      }
    }
    return out;
  }

  int menOf(bool w) => cells.values
      .where((p) => isWhite(p) == w && p.toUpperCase() != 'K')
      .length;
}

/// Perft with the reference generator. Like the engine, it stops at
/// positions where the game is decided by mate, stalemate or bare king
/// (default rules), so counts are comparable.
int refPerft(RefPosition pos, int depth) {
  if (depth == 0) return 1;
  final moves = pos.legal();
  if (moves.isEmpty) return 0;
  final side = pos.menOf(pos.white), other = pos.menOf(!pos.white);
  if (side == 0 && other == 0) return 0; // shāh against shāh
  if (other == 0) return 0; // the mover was bared and did not bare back
  if (side == 0) {
    // Counter-bare possible only if the opponent has one man the shāh can take.
    final canCounter = other == 1 && moves.any((m) => pos.cells[m.$2] != null);
    if (!canCounter) return 0;
  }
  if (depth == 1) return moves.length;
  var n = 0;
  for (final (a, b) in moves) {
    n += refPerft(pos.play(a, b), depth - 1);
  }
  return n;
}
