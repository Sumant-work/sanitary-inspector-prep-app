import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Import screens
import 'screens/home_screen.dart';
import 'screens/pyq_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/live_test_screen.dart';

// Import utilities
import 'utils/permission_helper.dart';
import 'providers/app_provider.dart';

/// Main entry point of the Sanitary Inspector Prep App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize permissions
  await PermissionHelper.checkAllPermissions();
  
  runApp(SanitaryInspectorApp());
}

/// Main application widget with provider setup
class SanitaryInspectorApp extends StatelessWidget {
  const SanitaryInspectorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'Sanitary Inspector Prep',
        debugShowCheckedModeBanner: false,
        
        // App theme configuration
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF1E88E5),
          primaryColorDark: const Color(0xFF1565C0),
          accentColor: const Color(0xFF43A047),
          scaffoldBackgroundColor: Colors.grey[50],
          
          // AppBar theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E88E5),
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
          ),
          
          // Card theme
          cardTheme: CardTheme(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          
          // Button themes
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          
          // Input decoration theme
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        
        // Route configuration
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/pyq': (context) => const PyqScreen(),
          '/notes': (context) => const NotesScreen(),
          '/quiz': (context) => const QuizScreen(),
          '/live': (context) => const LiveTestScreen(),
        },
        
        // Handle unknown routes
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          );
        },
      ),
    );
  }
}
