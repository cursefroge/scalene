import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntervalSettings extends StatefulWidget {
  const IntervalSettings({super.key});

  @override
  State<IntervalSettings> createState() => _IntervalSettingsState();
}

class _IntervalSettingsState extends State<IntervalSettings> {
  String dropdownValue = 'Every Day';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New interval'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            controller: nameController,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: DropdownButton<String>(
            
            value: dropdownValue,
            items: <String>['Every Day', 'Every Week', 'Every Month', 'Every Year']
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            ),
          ),
          // value picker (only numbers)
          TextField(
            decoration: const InputDecoration(
              labelText: 'Amount',
            ),
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*'))],
            controller: amountController,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {            
            final Map<String, String> data = {
              'name': nameController.text,
              'recurrance': dropdownValue,
              'amount': amountController.text,
            };
            Navigator.of(context).pop(data);
          },
        ),
      ],
    );
  }
}