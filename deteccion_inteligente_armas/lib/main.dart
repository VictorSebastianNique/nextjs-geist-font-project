import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detection_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(DeteccionInteligenteArmasApp());
}

class DeteccionInteligenteArmasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detección Inteligente de Armas',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            minimumSize: Size(double.infinity, 60),
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/detection': (context) => DetectionScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
