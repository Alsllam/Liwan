import 'package:game_core/game_core.dart';

import 'board.dart';
import 'move.dart';
import 'state.dart';

/// Material values in centi-baidaqs. Shatranj pieces are weak, so the rukh
/// dominates and the firzān and fīl are worth little more than a baidaq.
const pieceValues = [0, 0, 170, 130, 310, 480, 100]; // index = piece code

// Centralisation bonus for short-range pieces (faras, firzān, shāh in the
// ending), by distance from the centre.
final List<int> _centre = [
  for (var sq = 0; sq < 64; sq++)
    () {
      final f = sq & 7, r = sq >> 3;
      final df = f < 4 ? 3 - f : f - 4;
      final dr = r < 4 ? 3 - r : r - 4;
      return 6 - (df + dr);
    }(),
];

/// Static evaluation of [state] for [perspective] (positive = better).
///
/// Game knowledge for the AI: material, centralisation, baidaq advance, and
/// the bare-king danger (losing all men loses the game, R16).
int evaluateShatranj(ShatranjState state, Player perspective) {
  final b = state.rawBoard;
  var score = 0;
  var menFirst = 0, menSecond = 0, material = 0;
  for (var sq = 0; sq < 64; sq++) {
    final v = b[sq];
    if (v == 0) continue;
    final code = v.abs();
    final s = v > 0 ? 1 : -1;
    if (code != shah) {
      if (s > 0) {
        menFirst++;
      } else {
        menSecond++;
      }
      material += pieceValues[code];
    }
    var bonus = pieceValues[code];
    switch (code) {
      case faras:
        bonus += 4 * _centre[sq];
      case firzan:
        bonus += 3 * _centre[sq];
      case baidaq:
        // Advance: rank 2 → 0 … rank 7 → 30 (promotion is near).
        final adv = s > 0 ? (sq >> 3) - 1 : 6 - (sq >> 3);
        bonus += adv * adv;
      case rukh:
        bonus += _centre[sq];
    }
    score += s * bonus;
  }
  // The shāh: stay safe while many men remain, walk to the centre later.
  final endgame = material < 1600;
  for (final p in Player.values) {
    final k = findShah(b, p);
    if (k < 0) continue;
    score += sideSign(p) * (endgame ? 5 * _centre[k] : -2 * _centre[k]);
  }
  // Bare-king danger: each man matters more when a side has few left.
  int danger(int men) => men >= 4 ? 0 : (4 - men) * (4 - men) * 40;
  score += danger(menSecond) - danger(menFirst);
  return perspective == Player.first ? score : -score;
}

/// Move ordering: captures of valuable pieces by cheap ones first,
/// promotions next.
int scoreShatranjMove(ShatranjState state, ShatranjMove move) {
  final victim = state.at(move.to).abs();
  final attacker = state.at(move.from).abs();
  var score = 0;
  if (victim != 0) {
    score += 10 * pieceValues[victim] - pieceValues[attacker] ~/ 10 + 10000;
  }
  if (attacker == baidaq && ((move.to >> 3) == 7 || (move.to >> 3) == 0)) {
    score += 5000;
  }
  return score;
}

/// Captures and promotions are searched past the depth limit.
bool isNoisyShatranjMove(ShatranjState state, ShatranjMove move) {
  if (state.at(move.to) != 0) return true;
  return state.at(move.from).abs() == baidaq &&
      ((move.to >> 3) == 7 || (move.to >> 3) == 0);
}
