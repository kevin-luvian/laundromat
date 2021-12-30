import 'package:flutter/material.dart';

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
            children: [
              _buildActionSubset(context, Icons.delete, Colors.redAccent),
              _buildActionSubset(
                  context, Icons.print_outlined, Colors.blueAccent),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionCheckout(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.secondary,
        minimumSize: const Size.fromHeight(45),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child:
          const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActionSubset(BuildContext context, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {},
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
