import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:laundry/common/inputs/date_input.dart';
import 'package:laundry/cubits/orders/orders_filter_cubit.dart';
import 'package:laundry/hooks/use_single_lock.dart';
import 'package:laundry/pages/orders_histories/widgets/filters/declare.dart';

final filterDateWidgetIcon =
    FilterWidgetIcon(Icons.calendar_today_rounded, false);

class FilterDateWidget extends HookWidget {
  const FilterDateWidget({Key? key}) : super(key: key);

  @override
  build(context) {
    final lock = useSingleLock();
    final firstDate = useState<DateTime?>(null);
    final lastDate = useState<DateTime?>(null);

    useEffect(() {
      final bloc = context.read<OrdersFilterCubit>();
      firstDate.value = bloc.firstDate;
      lastDate.value = bloc.lastDate;
    }, []);

    useEffect(() {
      lock.run(() {
        final bloc = context.read<OrdersFilterCubit>();
        bloc.modifyDate(firstDate.value, lastDate.value);
      });
    }, [firstDate.value, lastDate.value]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          DateInput(
            date: firstDate.value,
            lastDate: lastDate.value,
            onChange: (date) {
              if (date != null && compareDate(date, lastDate.value, false)) {
                return;
              }
              firstDate.value = date;
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text("until"),
          ),
          DateInput(
            date: lastDate.value,
            firstDate: firstDate.value,
            onChange: (date) {
              if (date != null && compareDate(date, firstDate.value, true)) {
                return;
              }
              lastDate.value = date;
            },
          ),
        ],
      ),
    );
  }

  bool compareDate(DateTime? a, DateTime? b, bool lower) {
    if (a == null || b == null) {
      return false;
    } else {
      final compare = a.compareTo(b);
      return lower ? compare < 0 : compare > 0;
    }
  }
}
