import 'package:flutter/cupertino.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Ajustes'),
      ),
      child: Center(
        child: Text('Aquí irán las opciones de configuración.'),
      ),
    );
  }
}
