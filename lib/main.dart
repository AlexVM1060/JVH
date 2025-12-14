import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/inventory_page.dart';
import 'package:myapp/settings_page.dart';

// Este es el nuevo bloque de código para inicializar Supabase
void main() async {
  // Asegura que todos los bindings de Flutter estén listos antes de ejecutar código nativo.
  WidgetsFlutterBinding.ensureInitialized();
  // Usa el archivo "supabase_options.dart" para conectar tu app con tu proyecto de Supabase.
  await Supabase.initialize(
    url: 'https://yjowjgbzgacfjsvfccwo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlqb3dqZ2J6Z2FjZmpzdmZjY3dvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3NDgyNDIsImV4cCI6MjA4MTMyNDI0Mn0.EmTEEDQxMZ0CR7HIONQjBKeKJn68kGMMkp3T-NVS5wo',
  );
  // Una vez conectado, ejecuta la aplicación.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  final iconList = <IconData>[
    CupertinoIcons.house_fill,
    CupertinoIcons.archivebox_fill,
    CupertinoIcons.settings_solid,
  ];

  final iconLabels = <String>['Inicio', 'Inventario', 'Ajustes'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const HomePage(),
      const InventoryPage(),
      const SettingsPage(),
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
          final color = isActive
              ? CupertinoColors.activeBlue
              : CupertinoColors.secondaryLabel;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconList[index], size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                iconLabels[index],
                maxLines: 1,
                style: TextStyle(color: color, fontSize: 12),
              ),
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
