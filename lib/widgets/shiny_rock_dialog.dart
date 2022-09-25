import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../data/data.dart';

final currencyFormatter = NumberFormat.currency(symbol: '\$');

class ShinyRockDialog extends StatelessWidget {
  final List<ShinyRockPack> packs;
  final double subTotal;
  final double salesTax;
  final double total;

  const ShinyRockDialog({
    Key? key,
    required this.packs,
    required this.subTotal,
    required this.salesTax,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Cost"),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                _buildCell('Subtotal'),
                _buildCell(currencyFormatter.format(subTotal), alignment: TextAlign.right),
              ]),
              TableRow(children: [
                _buildCell('Utah Sales Tax'),
                _buildCell(currencyFormatter.format(salesTax), alignment: TextAlign.right),
              ]),
              TableRow(children: [
                _buildCell('Total'),
                _buildCell(currencyFormatter.format(total), alignment: TextAlign.right),
              ]),
            ],
          ),
        ),
        SimpleDialogOption(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildCell(String content, {TextAlign alignment = TextAlign.left}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(content, textAlign: alignment),
      ),
    );
  }
}
