String formatCurrency(int amount) {
  final String amountStr = amount.toString();
  final StringBuffer result = StringBuffer();

  for (int i = 0; i < amountStr.length; i++) {
    if (i > 0 && (amountStr.length - i) % 3 == 0) {
      result.write(',');
    }
    result.write(amountStr[i]);
  }

  return result.toString();
}

