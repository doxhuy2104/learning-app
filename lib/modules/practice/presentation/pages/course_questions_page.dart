import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/components/buttons/outline_button.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/components/display_html.dart';
import 'package:learning_app/core/components/inputs/text_input.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_bloc.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_event.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_state.dart';

class CourseQuestionsPage extends StatefulWidget {
  const CourseQuestionsPage({super.key});

  @override
  State<StatefulWidget> createState() => _CourseQuestionsPageState();
}

class _CourseQuestionsPageState extends State<CourseQuestionsPage> {
  final _practiceBloc = Modular.get<PracticeBloc>();
  late PageController _pageController;
  late ScrollController _questionSelectionScrollController;
  int _currentPage = 0;
  final Map<int, dynamic> _userAnswers = {};

  late int _examId;

  String? _examTitle;
  final _shortAnswerController = TextEditingController();
  final _shortAnswerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questionSelectionScrollController = ScrollController();

    final args = Modular.args.data as Map<String, dynamic>?;
    _examId = args?['examId'] ?? 0;

    _examTitle = args?['examTitle'] ?? '';

    _practiceBloc.add(ResetCourseData());
    _loadQuestions();
  }

  void _saveShortAnswer(int questionOrderIndex) {
    final answerText = _shortAnswerController.text.trim();

    setState(() {
      _userAnswers[questionOrderIndex] = answerText.isNotEmpty
          ? answerText
          : null;
    });

    _practiceBloc.add(
      AddUserAnswer(
        examId: _examId,
        questionOrderIndex: questionOrderIndex,
        answerOrderIndex: null,
        shortAnswer: answerText.isNotEmpty ? answerText : null,
      ),
    );
  }

  Future<void> _loadQuestions() async {
    _practiceBloc.add(GetCourseQuestions(examId: _examId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _questionSelectionScrollController.dispose();
    _shortAnswerController.dispose();
    _shortAnswerFocusNode.dispose();
    // _practiceBloc.add(ResetCourseData());
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _practiceBloc.state.questions.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_examTitle ?? 'Questions'),

        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<PracticeBloc, PracticeState>(
        bloc: _practiceBloc,
        builder: (context, state) {
          return Column(
            children: [
              state.isLoading
                  ? Expanded(
                      child: _buildSkeleton().paddingOnly(
                        top: 8,
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                    )
                  : Expanded(
                      child: Column(
                        children: [
                          _buildQuestionSelection(),
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                // Save current short answer before changing page
                                if (_currentPage <
                                    _practiceBloc.state.questions.length) {
                                  final previousQuestion = _practiceBloc
                                      .state
                                      .questions[_currentPage];
                                  if (previousQuestion.type == 'short_answer' &&
                                      previousQuestion.orderIndex != null) {
                                    _saveShortAnswer(
                                      previousQuestion.orderIndex!,
                                    );
                                  }
                                }

                                setState(() {
                                  _currentPage = index;
                                });

                                // Load answer for new question if it exists
                                if (index <
                                    _practiceBloc.state.questions.length) {
                                  final newQuestion =
                                      _practiceBloc.state.questions[index];
                                  if (newQuestion.type == 'short_answer' &&
                                      newQuestion.orderIndex != null) {
                                    final existingAnswer =
                                        _userAnswers[newQuestion.orderIndex!];
                                    _shortAnswerController.text =
                                        existingAnswer?.toString() ?? '';
                                  } else {
                                    _shortAnswerController.clear();
                                  }
                                }

                                // Scroll question selection to center
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  _scrollToQuestion(index, context);
                                });
                              },
                              itemCount: state.questions.length,
                              itemBuilder: (context, index) {
                                final question = state.questions[index];
                                // Initialize controller for current page on first build
                                if (index == _currentPage &&
                                    question.type == 'short_answer' &&
                                    question.orderIndex != null) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    final existingAnswer =
                                        _userAnswers[question.orderIndex!];
                                    if (_shortAnswerController.text !=
                                        (existingAnswer?.toString() ?? '')) {
                                      _shortAnswerController.text =
                                          existingAnswer?.toString() ?? '';
                                    }
                                  });
                                }
                                return _buildQuestionCard(question);
                              },
                            ),
                          ),
                        ],
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
                    _currentPage > 0
                        ? Expanded(
                            child: OutlineButton(
                              onPress: _goToPreviousPage,
                              widget: Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : Expanded(child: SizedBox()),
                    12.horizontalSpace,

                    12.horizontalSpace,
                    _currentPage != state.questions.length - 1
                        ? Expanded(
                            child: PrimaryButton(
                              onPress: _goToNextPage,
                              widget: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel question) {
    final questionOrderIndex = question.orderIndex;
    final selectedAnswerOrderIndex = _userAnswers[questionOrderIndex];
    final userAnswer = questionOrderIndex != null
        ? _practiceBloc.state.userAnswers[questionOrderIndex]
        : null;
    final isCorrect = userAnswer?.isCorrect;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(question.orderIndex.toString()),
          DisplayHtml(htmlContent: question.content ?? ''),

          const SizedBox(height: 12),
          if (question.type == 'choice') ...[
            ...question.answers!.asMap().entries.map((entry) {
              final answer = entry.value;
              final answerOrderIndex = answer.orderIndex;
              final isSelected = selectedAnswerOrderIndex == answerOrderIndex;
              final isAnswerCorrect = answer.isCorrect ?? false;
              final hasAnswered = isCorrect != null;
              final showCorrect = isAnswerCorrect && hasAnswered;
              final showIncorrect = isSelected && isCorrect == false;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Button(
                  onPress: () {
                    if (questionOrderIndex == null) return;
                    if (_userAnswers[questionOrderIndex] != answerOrderIndex) {
                      setState(() {
                        _userAnswers[questionOrderIndex] = answerOrderIndex;
                      });
                      _practiceBloc.add(
                        AddUserAnswer(
                          examId: _examId,
                          questionOrderIndex: questionOrderIndex,
                          isCorrect: answer.isCorrect ?? false,
                          answerOrderIndex: answerOrderIndex,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: (isSelected || showCorrect) ? 3 : 4,
                      horizontal: (isSelected || showCorrect) ? 15 : 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: showCorrect
                          ? AppColors.success.withOpacity(0.1)
                          : showIncorrect
                          ? AppColors.danger.withOpacity(0.1)
                          : isSelected
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: showCorrect
                            ? AppColors.success
                            : showIncorrect
                            ? AppColors.danger
                            : isSelected
                            ? AppColors.primary
                            : AppColors.borderColor,
                        width: (isSelected || showCorrect) ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DisplayHtml(
                            htmlContent: answer.content ?? '',
                            fontSize: 16,
                            maxWidth: MediaQuery.of(context).size.width - 80,
                          ),
                        ),
                        if (showCorrect)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          )
                        else if (showIncorrect)
                          Icon(Icons.cancel, color: AppColors.danger, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            if (isCorrect != null && question.explanation != null) ...[
              const SizedBox(height: 12),
              Text(
                'Giải thích:',
                style: Styles.medium.smb.copyWith(color: Colors.black87),
              ),
              const SizedBox(height: 6),
              DisplayHtml(
                htmlContent: question.explanation ?? '',
                fontSize: 15,
                maxWidth: MediaQuery.of(context).size.width - 80,
              ),
            ],
          ] else if (question.type == 'short_answer') ...[
            TextInput(
              controller: _shortAnswerController,
              focusNode: _shortAnswerFocusNode,
              keyboardType: TextInputType.number,
              placeholder: 'Nhập đáp án',
              onChange: (value) {
                if (questionOrderIndex != null) {
                  _saveShortAnswer(questionOrderIndex);
                }
              },
            ),
            if (isCorrect != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCorrect ? AppColors.success : AppColors.danger,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? AppColors.success : AppColors.danger,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCorrect ? 'Đáp án đúng' : 'Đáp án sai',
                      style: Styles.medium.regular.copyWith(
                        color: isCorrect ? AppColors.success : AppColors.danger,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (isCorrect != null && question.explanation != null) ...[
              const SizedBox(height: 12),
              Text(
                'Giải thích:',
                style: Styles.medium.smb.copyWith(color: Colors.black87),
              ),
              const SizedBox(height: 6),
              DisplayHtml(
                htmlContent: question.explanation ?? '',
                fontSize: 15,
                maxWidth: MediaQuery.of(context).size.width - 80,
              ),
            ],
          ] else ...[
            ...question.answers!.asMap().entries.map((entry) {
              final answer = entry.value;
              final answerOrderIndex = answer.orderIndex;
              String? trueFalseAnswer = _userAnswers[questionOrderIndex];
              final answerValue = trueFalseAnswer?[entry.key];
              final isCorrectAnswer = answer.isCorrect ?? false;
              final showResult = answerValue != null && answerValue != '-';
              final isUserCorrect =
                  showResult &&
                  ((answerValue == 'T' && isCorrectAnswer) ||
                      (answerValue == 'F' && !isCorrectAnswer));
              final showCorrectAnswer = showResult && isCorrectAnswer;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PopupMenuButton(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  padding: EdgeInsetsGeometry.zero,
                  menuPadding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (questionOrderIndex == null) return;

                    trueFalseAnswer ??= '----';

                    trueFalseAnswer = trueFalseAnswer?.replaceRange(
                      entry.key,
                      entry.key + 1,
                      value ? 'T' : 'F',
                    );
                    setState(() {
                      _userAnswers[questionOrderIndex] = trueFalseAnswer;
                    });
                    _practiceBloc.add(
                      AddUserAnswer(
                        examId: _examId,
                        questionOrderIndex: questionOrderIndex,
                        answerOrderIndex: answerOrderIndex,
                        isCorrect: null, // Để bloc tính toán
                        shortAnswer: null,
                        trueFalseAnswer: trueFalseAnswer,
                      ),
                    );
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem<bool>(
                      value: true,
                      child: Text(
                        'Đúng',
                        style: Styles.medium.regular.copyWith(
                          color: const Color.fromARGB(255, 0, 221, 99),
                        ),
                      ),
                    ),
                    PopupMenuItem<bool>(
                      value: false,
                      child: Text(
                        'Sai',
                        style: Styles.medium.regular.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: (showResult || showCorrectAnswer) ? 3 : 4,
                      horizontal: (showResult || showCorrectAnswer) ? 15 : 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: showCorrectAnswer
                          ? AppColors.success.withOpacity(0.1)
                          : showResult
                          ? (isUserCorrect
                                ? AppColors.success.withOpacity(0.1)
                                : AppColors.danger.withOpacity(0.1))
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: showCorrectAnswer
                            ? AppColors.success
                            : showResult
                            ? (isUserCorrect
                                  ? AppColors.success
                                  : AppColors.danger)
                            : AppColors.borderColor,
                        width: (showResult || showCorrectAnswer) ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DisplayHtml(
                            htmlContent: answer.content ?? '',
                            fontSize: 16,
                            maxWidth: MediaQuery.of(context).size.width - 80,
                          ),
                        ),
                        if (showCorrectAnswer)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 20,
                          )
                        else if (showResult)
                          Icon(
                            isUserCorrect ? Icons.check_circle : Icons.cancel,
                            color: isUserCorrect
                                ? AppColors.success
                                : AppColors.danger,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            // Check if all answers are answered to show explanation
            if (questionOrderIndex != null) ...[
              Builder(
                builder: (context) {
                  final trueFalseAnswer = _userAnswers[questionOrderIndex];
                  final allAnswered =
                      trueFalseAnswer is String &&
                      !trueFalseAnswer.contains('-') &&
                      question.explanation != null;
                  if (allAnswered) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'Giải thích:',
                          style: Styles.medium.smb.copyWith(
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DisplayHtml(
                          htmlContent: question.explanation ?? '',
                          fontSize: 15,
                          maxWidth: MediaQuery.of(context).size.width - 80,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return SkeletonItem(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(44),
              width: double.infinity,
              height: 44,
            ),
          ),
          16.verticalSpace,
          Expanded(
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                borderRadius: BorderRadius.circular(16),
                width: double.infinity,
              ),
            ),
          ),
          12.verticalSpace,
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 50,
            ),
          ),
          12.verticalSpace,
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 50,
            ),
          ),
          12.verticalSpace,
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 50,
            ),
          ),
          12.verticalSpace,
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToQuestion(int index, BuildContext context) {
    if (!_questionSelectionScrollController.hasClients) return;

    final itemWidth = 52.0;
    final screenWidth = AppDimensions.fullscreenWidth;
    final targetOffset =
        (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2) + 16;

    _questionSelectionScrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _questionSelectionScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildQuestionSelection() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _questionSelectionScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _practiceBloc.state.questions.length,
        itemBuilder: (context, index) {
          final question = _practiceBloc.state.questions[index];
          final questionOrderIndex = question.orderIndex;
          bool isAnswered = false;
          if (questionOrderIndex != null) {
            final userValue = _userAnswers[questionOrderIndex];
            if (question.type == 'choice') {
              isAnswered = userValue != null;
            } else if (question.type == 'true_false') {
              final tf = userValue is String ? userValue : null;
              isAnswered = tf != null && !tf.contains('-');
            } else if (question.type == 'short_answer') {
              final sa = userValue is String ? userValue : null;
              isAnswered = sa != null && sa.isNotEmpty;
            }
          }
          final isCurrent = index == _currentPage;

          return GestureDetector(
            onTap: () {
              // Save current short answer before changing page
              if (_currentPage < _practiceBloc.state.questions.length) {
                final previousQuestion =
                    _practiceBloc.state.questions[_currentPage];
                if (previousQuestion.type == 'short_answer' &&
                    previousQuestion.orderIndex != null) {
                  _saveShortAnswer(previousQuestion.orderIndex!);
                }
              }

              _pageController.jumpToPage(index);
              setState(() {
                _currentPage = index;
              });

              // Load answer for new question if it exists
              if (index < _practiceBloc.state.questions.length) {
                final newQuestion = _practiceBloc.state.questions[index];
                if (newQuestion.type == 'short_answer' &&
                    newQuestion.orderIndex != null) {
                  final existingAnswer = _userAnswers[newQuestion.orderIndex!];
                  _shortAnswerController.text =
                      existingAnswer?.toString() ?? '';
                } else {
                  _shortAnswerController.clear();
                }
              }

              // Scroll question selection to center
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToQuestion(index, context);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent
                    ? AppColors.primary
                    : (isAnswered
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.white),
                border: Border.all(
                  color: isCurrent
                      ? AppColors.primary
                      : (isAnswered
                            ? AppColors.primary
                            : AppColors.borderColor),
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: Styles.small.regular.copyWith(
                    color: isCurrent
                        ? Colors.white
                        : (isAnswered ? AppColors.primary : Colors.black),
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
