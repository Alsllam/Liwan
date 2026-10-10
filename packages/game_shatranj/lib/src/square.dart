/// Squares are numbered 0–63: `rank * 8 + file`, with file 0 = a and
/// rank 0 = the first player's home rank (rank 1). See rules doc §2 (B4).
abstract final class Square {
  static int file(int sq) => sq & 7;
  static int rank(int sq) => sq >> 3;
  static int of(int file, int rank) => rank * 8 + file;

  /// Algebraic name, e.g. `e2`.
  static String name(int sq) =>
      '${String.fromCharCode(97 + file(sq))}${rank(sq) + 1}';

  /// Parses an algebraic name. Throws [FormatException] on bad input.
  static int parse(String name) {
    if (name.length != 2) throw FormatException('Bad square "$name".');
    final f = name.codeUnitAt(0) - 97;
    final r = name.codeUnitAt(1) - 49;
    if (f < 0 || f > 7 || r < 0 || r > 7) {
      throw FormatException('Bad square "$name".');
    }
    return of(f, r);
  }

  static const _arabicFiles = ['أ', 'ب', 'ج', 'د', 'هـ', 'و', 'ز', 'ح'];
  static const _arabicDigits = ['١', '٢', '٣', '٤', '٥', '٦', '٧', '٨'];

  /// Arabic display name (rules doc §2, B5), e.g. `هـ٢` for e2.
  static String arabicName(int sq) =>
      '${_arabicFiles[file(sq)]}${_arabicDigits[rank(sq)]}';
}
