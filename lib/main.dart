import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/pyq_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/live_test_screen.dart';
import 'utils/constants.dart';
import 'utils/permission_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Check permissions
  await PermissionHelper.checkAllPermissions();
  
  runApp(SanitaryInspectorApp());
}

class SanitaryInspectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            theme: AppConstants.lightTheme,
            darkTheme: AppConstants.darkTheme,
            themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
            routes: {
              '/pyq': (context) => PyqScreen(),
              '/notes': (context) => NotesScreen(),
              '/quiz': (context) => QuizScreen(),
              '/live': (context) => LiveTestScreen(),
            },
          );
        },
      ),
    );
  }
}
