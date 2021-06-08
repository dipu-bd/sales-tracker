String formatCurrency(double value) {
  List<int> chars = value.ceil().toString().codeUnits;
  List<int> result = [];
  for (int i = chars.length - 1; i >= 0; --i) {
    int p = chars.length - (i + 1);
    if (p > 0 && [3, 5, 0].contains(p % 7)) {
      result.add(','.codeUnitAt(0));
    }
    result.add(chars[i]);
  }
  return String.fromCharCodes(result.reversed) + '/='; // '৳';
}
