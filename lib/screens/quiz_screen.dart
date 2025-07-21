import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'dart:math';

/// Quiz screen with interactive MCQ functionality
class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  // Quiz state management
  bool _isQuizStarted = false;
  bool _isQuizCompleted = false;
  bool _isLoading = false;
  int _currentQuestionIndex = 0;
  int _selectedAnswerIndex = -1;
  bool _showAnswer = false;
  int _score = 0;
  int _timeRemaining = 0;
  Timer? _timer;
  
  // Sample quiz data - In production, this would come from a database
  final List<Map<String, dynamic>> _quizCategories = [
    {
      'title': 'General Knowledge',
      'description': 'Basic GK questions for sanitary inspector',
      'icon': Icons.public,
      'color': const Color(0xFF2196F3),
      'duration': 10, // minutes
      'questions': 10,
    },
    {
      'title': 'Health & Sanitation',
      'description': 'Specialized health and sanitation topics',
      'icon': Icons.local_hospital,
      'color': const Color(0xFF4CAF50),
      'duration': 15,
      'questions': 15,
    },
    {
      'title': 'Environmental Science',
      'description': 'Environmental protection and ecology',
      'icon': Icons.eco,
      'color': const Color(0xFF8BC34A),
      'duration': 12,
      'questions': 12,
    },
  ];

  // Sample questions - In production, these would be loaded dynamically
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the full form of WHO?',
      'options': [
        'World Health Organization',
        'World Horse Organization', 
        'Wildlife Health Organization',
        'World Housing Organization'
      ],
      'correctAnswer': 0,
      'explanation': 'WHO stands for World Health Organization, a specialized agency of the United Nations responsible for international public health.',
      'category': 'General Knowledge',
    },
    {
      'question': 'Which disease is caused by contaminated water?',
      'options': [
        'Malaria',
        'Cholera',
        'Tuberculosis',
        'Diabetes'
      ],
      'correctAnswer': 1,
      'explanation': 'Cholera is a waterborne disease caused by ingesting contaminated water or food with Vibrio cholerae bacteria.',
      'category': 'Health & Sanitation',
    },
    {
      'question': 'What is the ideal pH range for drinking water?',
      'options': [
        '5.5 - 6.5',
        '6.5 - 8.5',
        '8.5 - 9.5',
        '9.5 - 10.5'
      ],
      'correctAnswer': 1,
      'explanation': 'The ideal pH range for drinking water is 6.5 - 8.5 according to WHO guidelines for safe drinking water.',
      'category': 'Health & Sanitation',
    },
    {
      'question': 'Which gas is primarily responsible for global warming?',
      'options': [
        'Oxygen',
        'Nitrogen',
        'Carbon Dioxide',
        'Hydrogen'
      ],
      'correctAnswer': 2,
      'explanation': 'Carbon Dioxide (CO2) is the primary greenhouse gas responsible for global warming and climate change.',
      'category': 'Environmental Science',
    },
    {
      'question': 'Vector control is important for preventing which type of diseases?',
      'options': [
        'Genetic diseases',
        'Vector-borne diseases',
        'Nutritional diseases',
        'Occupational diseases'
      ],
      'correctAnswer': 1,
      'explanation': 'Vector control helps prevent vector-borne diseases like malaria, dengue, chikungunya which are transmitted by insects.',
      'category': 'Health & Sanitation',
    },
  ];

  Map<String, dynamic>? _selectedCategory;
  late List<Map<String, dynamic>> _currentQuestions;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /// Start quiz with selected category
  void _startQuiz(Map<String, dynamic> category) {
    setState(() {
      _selectedCategory = category;
      _isQuizStarted = true;
      _isQuizCompleted = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswerIndex = -1;
      _showAnswer = false;
      _timeRemaining = category['duration'] * 60; // Convert to seconds
    });

    // Filter questions by category or use all for demo
    _currentQuestions = _questions.take(category['questions']).toList();
    
    // Shuffle questions for randomness
    _currentQuestions.shuffle();
    
    _startTimer();
    _animationController.forward();
  }

  /// Start countdown timer
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _finishQuiz();
        }
      });
    });
  }

  /// Select answer
  void _selectAnswer(int index) {
    if (_showAnswer) return;
    
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  /// Show answer explanation
  void _showAnswerExplanation() {
    if (_selectedAnswerIndex == -1) {
      _showErrorSnackBar('Please select an answer first');
      return;
    }

    setState(() {
      _showAnswer = true;
      if (_selectedAnswerIndex == _currentQuestions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
    });
  }

  /// Go to next question
  void _nextQuestion() {
    if (_currentQuestionIndex < _currentQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = -1;
        _showAnswer = false;
      });
    } else {
      _finishQuiz();
    }
  }

  /// Finish quiz and show results
  void _finishQuiz() {
    _timer?.cancel();
    setState(() {
      _isQuizCompleted = true;
    });
    _animationController.reset();
    _animationController.forward();
  }

  /// Restart quiz
  void _restartQuiz() {
    setState(() {
      _isQuizStarted = false;
      _isQuizCompleted = false;
      _selectedCategory = null;
    });
    _animationController.reset();
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Get time formatted string
  String _getFormattedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Get quiz progress
  double _getQuizProgress() {
    if (_currentQuestions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _currentQuestions.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isQuizStarted 
            ? (_selectedCategory?['title'] ?? 'Quiz')
            : 'Practice Quiz'),
        actions: _isQuizStarted && !_isQuizCompleted 
            ? [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _timeRemaining < 60 ? Colors.red : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: _timeRemaining < 60 ? Colors.white : Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getFormattedTime(_timeRemaining),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _timeRemaining < 60 ? Colors.white : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            : null,
      ),
      body: _buildBody(),
    );
  }

  /// Build main body based on quiz state
  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingWidget();
    } else if (_isQuizCompleted) {
      return _buildResultsScreen();
    } else if (_isQuizStarted) {
      return _buildQuizScreen();
    } else {
      return _buildCategorySelection();
    }
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
          Text('Loading quiz...'),
        ],
      ),
    );
  }

  /// Build category selection screen
  Widget _buildCategorySelection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Quiz Category',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a category to start your practice quiz',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _quizCategories.length,
              itemBuilder: (context, index) {
                final category = _quizCategories[index];
                return _buildCategoryCard(category);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build category card
  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _startQuiz(category),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: category['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category['icon'],
                  size: 32,
                  color: category['color'],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.quiz,
                          '${category['questions']} Questions',
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.access_time,
                          '${category['duration']} min',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build quiz screen
  Widget _buildQuizScreen() {
    final question = _currentQuestions[_currentQuestionIndex];
    
    return Column(
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1}/${_currentQuestions.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Score: $_score',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _getQuizProgress(),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        
        // Question content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      question['question'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Options
                Expanded(
                  child: ListView.builder(
                    itemCount: question['options'].length,
                    itemBuilder: (context, index) {
                      return _buildOptionCard(question, index);
                    },
                  ),
                ),
                
                // Answer explanation (if shown)
                if (_showAnswer) _buildAnswerExplanation(question),
                
                // Action buttons
                const SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build option card
  Widget _buildOptionCard(Map<String, dynamic> question, int index) {
    final isSelected = _selectedAnswerIndex == index;
    final isCorrect = index == question['correctAnswer'];
    
    Color? cardColor;
    if (_showAnswer) {
      if (isCorrect) {
        cardColor = Colors.green.withOpacity(0.1);
      } else if (isSelected && !isCorrect) {
        cardColor = Colors.red.withOpacity(0.1);
      }
    } else if (isSelected) {
      cardColor = Theme.of(context).primaryColor.withOpacity(0.1);
    }

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _selectAnswer(index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey,
                    width: 2,
                  ),
                  color: isSelected 
                      ? Theme.of(context).primaryColor 
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  question['options'][index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
              if (_showAnswer && isCorrect)
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              if (_showAnswer && isSelected && !isCorrect)
                const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build answer explanation
  Widget _buildAnswerExplanation(Map<String, dynamic> question) {
    return Card(
      color: Colors.blue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Explanation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              question['explanation'],
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        if (!_showAnswer)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _selectedAnswerIndex != -1 ? _showAnswerExplanation : null,
              icon: const Icon(Icons.help_outline),
              label: const Text('Show Answer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          )
        else
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _nextQuestion,
              icon: Icon(
                _currentQuestionIndex < _currentQuestions.length - 1 
                    ? Icons.arrow_forward 
                    : Icons.flag,
              ),
              label: Text(
                _currentQuestionIndex < _currentQuestions.length - 1 
                    ? 'Next Question' 
                    : 'Finish Quiz',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
      ],
    );
  }

  /// Build results screen
  Widget _buildResultsScreen() {
    final percentage = ((_score / _currentQuestions.length) * 100).round();
    
    return FadeTransition(
      opacity: _progressAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              percentage >= 70 ? Icons.celebration : Icons.sentiment_neutral,
              size: 80,
              color: percentage >= 70 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              'Quiz Completed!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Score:', style: TextStyle(fontSize: 18)),
                        Text(
                          '$_score / ${_currentQuestions.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Percentage:', style: TextStyle(fontSize: 18)),
                        Text(
                          '$percentage%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: percentage >= 70 ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Grade:', style: TextStyle(fontSize: 18)),
                        Text(
                          _getGrade(percentage),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: percentage >= 70 ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _restartQuiz,
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Categories'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startQuiz(_selectedCategory!),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Quiz'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build info chip
  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Get grade based on percentage
  String _getGrade(int percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }
}
