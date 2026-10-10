/// Shared game interface and classic AI search for Liwan.
///
/// Every Liwan game implements [Game]. The AI ([AiPlayer], [AlphaBetaSearch],
/// [MctsSearch]) works only through that interface, so a new game gets an AI
/// opponent by providing an evaluation function.
library;

export 'src/game.dart';
export 'src/player.dart';
export 'src/result.dart';
export 'src/search/ai_player.dart';
export 'src/search/alpha_beta.dart';
export 'src/search/evaluator.dart';
export 'src/search/mcts.dart';
