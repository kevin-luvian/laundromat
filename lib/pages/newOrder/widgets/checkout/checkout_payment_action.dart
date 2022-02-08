import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:laundry/blocs/newOrder/new_order_bloc.dart';
import 'package:laundry/common/confirmation_dialog.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/print_handlers/print_orders.dart';
import 'package:laundry/running_assets/dao_access.dart';

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
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => ConfirmationDialog(
            content: "Remove current orders?",
            onContinue: () =>
                context.read<NewOrderBloc>().add(ClearCachesEvent()),
          ),
        ),
      ),
      _buildActionSubset(
        icon: Icons.print_outlined,
        color: Colors.blueAccent,
        onPressed: () async {
          // bluetoothBloc.add(PrintEvent());

          final orders = await newOrderCacheDao.allOrderDetails();
          final file = await buildOrdersAsFile(orders);
          if (file == null) return;
          var decodedImage = await decodeImageFromList(file.readAsBytesSync());
          await showDialog<void>(
            context: context,
            builder: (_ctx) => AlertDialog(
              backgroundColor: colorScheme(context).primary,
              content: Card(
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Image.file(
                      file,
                      height: decodedImage.height.toDouble(),
                      width: decodedImage.width.toDouble(),
                    ),
                  ),
                ),
              ),
            ),
          );
          await file.delete();
        },
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
        minimumSize: const Size.fromRadius(25),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
      ),
      child: Icon(icon, size: 23),
    );
  }
}
