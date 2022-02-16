import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry/common/rect_button.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/helpers/input_decoration.dart';
import 'package:laundry/pages/new_order/widgets/checkout_dialog/new_customer_dialog.dart';
import 'package:laundry/running_assets/dao_access.dart';
import 'package:laundry/styles/theme.dart';

class CustomerSelectPage extends StatefulWidget {
  const CustomerSelectPage({required this.onContinue}) : super(key: null);

  final void Function() onContinue;

  @override
  _CustomerSelectPageState createState() => _CustomerSelectPageState();
}

class _CustomerSelectPageState extends State<CustomerSelectPage> {
  late StreamSubscription _listener;

  final nameCtr = TextEditingController();
  final phoneCtr = TextEditingController();

  Customer? selectedCustomer;
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];

  void setFilteredCustomer() {
    setState(() {
      filteredCustomers = customers
          .where((c) =>
              c.name.contains(nameCtr.text) || c.phone.contains(phoneCtr.text))
          .toList(growable: false);
      filteredCustomers.sort(sortFilteredCustomer);
    });
  }

  int sortFilteredCustomer(Customer a, Customer b) {
    final aVal = a.name.contains(nameCtr.text);
    final bVal = b.name.contains(nameCtr.text);
    if (aVal && !bVal) {
      return -1;
    } else if (!aVal && bVal) {
      return 1;
    }
    final apVal = a.phone.contains(phoneCtr.text);
    final bpVal = b.phone.contains(phoneCtr.text);
    if (apVal && !bpVal) {
      return -1;
    } else if (!apVal && bpVal) {
      return 1;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    newOrderCacheDao.currentCustomer
        .then((data) => setState(() => selectedCustomer = data));

    _listener = customerDao.streamAll().listen((data) {
      setState(() {
        customers = data;
        setFilteredCustomer();
      });
    });

    nameCtr.addListener(() {
      setFilteredCustomer();
    });
    phoneCtr.addListener(() => setFilteredCustomer());
  }

  @override
  void dispose() {
    super.dispose();
    _listener.cancel();
    nameCtr.dispose();
    phoneCtr.dispose();
  }

  void handleContinue(bool withoutCustomer) {
    final selectedCustomerId = selectedCustomer?.id;
    if (withoutCustomer) {
      newOrderCacheDao.removeCustomer();
    } else if (selectedCustomerId != null) {
      newOrderCacheDao.changeCustomer(selectedCustomerId);
    }
    widget.onContinue();
  }

  @override
  build(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _inputCustomer(),
            const SizedBox(height: 10),
            _addNewCustomerButton(),
            _customerTable(),
            const SizedBox(height: 20),
            // const Spacer(),
            _continueButtons(),
          ],
        ),
      ),
    );
  }

  Widget _inputCustomer() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: nameCtr,
            keyboardType: TextInputType.name,
            decoration: inputDecoration(context, "name"),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: TextFormField(
            controller: phoneCtr,
            decoration: inputDecoration(context, "phone"),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
      ],
    );
  }

  Widget _addNewCustomerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RectButton(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          onPressed: () => showNewCustomerDialog(context),
          size: const Size(0, 35),
          child: Row(children: const [
            Icon(Icons.add),
            SizedBox(width: 5),
            Text("Add Customer"),
          ]),
        ),
      ],
    );
  }

  Widget _customerTable() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 500),
      decoration: BoxDecoration(
        border: Border.all(color: GlobalColor.dim, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredCustomers.length,
        itemBuilder: (_, i) => _customerTableItem(filteredCustomers[i]),
      ),
    );
  }

  Widget _customerTableItem(Customer info) {
    final isSelected = selectedCustomer == info;
    return InkWell(
      onTap: () {
        setState(() => selectedCustomer = info);
      },
      child: Container(
        color: isSelected ? GlobalColor.light : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: Row(
            children: [
              Expanded(child: Text(info.name)),
              Expanded(child: Text(info.phone, textAlign: TextAlign.end)),
            ],
          ),
        ),
      ),
    );
  }

  Row _continueButtons() {
    const buttonSize = Size.fromHeight(57);

    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: RectButton(
            size: buttonSize,
            onPressed: () => handleContinue(true),
            child: const Text("Continue Without Customer"),
          ),
        ),
        const SizedBox(width: 15),
        Flexible(
          fit: FlexFit.tight,
          child: RectButton(
            disabled: selectedCustomer == null,
            size: buttonSize,
            onPressed: () => handleContinue(false),
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }
}
