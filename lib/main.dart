import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const CodeQuestApp());
}

class CodeQuestApp extends StatelessWidget {
  const CodeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTheme.neonBlue,
        scaffoldBackgroundColor: AppTheme.darkBackground,
        textTheme: GoogleFonts.robotoMonoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        colorScheme: ColorScheme.dark(
          primary: AppTheme.neonBlue,
          secondary: AppTheme.neonPurple,
          surface: AppTheme.deepSpace,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
