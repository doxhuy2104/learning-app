import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/components/buttons/outline_button.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/modules/app/data/repositories/app_repository.dart';

String mathmlToLatex(String mathml) {
  String latex = mathml;

  latex = latex.replaceAll(
    RegExp(r'<math[^>]*>', caseSensitive: false),
    '<math>',
  );
  latex = latex.replaceAll(RegExp(r'xmlns="[^"]*"', caseSensitive: false), '');
  latex = latex.replaceAll(RegExp(r'class="[^"]*"', caseSensitive: false), '');

  latex = latex.replaceAllMapped(
    RegExp(
      r'<munderover><mrow></mrow><mi>([^<]+)</mi><mi>([^<]+)</mi></munderover>',
      dotAll: true,
    ),
    (match) => '\\int_{${match.group(1)}}^{${match.group(2)}}',
  );

  latex = latex.replaceAll(
    RegExp(r'<munderover><mrow></mrow></munderover>'),
    r'\int',
  );

  // Handle superscripts (msup) - with multiple possible base types
  latex = latex.replaceAllMapped(
    RegExp(r'<msup><mi>([^<]+)</mi><mo>([^<]+)</mo></msup>', dotAll: true),
    (match) => '${match.group(1)}^{${match.group(2)}}',
  );
  latex = latex.replaceAllMapped(
    RegExp(r'<msup><mi>([^<]+)</mi><mi>([^<]+)</mi></msup>', dotAll: true),
    (match) => '${match.group(1)}^{${match.group(2)}}',
  );

  // Handle subscripts (msub)
  latex = latex.replaceAllMapped(
    RegExp(r'<msub><mi>([^<]+)</mi><mi>([^<]+)</mi></msub>', dotAll: true),
    (match) => '${match.group(1)}_{${match.group(2)}}',
  );

  // Handle mfenced with open and close attributes
  latex = latex.replaceAllMapped(
    RegExp(r'<mfenced([^>]*)>(.*?)</mfenced>', dotAll: true),
    (match) {
      final attrs = match.group(1) ?? '';
      final content = match.group(2) ?? '';

      // Check for custom open/close
      String open = '(';
      String close = ')';

      if (attrs.contains('open="{')) {
        open = r'\{';
      } else if (attrs.contains('open="[')) {
        open = '[';
      }

      if (attrs.contains('close="}')) {
        close = r'\}';
      } else if (attrs.contains('close="]')) {
        close = ']';
      }

      // Process content inside mfenced
      String processedContent = content;
      processedContent = processedContent.replaceAllMapped(
        RegExp(r'<mi>([^<]+)</mi>'),
        (match) => match.group(1) ?? '',
      );
      processedContent = processedContent.replaceAllMapped(
        RegExp(r'<mo>([^<]+)</mo>'),
        (match) => match.group(1) ?? '',
      );
      processedContent = processedContent.replaceAllMapped(
        RegExp(r'<mtext>([^<]+)</mtext>'),
        (match) => match.group(1) ?? '',
      );
      processedContent = processedContent
          .replaceAll(RegExp(r'<mrow>'), '')
          .replaceAll(RegExp(r'</mrow>'), '');

      return '$open$processedContent$close';
    },
  );

  // Handle simple mfenced without attributes
  latex = latex.replaceAllMapped(
    RegExp(r'<mfenced><mi>([^<]+)</mi></mfenced>', dotAll: true),
    (match) => '(${match.group(1)})',
  );

  // Handle fractions
  latex = latex.replaceAllMapped(
    RegExp(r'<mfrac><mi>([^<]+)</mi><mi>([^<]+)</mi></mfrac>', dotAll: true),
    (match) => '\\frac{${match.group(1)}}{${match.group(2)}}',
  );

  // Handle square roots
  latex = latex.replaceAllMapped(
    RegExp(r'<msqrt><mi>([^<]+)</mi></msqrt>', dotAll: true),
    (match) => '\\sqrt{${match.group(1)}}',
  );

  // Variables and identifiers (mi)
  latex = latex.replaceAllMapped(
    RegExp(r'<mi>([^<]+)</mi>'),
    (match) => match.group(1) ?? '',
  );

  // Numbers (mn)
  latex = latex.replaceAllMapped(
    RegExp(r'<mn>([^<]+)</mn>'),
    (match) => match.group(1) ?? '',
  );

  // Operators (mo) - specific cases first
  latex = latex.replaceAll(RegExp(r'<mo>=</mo>'), '=');
  latex = latex.replaceAll(RegExp(r'<mo>\+</mo>'), '+');
  latex = latex.replaceAll(RegExp(r'<mo>-</mo>'), '-');
  latex = latex.replaceAll(RegExp(r'<mo>\*</mo>'), r'\cdot');
  latex = latex.replaceAll(RegExp(r'<mo>/</mo>'), '/');
  latex = latex.replaceAll(RegExp(r'<mo>,</mo>'), ',');
  latex = latex.replaceAll(RegExp(r'<mo>\.</mo>'), r'\cdot');
  latex = latex.replaceAll(RegExp(r"<mo>'</mo>"), r"\prime");
  // Handle remaining operators
  latex = latex.replaceAllMapped(
    RegExp(r'<mo>([^<]+)</mo>'),
    (match) => match.group(1) ?? '',
  );

  // Text (mtext) - preserve with spacing
  latex = latex.replaceAllMapped(
    RegExp(r'<mtext>([^<]+)</mtext>'),
    (match) => ' \\, ${match.group(1)} ',
  );

  // Handle matrices
  latex = latex.replaceAll(RegExp(r'<mtable[^>]*>'), r'\begin{matrix}');
  latex = latex.replaceAll(RegExp(r'</mtable>'), r'\end{matrix}');
  latex = latex.replaceAll(RegExp(r'<mtr>'), '');
  latex = latex.replaceAll(RegExp(r'</mtr>'), r' \\ ');
  latex = latex.replaceAll(RegExp(r'<mtd>'), '');
  latex = latex.replaceAll(RegExp(r'</mtd>'), ' & ');

  // Remove mrow tags (just grouping)
  latex = latex.replaceAll(RegExp(r'<mrow>'), '');
  latex = latex.replaceAll(RegExp(r'</mrow>'), '');

  // Remove remaining math tags
  latex = latex.replaceAll(RegExp(r'<math[^>]*>', caseSensitive: false), '');
  latex = latex.replaceAll(RegExp(r'</math>', caseSensitive: false), '');

  // Clean up whitespace
  latex = latex
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp(r'\s*\\s*'), r' \, ')
      .trim();

  return latex;
}

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<StatefulWidget> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final _repository = Modular.get<AppRepository>();
  late PageController _pageController;
  int _currentPage = 0;
  Map<int, int?> _selectedAnswers = {}; // questionId -> answerId
  Set<int> _revealedAnswers = {}; // questionId -> whether answers are revealed

  List<QuestionModel>? _questions;
  bool _isLoading = true;
  String? _errorMessage;

  late int _examId;
  String? _examTitle;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Get examId from route args
    final args = Modular.args.data as Map<String, dynamic>?;
    _examId = args?['examId'] ?? 0;
    _examTitle = args?['examTitle'];

    // _loadQuestions();
  }

  // Future<void> _loadQuestions() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });

  //   final result = await _repository.getQuesttionsByExamId(_examId, 1, 100);

  //   result.fold(
  //     (failure) {
  //       setState(() {
  //         _isLoading = false;
  //         _errorMessage = failure.reason;
  //       });
  //     },
  //     (questions) {
  //       setState(() {
  //         _isLoading = false;
  //         _questions = questions;
  //       });
  //     },
  //   );
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _questions!.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleRevealAnswer(int questionId) {
    setState(() {
      if (_revealedAnswers.contains(questionId)) {
        _revealedAnswers.remove(questionId);
      } else {
        _revealedAnswers.add(questionId);
      }
    });
  }

  void _submitAnswers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Exam?'),
        content: Text(
          'You have answered ${_selectedAnswers.length} out of ${_questions!.length} questions.\n\nAre you sure you want to submit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Submit answers to API
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exam submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Modular.to.pop();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Loading State
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_examTitle ?? 'Questions'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading questions...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // Empty State
    if (_questions == null || _questions!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(_examTitle ?? 'Questions')),
        body: const Center(
          child: Text('No questions available', style: TextStyle(fontSize: 16)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_examTitle ?? 'Questions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
            onPressed: _submitAnswers,
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentPage + 1} of ${_questions!.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_selectedAnswers.length}/${_questions!.length} answered',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentPage + 1) / _questions!.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Question PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _questions!.length,
              itemBuilder: (context, index) {
                final question = _questions![index];
                return _buildQuestionCard(question);
              },
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlineButton(
                      onPress: _goToPreviousPage,
                      widget: Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.primary,
                          ),
                          Text(
                            'Previous',
                            style: Styles.medium.regular.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 12),
                Expanded(
                  child: _currentPage < _questions!.length - 1
                      ? PrimaryButton(
                          onPress: _goToNextPage,
                          widget: Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: Styles.medium.regular.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _submitAnswers,
                          icon: const Icon(Icons.check),
                          label: const Text('Submit Exam'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel question) {
    final questionId = question.id;
    final selectedAnswerId = _selectedAnswers[questionId];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 0.1,
              offset: Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Type Badge
              // if (question.type != null)
              //   Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 12,
              //       vertical: 6,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.blue[100],
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Text(
              //       // question.type!.toUpperCase().replaceAll('_', ' '),
              //       questionId.toString(),
              //       style: TextStyle(
              //         fontSize: 12,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.blue[800],
              //       ),
              //     ),
              //   ),
              const SizedBox(height: 16),
              Html(
                data: question.content ?? '',
                extensions: [
                  TagExtension(
                    tagsToExtend: {"math"},
                    builder: (extensionContext) {
                      final mathmlContent = extensionContext.innerHtml;
                      final latex = mathmlToLatex(mathmlContent);
                      return Math.tex(
                        latex,
                        textStyle: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ],
                style: {
                  "p": Style(textAlign: TextAlign.center, color: Colors.black),
                  "strong": Style(fontWeight: FontWeight.bold),
                  "div": Style(textAlign: TextAlign.left, color: Colors.black),
                },
              ),

              // Question Content
              const SizedBox(height: 24),

              // View Answer Button
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _toggleRevealAnswer(questionId!),
                  icon: Icon(
                    _revealedAnswers.contains(questionId)
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  label: Text(
                    _revealedAnswers.contains(questionId)
                        ? 'Ẩn đáp án'
                        : 'Xem đáp án',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Answers
              if (question.answers != null && question.answers!.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...question.answers!.asMap().entries.map((entry) {
                  final answerIndex = entry.key;
                  final answer = entry.value;
                  final answerId = answer.id;
                  final isSelected = selectedAnswerId == answerId;
                  final isRevealed = _revealedAnswers.contains(questionId);
                  final isCorrect = answer.isCorrect == true;
                  final isWrongSelected =
                      isSelected && !isCorrect && isRevealed;

                  // Determine colors and styling based on state
                  Color backgroundColor;
                  Color borderColor;
                  int borderWidth;
                  Widget? leadingIcon;

                  if (isRevealed) {
                    if (isCorrect) {
                      // Correct answer - green
                      backgroundColor = Colors.green[50]!;
                      borderColor = Colors.green;
                      borderWidth = 2;
                      leadingIcon = Icon(
                        Icons.check_circle,
                        color: Colors.green[700],
                        size: 24,
                      );
                    } else if (isWrongSelected) {
                      // Wrong selected answer - red
                      backgroundColor = Colors.red[50]!;
                      borderColor = Colors.red;
                      borderWidth = 2;
                      leadingIcon = Icon(
                        Icons.cancel,
                        color: Colors.red[700],
                        size: 24,
                      );
                    } else {
                      // Not selected, not correct - gray
                      backgroundColor = Colors.grey[100]!;
                      borderColor = Colors.grey[300]!;
                      borderWidth = 1;
                    }
                  } else {
                    // Not revealed - normal selection state
                    backgroundColor = isSelected
                        ? Colors.blue[50]!
                        : Colors.grey[100]!;
                    borderColor = isSelected ? Colors.blue : Colors.grey[300]!;
                    borderWidth = isSelected ? 2 : 1;
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAnswers[questionId!] = answerId;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(
                          color: borderColor,
                          width: borderWidth.toDouble(),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          if (leadingIcon != null) ...[
                            leadingIcon,
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Html(
                              data:
                                  question.answers?[answerIndex].content ?? '',
                              extensions: [
                                TagExtension(
                                  tagsToExtend: {"math"},
                                  builder: (extensionContext) {
                                    final mathmlContent =
                                        extensionContext.innerHtml;
                                    final latex = mathmlToLatex(mathmlContent);
                                    return Math.tex(
                                      latex,
                                      textStyle: const TextStyle(fontSize: 16),
                                    );
                                  },
                                ),
                              ],
                              style: {
                                "p": Style(
                                  textAlign: TextAlign.center,
                                  color: Colors.black,
                                ),
                                "strong": Style(fontWeight: FontWeight.bold),
                                "div": Style(
                                  textAlign: TextAlign.left,
                                  color: Colors.black,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ] else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'No answers available for this question',
                    style: TextStyle(
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              // Explanation (only show when answers are revealed)
              if (_revealedAnswers.contains(questionId) &&
                  question.explanation != null &&
                  question.explanation!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber[800],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Giải thích:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[900],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Html(
                        extensions: [
                          TagExtension(
                            tagsToExtend: {"tex"},
                            builder: (extensionContext) {
                              return Math.tex(
                                extensionContext.innerHtml,
                                textStyle: const TextStyle(fontSize: 16),
                              );
                            },
                          ),
                          TagExtension(
                            tagsToExtend: {"math"},
                            builder: (extensionContext) {
                              final mathmlContent = extensionContext.innerHtml;
                              final latex = mathmlToLatex(mathmlContent);
                              return Math.tex(
                                latex,
                                textStyle: const TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ],
                        data: question.explanation ?? '',
                        style: {
                          "p": Style(
                            textAlign: TextAlign.center,
                            color: Colors.black,
                          ),
                          "strong": Style(fontWeight: FontWeight.bold),
                          "div": Style(
                            textAlign: TextAlign.left,
                            color: Colors.black,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
