import 'package:flutter/cupertino.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/sql_page.dart';
import 'package:myapp/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(title: 'Flutter Demo', home: LoginPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
            label: 'SQL',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Configuraciones',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return HomePage(counter: _counter, onIncrement: _incrementCounter);
          case 1:
            return const SQLPage();
          case 2:
            return SettingsPage(
              counter: _counter,
              onIncrement: _incrementCounter,
            );
          default:
            return HomePage(counter: _counter, onIncrement: _incrementCounter);
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.counter, required this.onIncrement});

  final int counter;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Inicio')),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$counter',
                style: CupertinoTheme.of(
                  context,
                ).textTheme.navLargeTitleTextStyle,
              ),
              CupertinoButton(
                onPressed: onIncrement,
                child: const Text("Incrementar contador"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
