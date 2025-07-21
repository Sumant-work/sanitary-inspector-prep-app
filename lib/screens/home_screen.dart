import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/permission_helper.dart';

/// Home screen with main app navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _permissionsGranted = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'Previous Year Questions',
      'subtitle': 'Practice with past exam papers',
      'route': '/pyq',
      'icon': Icons.quiz,
      'color': const Color(0xFF1E88E5),
      'available': true,
    },
    {
      'title': 'Study Notes',
      'subtitle': 'Topic-wise comprehensive notes',
      'route': '/notes',
      'icon': Icons.book,
      'color': const Color(0xFF43A047),
      'available': true,
    },
    {
      'title': 'Practice Quiz',
      'subtitle': 'Test your knowledge instantly',
      'route': '/quiz',
      'icon': Icons.psychology,
      'color': const Color(0xFFFF9800),
      'available': true,
    },
    {
      'title': 'Live Tests',
      'subtitle': 'Competitive real-time tests',
      'route': '/live',
      'icon': Icons.live_tv,
      'color': const Color(0xFF9C27B0),
      'available': false, // Coming soon
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Initialize app permissions and setup
  Future<void> _initializeApp() async {
    setState(() => _isLoading = true);
    
    try {
      // Check and request permissions
      final granted = await PermissionHelper.requestStoragePermission();
      setState(() => _permissionsGranted = granted);
      
      if (!granted) {
        _showPermissionDialog();
      }
      
      // Start animation
      await _animationController.forward();
    } catch (e) {
      print('Error initializing app: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Show permission requirement dialog
  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Text('Permission Required'),
            ],
          ),
          content: const Text(
            'Storage permission is required to:\n'
            '• Access PDF files\n'
            '• Save your progress\n'
            '• Store quiz results\n\n'
            'Please grant permission to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _initializeApp();
              },
              child: const Text('Grant Permission'),
            ),
          ],
        );
      },
    );
  }

  /// Handle section navigation
  void _navigateToSection(Map<String, dynamic> section) {
    if (!section['available']) {
      _showComingSoonDialog(section['title']);
      return;
    }

    Navigator.pushNamed(context, section['route']);
  }

  /// Show coming soon dialog
  void _showComingSoonDialog(String featureName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.construction, color: Colors.orange),
              SizedBox(width: 10),
              Text('Coming Soon'),
            ],
          ),
          content: Text(
            '$featureName feature is under development and will be available soon!\n\n'
            'Stay tuned for updates.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sanitary Inspector Prep',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingWidget()
          : _buildMainContent(),
    );
  }

  /// Build loading widget
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFadingCircle(
            color: Color(0xFF1E88E5),
            size: 50.0,
          ),
          SizedBox(height: 20),
          Text(
            'Initializing app...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Build main content
  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: _initializeApp,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome section
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          
          // Features grid
          _buildFeaturesGrid(),
          
          // App info section
          const SizedBox(height: 24),
          _buildAppInfoSection(),
        ],
      ),
    );
  }

  /// Build welcome section
  Widget _buildWelcomeSection() {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        color: const Color(0xFF1E88E5),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const Text(
                'Sanitary Inspector Prep',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your complete preparation companion for Sanitary Inspector, Malaria Inspector, and Health Inspector exams.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _buildPermissionStatus(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build permission status indicator
  Widget _buildPermissionStatus() {
    return Row(
      children: [
        Icon(
          _permissionsGranted ? Icons.check_circle : Icons.error,
          color: _permissionsGranted ? Colors.greenAccent : Colors.redAccent,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          _permissionsGranted 
              ? 'Permissions granted' 
              : 'Permissions required',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// Build features grid
  Widget _buildFeaturesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _sections.length,
      itemBuilder: (context, index) {
        final section = _sections[index];
        return _buildFeatureCard(section, index);
      },
    );
  }

  /// Build individual feature card
  Widget _buildFeatureCard(Map<String, dynamic> section, int index) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
        )),
        child: Card(
          elevation: section['available'] ? 4 : 2,
          color: section['available'] ? Colors.white : Colors.grey[100],
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _navigateToSection(section),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: section['available'] 
                          ? section['color'].withOpacity(0.1)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      section['icon'],
                      size: 32,
                      color: section['available'] 
                          ? section['color']
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    section['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: section['available'] ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    section['subtitle'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: section['available'] ? Colors.grey[600] : Colors.grey,
                    ),
                  ),
                  if (!section['available']) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Coming Soon',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build app info section
  Widget _buildAppInfoSection() {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info, color: Color(0xFF1E88E5)),
                  const SizedBox(width: 8),
                  const Text(
                    'App Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Version', '1.0.0'),
              _buildInfoRow('Last Updated', 'January 2025'),
              _buildInfoRow('Developer', 'Sumant'),
              const SizedBox(height: 8),
              const Text(
                'Designed specifically for Sanitary Inspector exam preparation. '
                'All content is regularly updated to match current exam patterns.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  /// Show about dialog
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Sanitary Inspector Prep',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.local_hospital, size: 48),
      children: [
        const Text(
          'A comprehensive preparation app for Sanitary Inspector, '
          'Malaria Inspector, and Health Inspector examinations.',
        ),
      ],
    );
  }
}
