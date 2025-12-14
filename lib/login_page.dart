import 'package:flutter/cupertino.dart';
import 'package:myapp/main.dart';
import 'package:myapp/welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_usernameController.text == '1' && _passwordController.text == '1') {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const WelcomePage()),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Usuario o contraseña incorrectos.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Login')),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoTextField(
                controller: _usernameController,
                placeholder: 'Usuario',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Contraseña',
                obscureText: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 32.0),
              CupertinoButton.filled(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
