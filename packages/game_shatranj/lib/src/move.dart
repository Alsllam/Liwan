import 'square.dart';

/// A shatranj move: a piece goes from [from] to [to].
///
/// There are no move kinds to choose: no castling (R8), no en passant (R7),
/// and promotion is always to a firzān (R9), so it is implied by the move.
final class ShatranjMove {
  const ShatranjMove(this.from, this.to);

  /// Parses the wire form, e.g. `e2e3`. Throws [FormatException].
  factory ShatranjMove.parse(String text) {
    final t = text.trim();
    if (t.length != 4) throw FormatException('Bad move "$text".');
    return ShatranjMove(
      Square.parse(t.substring(0, 2)),
      Square.parse(t.substring(2)),
    );
  }

  final int from;
  final int to;

  /// Wire form, e.g. `e2e3`.
  String get notation => '${Square.name(from)}${Square.name(to)}';

  @override
  bool operator ==(Object other) =>
      other is ShatranjMove && other.from == from && other.to == to;

  @override
  int get hashCode => from * 64 + to;

  @override
  String toString() => notation;
}
