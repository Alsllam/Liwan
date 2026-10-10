/// Shatranj pieces (`docs/rules/shatranj.md` §3).
///
/// On the board a piece is stored as a small signed integer: the absolute
/// value is the [PieceType] code, positive for the first player and negative
/// for the second. 0 is an empty square.
enum PieceType {
  /// الشاه — king: one step in any direction.
  shah(1, 'K', 'شاه', 'Shāh'),

  /// الفرزان — counsellor: exactly one step diagonally.
  firzan(2, 'Q', 'فرزان', 'Firzān'),

  /// الفيل — elephant: leaps exactly two squares diagonally.
  fil(3, 'B', 'فيل', 'Fīl'),

  /// الفرس — horse: like the modern knight.
  faras(4, 'N', 'فرس', 'Faras'),

  /// الرخ — rook: any distance orthogonally.
  rukh(5, 'R', 'رخ', 'Rukh'),

  /// البيدق — foot soldier: one step forward, captures diagonally forward.
  baidaq(6, 'P', 'بيدق', 'Baidaq');

  const PieceType(this.code, this.fenLetter, this.arabicName, this.englishName);

  /// Board code (1–6).
  final int code;

  /// Letter used in the FEN-style setup string (rules doc §3.1).
  final String fenLetter;
  final String arabicName;
  final String englishName;

  static PieceType fromCode(int code) => values[code.abs() - 1];

  static PieceType fromFenLetter(String letter) {
    final upper = letter.toUpperCase();
    return values.firstWhere(
      (t) => t.fenLetter == upper,
      orElse: () => throw FormatException('Unknown piece letter "$letter".'),
    );
  }
}
