import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/gemini_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
    // Initialize Gemini Service
    if (dotenv.env['GEMINI_API_KEY'] != null) {
      GeminiService().init(dotenv.env['GEMINI_API_KEY']!);
    }
  } catch (e) {
    debugPrint("Warning: Failed to load .env file: $e");
    // Continue running app even if env fails
  }
  
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
      home: const SplashScreen(),
    );
  }
}
