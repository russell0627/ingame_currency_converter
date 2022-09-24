import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: const ShinyRockForm(),
          ),
        ),
      ),
    );
  }
}

class ShinyRockForm extends StatefulWidget {
  const ShinyRockForm({super.key});

  @override
  ShinyRockFormState createState() {
    return ShinyRockFormState();
  }
}

class ShinyRockFormState extends State<ShinyRockForm> {
  String _currentShinyRocksStr = '';
  String _neededShinyRocksStr = '';

  String? _currentShinyRocksError;
  String? _neededShinyRocksError;

  bool get enableSubmit =>
      _currentShinyRocksError == null &&
      _neededShinyRocksError == null &&
      _currentShinyRocksStr.isNotEmpty &&
      _neededShinyRocksStr.isNotEmpty;

  double _subTotal = 0;
  double _salesTax = 0;
  double _total = 0;

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
            labelText: "How many shiny rocks do you have?",
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
            labelText: "How many shiny rocks do you need?",
            errorText: _neededShinyRocksError,
          ),
          onChanged: (value) {
            setState(() {
              _neededShinyRocksStr = value;
              _neededShinyRocksError = _numValidator(value);
            });
          },
        ),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: enableSubmit ? () => null : null,
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
    final neededShinyRocks = int.tryParse(_neededShinyRocksStr) ?? 0;

    final shinyRocksDelta = neededShinyRocks - currentShinyRocks;
  }

  List<ShinyRockPack> _getPacks(int delta) {
    final List<ShinyRockPack> packs = [];

    int workingDelta = delta;

    while (workingDelta > ShinyRockPack.smallest.qty) {
      for (final packType in ShinyRockPack.values) {
        if (workingDelta >= packType.qty) {
          packs.add(packType);
          workingDelta -= packType.qty;
        }
      }
    }

    if (workingDelta > 0) {
      packs.add(ShinyRockPack.small);
    }

    return packs;
  }
}
