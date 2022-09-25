/// The algorithm expects these values to be in descending order.
enum ShinyRockPack {
  large(5000, 19.99),
  medium(2200, 9.99),
  small(1000, 4.99);

  final int qty;
  final double cost;

  const ShinyRockPack(this.qty, this.cost);
}