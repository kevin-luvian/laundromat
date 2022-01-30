import 'package:flutter/material.dart';
import 'package:laundry/common/inputs/box_input_decoration.dart';

class TextAutoComplete extends StatelessWidget {
  TextAutoComplete({
    Key? key,
    required this.label,
    required this.options,
    required this.controller,
    this.validator,
  }) : super(key: key);

  final String label;
  final List<String> options;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  final FocusNode _focusNode = FocusNode();

  void clear() {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      focusNode: _focusNode,
      textEditingController: controller,
      fieldViewBuilder: (_ctx, _ctrl, _fNode, _f) {
        return TextFormField(
          controller: _ctrl,
          focusNode: _fNode,
          decoration: boxInputDecoration(context: _ctx, label: label),
          validator: validator,
          onFieldSubmitted: (_) => _f(),
        );
      },
      optionsBuilder: (TextEditingValue _tVal) {
        return options
            .where((option) => option.contains(_tVal.text.toLowerCase()))
            .toList();
      },
      optionsViewBuilder: (_, _onSelected, _options) {
        const maxOptionsHeight = 150.0;
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: maxOptionsHeight),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _options.length,
                itemBuilder: (_ctx, i) {
                  final option = _options.elementAt(i);
                  final highlight = controller.text == option;
                  if (highlight) {
                    return Container(
                      color: Theme.of(_ctx).focusColor,
                      child: ListTile(title: Text(option)),
                    );
                  }
                  return InkWell(
                    onTap: () => _onSelected(option),
                    child: ListTile(title: Text(option)),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
