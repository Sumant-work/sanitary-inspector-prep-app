import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/// Previous Year Questions screen with PDF viewing capability
class PyqScreen extends StatefulWidget {
  const PyqScreen({Key? key}) : super(key: key);

  @override
  State<PyqScreen> createState() => _PyqScreenState();
}

class _PyqScreenState extends State<PyqScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _selectedPdfPath;
  int _currentPageIndex = 0;
  int _totalPages = 0;
  PDFViewController? _pdfController;

  // Sample PYQ data - In production, this would come from an API or local database
  final List<Map<String, dynamic>> _pyqCategories = [
    {
      'title': 'General Knowledge',
      'icon': Icons.public,
      'color': const Color(0xFF2196F3),
      'papers': [
        {
          'title': '2023 - General Knowledge',
          'description': 'Complete question paper with answers',
          'year': '2023',
          'questions': 100,
          'duration': '2 hours',
          'difficulty': 'Medium',
          'localPath': 'assets/pdfs/gk_2023.pdf', // Sample path
        },
        {
          'title': '2022 - General Knowledge',
          'description': 'Previous year solved paper',
          'year': '2022',
          'questions': 100,
          'duration': '2 hours',
          'difficulty': 'Medium',
          'localPath': 'assets/pdfs/gk_2022.pdf',
        },
      ],
    },
    {
      'title': 'Health & Sanitation',
      'icon': Icons.local_hospital,
      'color': const Color(0xFF4CAF50),
      'papers': [
        {
          'title': '2023 - Health & Sanitation',
          'description': 'Specialized questions on health topics',
          'year': '2023',
          'questions': 75,
          'duration': '1.5 hours',
          'difficulty': 'Hard',
          'localPath': 'assets/pdfs/health_2023.pdf',
        },
      ],
    },
    {
      'title': 'Environmental Science',
      'icon': Icons.eco,
      'color': const Color(0xFF8BC34A),
      'papers': [
        {
          'title': '2023 - Environmental Science',
          'description': 'Environmental and ecological questions',
          'year': '2023',
          'questions': 50,
          'duration': '1 hour',
          'difficulty': 'Medium',
          'localPath': 'assets/pdfs/env_2023.pdf',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _pyqCategories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Download or load PDF file
  Future<String?> _loadPdf(String assetPath) async {
    setState(() => _isLoading = true);
    
    try {
      // In a real app, you might download from a server
      // For now, we'll create a sample PDF or show placeholder
      
      // Check if file exists in assets (this is simulated)
      // In production, you'd use rootBundle.load() for actual assets
      
      // Create a placeholder PDF path
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/sample_pyq.pdf');
      
      if (!await file.exists()) {
        // Create placeholder content or download from server
        await _createSamplePdf(file);
      }
      
      return file.path;
    } catch (e) {
      print('Error loading PDF: $e');
      _showErrorDialog('Failed to load PDF: $e');
      return null;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Create a sample PDF placeholder
  Future<void> _createSamplePdf(File file) async {
    // In a real app, you'd download the actual PDF
    // For demo, we'll create a placeholder message
    const sampleContent = '''
This is a placeholder for the PYQ PDF.

In the production app, this would contain:
- Previous year question papers
- Detailed solutions
- Topic-wise organization
- Bookmarking capabilities

To implement full functionality:
1. Add actual PDF files to assets/pdfs/
2. Implement PDF download from server
3. Add offline caching
4. Include search functionality
    ''';
    
    await file.writeAsString(sampleContent);
  }

  /// Show PDF viewer
  void _showPdfViewer(Map<String, dynamic> paper) async {
    final pdfPath = await _loadPdf(paper['localPath']);
    if (pdfPath != null) {
      setState(() => _selectedPdfPath = pdfPath);
      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _buildPdfViewerPage(paper),
        ),
      );
    }
  }

  /// Build PDF viewer page
  Widget _buildPdfViewerPage(Map<String, dynamic> paper) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          paper['title'],
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showPaperInfo(paper),
          ),
        ],
        bottom: _totalPages > 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentPageIndex > 0 
                            ? () => _goToPage(_currentPageIndex - 1)
                            : null,
                      ),
                      Text(
                        'Page ${_currentPageIndex + 1} of $_totalPages',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _currentPageIndex < _totalPages - 1
                            ? () => _goToPage(_currentPageIndex + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: _selectedPdfPath != null
          ? _buildPdfViewer()
          : _buildPdfPlaceholder(paper),
    );
  }

  /// Build PDF viewer widget
  Widget _buildPdfViewer() {
    return PDFView(
      filePath: _selectedPdfPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      onRender: (pages) {
        setState(() => _totalPages = pages ?? 0);
      },
      onViewCreated: (PDFViewController controller) {
        _pdfController = controller;
      },
      onPageChanged: (page, total) {
        setState(() => _currentPageIndex = page ?? 0);
      },
      onPageError: (page, error) {
        print('Page error: $error');
      },
    );
  }

  /// Build PDF placeholder for demo
  Widget _buildPdfPlaceholder(Map<String, dynamic> paper) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'PDF Viewer Placeholder',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'In production, this would show:\n${paper['title']}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to List'),
          ),
        ],
      ),
    );
  }

  /// Navigate to specific page
  void _goToPage(int page) {
    _pdfController?.setPage(page);
  }

  /// Show paper information dialog
  void _showPaperInfo(Map<String, dynamic> paper) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(paper['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Year', paper['year']),
            _buildInfoRow('Questions', '${paper['questions']}'),
            _buildInfoRow('Duration', paper['duration']),
            _buildInfoRow('Difficulty', paper['difficulty']),
            const SizedBox(height: 10),
            Text(
              paper['description'],
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Year Questions'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: _pyqCategories.map((category) {
            return Tab(
              icon: Icon(category['icon']),
              text: category['title'],
            );
          }).toList(),
        ),
      ),
      body: _isLoading
          ? _buildLoadingWidget()
          : TabBarView(
              controller: _tabController,
              children: _pyqCategories.map((category) {
                return _buildCategoryContent(category);
              }).toList(),
            ),
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
          Text('Loading PDF...'),
        ],
      ),
    );
  }

  /// Build category content
  Widget _buildCategoryContent(Map<String, dynamic> category) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: category['papers'].length,
      itemBuilder: (context, index) {
        final paper = category['papers'][index];
        return _buildPaperCard(paper, category['color']);
      },
    );
  }

  /// Build paper card
  Widget _buildPaperCard(Map<String, dynamic> paper, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showPdfViewer(paper),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paper['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          paper['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildChip(
                    Icons.calendar_today,
                    paper['year'],
                    Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    Icons.quiz,
                    '${paper['questions']} Q',
                    Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    Icons.access_time,
                    paper['duration'],
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(paper['difficulty']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      paper['difficulty'],
                      style: TextStyle(
                        fontSize: 12,
                        color: _getDifficultyColor(paper['difficulty']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build info chip
  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }

  /// Get difficulty color
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
