import 'package:flutter/material.dart';
import 'screens/pyq_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/live_test_screen.dart';
import 'utils/permission_helper.dart';
import 'package:sanitary_inspector_prep/utils/permission_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionHelper.checkAllPermissions();
  runApp(SanitaryInspectorApp());
}

void main() => runApp(SanitaryInspectorApp());

class SanitaryInspectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanitary Inspector Prep',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (ctx) => HomeScreen(),
        '/pyq': (ctx) => PyqScreen(),
        '/notes': (ctx) => NotesScreen(),
        '/quiz': (ctx) => QuizScreen(),
        '/live': (ctx) => LiveTestScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final sections = [
    {'title': '📄 PYQ PDFs', 'route': '/pyq'},
    {'title': '📝 Notes', 'route': '/notes'},
    {'title': '❓ Quiz', 'route': '/quiz'},
    {'title': '🔒 Live Test (Coming Soon)', 'route': '/live'},
  ];

  @override
  Widget build(BuildContext context) {
    _handlePermissions();
    return Scaffold(
      appBar: AppBar(title: Text('Sanitary Inspector Prep')),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(sections[i]['title']!),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () => Navigator.pushNamed(context, sections[i]['route']!),
        ),
      ),
    );
  }
}

void _handlePermissions() async {
  bool granted = await PermissionHelper.requestStoragePermission();
  if (!granted) {
    // Handle permission denial (e.g., show a dialog)
  }
}
