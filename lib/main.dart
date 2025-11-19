import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/providers/task_provider.dart';
import 'package:tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Daily Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF12141C), // Dark background from image
          primaryColor: const Color(0xFF00E699), // Green accent
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00E699),
            secondary: Color(0xFF00E699),
            surface: Color(0xFF1E232E), // Card color
            background: Color(0xFF12141C),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF12141C),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
