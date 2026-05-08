import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/menu_screen.dart';

class WoodfishApp extends StatelessWidget {
  const WoodfishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '电子祈福',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.bg0,
        colorScheme: const ColorScheme.dark(
          primary: AppTheme.gold,
          secondary: AppTheme.goldDark,
          surface: AppTheme.bg1,
        ),
      ),
      home: const MenuScreen(),
    );
  }
}
