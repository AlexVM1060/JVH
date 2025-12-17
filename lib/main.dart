import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/inventory_page.dart';
import 'package:myapp/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('theme_mode');
    setState(() {
      switch (stored) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    });
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final key = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await prefs.setString('theme_mode', key);
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        cardColor: Colors.black,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ),
      themeMode: _themeMode,
      home: MyHomePage(
        themeMode: _themeMode,
        onThemeChanged: _setThemeMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.themeMode,
    this.onThemeChanged,
  });

  final ThemeMode? themeMode;
  final ValueChanged<ThemeMode>? onThemeChanged;

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
      SettingsPage(
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
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
