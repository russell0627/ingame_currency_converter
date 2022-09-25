const utahSalesTaxRate = .07;

extension IterableIntX on Iterable<int> {
  int sum() => fold(0, (int total, int current) => total + current);
}

extension IterableDblX on Iterable<double> {
  double sum() => fold(0, (double total, double current) => total + current);
}
