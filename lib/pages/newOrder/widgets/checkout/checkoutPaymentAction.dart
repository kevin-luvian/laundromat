import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutPaymentAction extends StatelessWidget {
  const CheckoutPaymentAction(this.padding) : super(key: null);

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(padding.left, 0, padding.right, padding.bottom),
      child: Column(
        children: [
          _buildActionCheckout(context),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildButtonActions(context),
          )
        ],
      ),
    );
  }

  List<Widget> _buildButtonActions(BuildContext context) {
    return [
      _buildActionSubset(
        icon: Icons.delete,
        color: Colors.redAccent,
        onPressed: () {},
      ),
      _buildActionSubset(
        icon: Icons.print_outlined,
        color: Colors.blueAccent,
        onPressed: () {},
      ),
    ];
  }

  Widget _buildActionCheckout(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.primary,
        minimumSize: const Size.fromHeight(45),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(AppLocalizations.of(context)?.checkout ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionSubset({
    required IconData icon,
    required Color color,
    required void Function() onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.all(5),
        minimumSize: const Size.fromRadius(23),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
      ),
      child: Icon(icon, size: 23),
    );
  }
}