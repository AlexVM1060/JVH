import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/inventory_page.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  int _counter = 0;

  final iconList = <IconData>[
    CupertinoIcons.house_fill,
    CupertinoIcons.archivebox_fill,
    CupertinoIcons.settings_solid,
  ];

  final iconLabels = <String>[
    'Inicio',
    'Inventario',
    'Ajustes',
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      HomePage(counter: _counter, onIncrement: _incrementCounter),
      const InventoryPage(),
      SettingsPage(counter: _counter, onIncrement: _incrementCounter),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? CupertinoColors.activeBlue : CupertinoColors.secondaryLabel;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
                size: 24,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                iconLabels[index],
                maxLines: 1,
                style: TextStyle(color: color, fontSize: 12),
              )
            ],
          );
        },
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInSine,
          );
        },
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      ),
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Inicio'),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '$counter',
                style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
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
