import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BalanceEditor extends StatefulWidget {
  const BalanceEditor({super.key});

  @override
  BalanceEditorState createState() => BalanceEditorState();
}

class BalanceEditorState extends State<BalanceEditor> {
  final balanceEditorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add to Balance'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: TextField(
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*'))],
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              controller: balanceEditorController,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () async{
            Navigator.of(context).pop(int.parse(balanceEditorController.text));
          },
        )
      ],
    );
  }
}