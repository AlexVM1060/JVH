import 'package:flutter/cupertino.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.counter,
    required this.onIncrement,
  });

  final int counter;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Configuraciones'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Página de Configuraciones'),
            const SizedBox(height: 8),
            const Text('Este es el texto nuevo.'),
            const SizedBox(height: 24),
            Text(
              'Valor del contador: $counter',
              style: CupertinoTheme.of(context).textTheme.textStyle,
            ),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: onIncrement,
              child: const Text('Incrementar'),
            ),
          ],
        ),
      ),
    );
  }
}
