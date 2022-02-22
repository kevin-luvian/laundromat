import 'package:flutter/material.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/utils.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    Key? key,
    required this.onContinue,
    required this.content,
  }) : super(key: key);

  final void Function() onContinue;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Please Confirm'),
      content: Container(
          constraints: BoxConstraints(minWidth: screenSize(context).width / 2),
          child: Text(content)),
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await waitMilliseconds(100);
              onContinue();
            },
            child: const Text('Yes')),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        )
      ],
    );
  }
}
