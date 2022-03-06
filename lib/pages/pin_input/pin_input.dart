import 'package:flutter/material.dart';
import 'package:laundry/blocs/auth/bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/helpers/flutter_utils.dart';
import 'package:laundry/helpers/logger.dart';
import 'package:laundry/styles/theme.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinInputPage extends StatefulWidget {
  const PinInputPage(this.targetPin) : super(key: null);
  final String targetPin;

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInputPage> {
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  void handleSubmit(String pin) {
    if (pin == widget.targetPin) {
      context.read<AuthBloc>().add(RePIN(pin));
    } else {
      _pinPutController.text = "";
    }
  }

  void handleLogout() => context.read<AuthBloc>().add(Logout());

  @override
  Widget build(BuildContext context) {
    return onlySelectedBorderPinPut();
  }

  Widget onlySelectedBorderPinPut() {
    final surface = colorScheme(context).surface;
    final primary = colorScheme(context).primary;
    const changeAccHeight = 40.0;
    final pinInputHeight = screenSize(context).height * 1 / 5;
    final pinButtonsHeight =
        screenSize(context).height - pinInputHeight - changeAccHeight;
    final BoxDecoration pinPutDecoration = BoxDecoration(
        color: GlobalColor.light, borderRadius: BorderRadius.circular(5.0));
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: pinInputHeight,
          child: PinPut(
            useNativeKeyboard: false,
            withCursor: true,
            fieldsCount: 4,
            fieldsAlignment: MainAxisAlignment.spaceAround,
            textStyle: TextStyle(fontSize: 25.0, color: primary),
            eachFieldMargin: EdgeInsets.zero,
            eachFieldWidth: 45.0,
            eachFieldHeight: 55.0,
            onSubmit: handleSubmit,
            focusNode: _pinPutFocusNode,
            controller: _pinPutController,
            submittedFieldDecoration: pinPutDecoration,
            selectedFieldDecoration: pinPutDecoration.copyWith(
              color: surface,
              border: Border.all(width: 2, color: primary),
            ),
            followingFieldDecoration: pinPutDecoration,
            pinAnimationType: PinAnimationType.scale,
          ),
        ),
        Material(
          // color: Colors.amberAccent,
          child: SizedBox(
            height: pinButtonsHeight,
            width: pinButtonsHeight * 7.5 / 10,
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((e) {
                  return RoundedButton(
                    title: '$e',
                    onTap: () {
                      if (_pinPutController.text.length >= 5) return;

                      _pinPutController.text = '${_pinPutController.text}$e';
                      _pinPutController.selection = TextSelection.collapsed(
                          offset: _pinPutController.text.length);
                    },
                  );
                }),
                RoundedButton(
                  icon: Icons.keyboard_backspace_rounded,
                  onTap: () {
                    if (_pinPutController.text.isNotEmpty) {
                      _pinPutController.text = _pinPutController.text
                          .substring(0, _pinPutController.text.length - 1);
                      _pinPutController.selection = TextSelection.collapsed(
                          offset: _pinPutController.text.length);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: changeAccHeight,
          child: GestureDetector(
            onTap: handleLogout,
            child: Text(
              "change account",
              style: TextStyle(
                fontSize: 16,
                color: primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final VoidCallback onTap;

  const RoundedButton({this.title, this.icon, required this.onTap})
      : assert(title != null || icon != null),
        super(key: null);

  @override
  Widget build(BuildContext context) {
    final color = colorScheme(context).primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        decoration: const BoxDecoration(shape: BoxShape.circle),
        alignment: Alignment.center,
        child: _content(color),
      ),
    );
  }

  Widget _content(Color color) {
    final mTitle = title;
    if (mTitle != null) {
      return Text(
        mTitle,
        style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
      );
    }

    final mIcon = icon;
    if (mIcon != null) {
      return Icon(mIcon, color: color, size: 30);
    }

    return Container();
  }
}
