import 'package:flutter/cupertino.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Inventario'),
      ),
      child: Center(
        child: Text('Aquí se mostrará la lista de productos.'),
      ),
    );
  }
}
