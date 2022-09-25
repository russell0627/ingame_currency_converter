import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ingame_currency_converter/widgets/shiny_rock_dialog.dart';

import '../data/data.dart';
import '../utils/utils.dart';

class ShinyRockForm extends StatefulWidget {
  const ShinyRockForm({super.key});

  @override
  ShinyRockFormState createState() {
    return ShinyRockFormState();
  }
}

class ShinyRockFormState extends State<ShinyRockForm> {
  String _currentShinyRocksStr = '';
  String _goalShinyRocksStr = '';

  String? _currentShinyRocksError;
  String? _goalShinyRocksError;

  bool get enableSubmit =>
      _currentShinyRocksError == null &&
      _goalShinyRocksError == null &&
      _currentShinyRocksStr.isNotEmpty &&
      _goalShinyRocksStr.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: "Current shiny rocks",
            errorText: _currentShinyRocksError,
          ),
          onChanged: (value) {
            setState(() {
              _currentShinyRocksStr = value;
              _currentShinyRocksError = _numValidator(value);
            });
          },
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            labelText: "Shiny rock goal",
            errorText: _goalShinyRocksError,
          ),
          onChanged: (value) {
            setState(() {
              _goalShinyRocksStr = value;
              _goalShinyRocksError = _numValidator(value);
            });
          },
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: enableSubmit ? _calculate : null,
          child: const Text('Calculate'),
        ),
      ],
    );
  }

  String? _numValidator(String? value) {
    if (value!.isEmpty) {
      return 'This field is required.';
    }

    final count = int.tryParse(value);

    if (count == null || count % 100 != 0) {
      return "Shiny rocks come in batches of 100.";
    }

    return null;
  }

  void _calculate() {
    final currentShinyRocks = int.tryParse(_currentShinyRocksStr) ?? 0;
    final neededShinyRocks = int.tryParse(_goalShinyRocksStr) ?? 0;

    final shinyRocksDelta = neededShinyRocks - currentShinyRocks;

    final packs = _getPacks(shinyRocksDelta);

    final subTotal = packs.map<double>((value) => value.cost).sum();
    print(subTotal);
    final salesTax = subTotal * utahSalesTaxRate;
    print(salesTax);
    final total = subTotal + salesTax;
    print(total);

    showDialog(
      context: context,
      builder: (context) {
        return ShinyRockDialog(
          packs: packs,
          subTotal: subTotal,
          salesTax: salesTax,
          total: total,
        );
      },
    );
  }

  List<ShinyRockPack> _getPacks(int delta) {
    final List<ShinyRockPack> packs = [];

    int workingDelta = delta;

    for (final packType in ShinyRockPack.values) {
      while (workingDelta > packType.qty) {
        packs.add(packType);
        workingDelta -= packType.qty;
      }
    }

    if (workingDelta > 0) {
      packs.add(ShinyRockPack.small);
    }

    return packs;
  }
}
