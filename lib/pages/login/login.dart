import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/blocs/auth/bloc.dart';
import 'package:laundry/blocs/auth/event.dart';
import 'package:laundry/blocs/auth/state.dart';
import 'package:laundry/helpers/input_formatter/no_whitespaces.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _showPassword = false;

  final nameCtr = TextEditingController();
  final passwordCtr = TextEditingController();

  @override
  void initState() {
    nameCtr.text = "admin";
    passwordCtr.text = "password";
    super.initState();
  }

  @override
  void dispose() {
    nameCtr.dispose();
    passwordCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (_, _state) {
      final authFailed = _state.runtimeType == AuthenticationFailed;

      return _cardWrapper(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            authFailed
                ? Column(
                    children: const [
                      Text(
                        "name or password is invalid",
                        style: TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: 10),
                    ],
                  )
                : Container(),
            TextField(
              controller: nameCtr,
              decoration: const InputDecoration(
                labelText: 'name',
              ),
              inputFormatters: _noWhiteSpacesInput,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordCtr,
              obscureText: !_showPassword,
              inputFormatters: _noWhiteSpacesInput,
              autofillHints: const [AutofillHints.password],
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'password',
                suffixIcon: IconButton(
                  icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() => _showPassword = !_showPassword);
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(Login(nameCtr.text, passwordCtr.text));
                },
                child: const Text("login", style: TextStyle(fontSize: 17)),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _cardWrapper({required BuildContext context, required Widget child}) {
    return Container(
      alignment: Alignment.center,
      child: Wrap(
        children: [
          SizedBox(
            width: 500,
            child: Card(
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 50,
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextInputFormatter> get _noWhiteSpacesInput => [noWhitespacesFormatter];
}
