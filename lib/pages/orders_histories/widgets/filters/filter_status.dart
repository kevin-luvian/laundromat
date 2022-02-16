import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/cubits/orders/orders_filter_cubit.dart';
import 'package:laundry/hooks/use_bool.dart';
import 'package:laundry/hooks/use_single_lock.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/declare.dart';
import 'package:laundry/styles/theme.dart';

final filterStatusWidgetIcon =
    FilterWidgetIcon(Icons.info_outline_rounded, false);

class FilterStatusWidget extends HookWidget {
  const FilterStatusWidget({Key? key}) : super(key: key);

  @override
  build(context) {
    final cubit = context.read<OrdersFilterCubit>();
    final lock = useSingleLock();
    final sent = useBool(false);
    final waiting = useBool(false);
    final deleted = useBool(false);

    useEffect(() {
      sent.set(cubit.statuses.sent);
      waiting.set(cubit.statuses.waiting);
      deleted.set(cubit.statuses.deleted);
    }, []);

    useEffect(() {
      lock.run(() => cubit.modifyStatuses(
          sent: sent.value, waiting: waiting.value, deleted: deleted.value));
    }, [sent.value, waiting.value, deleted.value]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _button(text: "sent", active: sent.value, onPressed: sent.toggle),
          const SizedBox(height: 10),
          _button(
              text: "waiting",
              active: waiting.value,
              onPressed: waiting.toggle),
          const SizedBox(height: 10),
          _button(
              text: "deleted",
              active: deleted.value,
              onPressed: deleted.toggle),
        ],
      ),
    );
  }

  RectButton _button({
    required String text,
    required bool active,
    required void Function() onPressed,
  }) {
    return RectButton(
      color: active ? null : GlobalColor.dim,
      onPressed: onPressed,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }
}
