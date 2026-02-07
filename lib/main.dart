import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';
import 'services/gemini_service.dart';
import 'services/local_storage_service.dart';
import 'screens/splash_screen.dart';
import 'screens/phase1/system_awakening_screen.dart';
import 'screens/level_map_screen.dart';
import 'screens/phase1/mission1_screen.dart';
import 'screens/phase1/mission2_screen.dart';
import 'screens/phase1/mission3_screen.dart';
import 'screens/phase1/mission4_screen.dart';
import 'screens/phase1/mission5_screen.dart';
import 'screens/phase1/mission6_screen.dart';
import 'screens/phase1/mission7_screen.dart';
import 'screens/phase1/mission8_screen.dart';
import 'screens/phase1/mission9_screen.dart';
import 'screens/phase1/mission10_screen.dart';
import 'screens/phase1/mission11_screen.dart';
import 'screens/phase1/phase1_status_screen.dart';
import 'screens/phase1/phase1_mid_status_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
import 'services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage (Required for StoryTriggerManager)
  await LocalStorageService().init();
  await TTSService().init(); // Initialize Text-to-Speech

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
        '/story/level_map': (context) => const LevelMapScreen(),
        '/story/python/mission1': (context) => const Mission1Screen(),
        '/story/python/mission2': (context) => const Mission2Screen(),
        '/story/python/mission3': (context) => const Mission3Screen(), 
        '/story/python/mission4': (context) => const Mission4Screen(),
        '/story/python/mission5': (context) => const Mission5Screen(),
        '/story/python/mission6': (context) => const Mission6Screen(),
        '/story/python/mission7': (context) => const Mission7Screen(),
        '/story/python/mission8': (context) => const Mission8Screen(),
        '/story/python/mission9': (context) => const Mission9Screen(),
        '/story/python/mission10': (context) => const Mission10Screen(),
        '/story/python/mission11': (context) => const Mission11Screen(),
        '/story/phase1/status': (context) => const Phase1StatusScreen(),
        '/story/phase1/mid-status': (context) => const Phase1MidStatusScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}