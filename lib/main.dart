import 'package:flutter/material.dart';
import 'screens/pyq_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/live_test_screen.dart';
import 'utils/permission_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionHelper.checkAllPermissions();
  runApp(SanitaryInspectorApp());
}

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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final sections = [
    {'title': '📄 PYQ PDFs', 'route': '/pyq'},
    {'title': '📝 Notes', 'route': '/notes'},
    {'title': '❓ Quiz', 'route': '/quiz'},
    {'title': '🔒 Live Test (Coming Soon)', 'route': '/live'},
  ];

  @override
  void initState() {
    super.initState();
    _handlePermissions();
  }

  Future<void> _handlePermissions() async {
    try {
      bool granted = await PermissionHelper.requestStoragePermission();
      if (!granted) {
        // Show dialog or snackbar to user
        _showPermissionDialog();
      }
    } catch (e) {
      print('Permission error: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text('Storage permission is required to access PDFs and save your progress.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
