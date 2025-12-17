import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    this.themeMode,
    this.onThemeChanged,
  });

  final ThemeMode? themeMode;
  final ValueChanged<ThemeMode>? onThemeChanged;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeMode _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.themeMode ?? ThemeMode.system;
  }

  void _onValueChanged(ThemeMode value) {
    setState(() => _selected = value);
    widget.onThemeChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text('Ajustes', style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue.resolveFrom(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(CupertinoIcons.brightness, color: CupertinoColors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tema de la aplicación', style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(
                            'Elige entre claro, oscuro o seguir el sistema',
                            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6.resolveFrom(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(6),
                child: CupertinoSegmentedControl<ThemeMode>(
                  groupValue: _selected,
                  // Use a fixed iOS blue to keep the selected state consistent in dark mode
                  selectedColor: const Color(0xFF0A84FF),
                  borderColor: const Color(0xFF0A84FF).withOpacity(0.65),
                  pressedColor: const Color(0xFF0A84FF).withOpacity(0.14),
                  children: {
                    ThemeMode.system: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text('Sistema', style: CupertinoTheme.of(context).textTheme.textStyle),
                    ),
                    ThemeMode.light: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text('Claro', style: CupertinoTheme.of(context).textTheme.textStyle),
                    ),
                    ThemeMode.dark: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text('Oscuro', style: CupertinoTheme.of(context).textTheme.textStyle),
                    ),
                  },
                  onValueChanged: _onValueChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
