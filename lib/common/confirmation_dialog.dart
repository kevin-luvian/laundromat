import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    Key? key,
    required this.onContinue,
  }) : super(key: key);

  final void Function() onContinue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Please Confirm'),
      content: const Text('Are you sure to remove the box?'),
      actions: [
        // The "Yes" button
        TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Future.delayed(const Duration(milliseconds: 100));
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
