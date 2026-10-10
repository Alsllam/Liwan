import '../player.dart';

/// Scores a non-terminal state from [perspective]'s point of view.
///
/// Positive is good for [perspective]. Scores should stay well inside
/// ±[winScore] / 2 so that wins and losses always outrank evaluations.
/// Each game package provides its own evaluator (it is game knowledge).
typedef Evaluator<S> = int Function(S state, Player perspective);

/// Score of a won terminal state at the root. Search subtracts the distance
/// in plies, so faster wins score higher.
const int winScore = 1000000;
