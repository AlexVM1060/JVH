import 'package:flutter/cupertino.dart';

class SQLPage extends StatelessWidget {
  const SQLPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('SQL'),
      ),
      child: Center(
        child: Text('Página de SQL'),
      ),
    );
  }
}
