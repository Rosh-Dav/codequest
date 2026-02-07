import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'services/gemini_service.dart';
import 'services/local_storage_service.dart';
import 'screens/splash_screen.dart';
import 'screens/phase1/system_awakening_screen.dart';
import 'screens/phase1/mission1_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage (Required for StoryTriggerManager)
  await LocalStorageService().init();

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

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // Named routes for navigation
      routes: {
        '/story/python/phase1/opening': (context) => const SystemAwakeningScreen(),
        '/story/python/mission': (context) => const Mission1Screen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}