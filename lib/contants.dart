
double getFontSize(int number) {
  if (number < 1000) {
    return 35;
  }
  if (number < 10000) {
    return 32;
  }
  return 28;
}