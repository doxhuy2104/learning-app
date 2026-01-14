import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:learning_app/core/components/app_dialog.dart';
import 'package:learning_app/core/components/app_indicator.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/components/buttons/outline_button.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/components/display_html.dart';
import 'package:learning_app/core/components/inputs/text_input.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_bloc.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_event.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_state.dart';

// Separate timer widget to avoid rebuilding other parts
class ExamTimerWidget extends StatelessWidget {
  final ValueNotifier<int> remainingTimeNotifier;

  const ExamTimerWidget({super.key, required this.remainingTimeNotifier});

  String _formatTime(int totalSecond) {
    int minutes = totalSecond ~/ 60;
    int seconds = totalSecond % 60;
    return '${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: remainingTimeNotifier,
      builder: (context, remainingTime, child) {
        return Container(
          height: 44,
          // decoration: BoxDecoration(
          //   color: Colors.blue[50],
          //   borderRadius: BorderRadius.circular(12),
          // ),
          alignment: Alignment.center,
          child: Container(
            width: 85,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.clock_copy,
                  size: 20,
                  color: remainingTime < 300
                      ? AppColors.danger
                      : AppColors.primary,
                ),
                8.horizontalSpace,
                Text(
                  _formatTime(remainingTime),
                  style: Styles.h5.regular.copyWith(
                    color: remainingTime < 300
                        ? AppColors.danger
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExamQuestionsPage extends StatefulWidget {
  const ExamQuestionsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamQuestionsPageState();
}

class _ExamQuestionsPageState extends State<ExamQuestionsPage> {
  final _examBloc = Modular.get<ExamBloc>();
  late PageController _pageController;
  late ScrollController _questionSelectionScrollController;
  int _currentPage = 0;
  final Map<int, dynamic> _userAnswers = {};
  // Map<int, String?> _trueFalseAnswers = {};
  // Map<int, String?> _shortAnswers = {};

  Timer? _timer;
  ValueNotifier<int>? _remainingTimeNotifier;

  late int _examId;
  late int _subjectId;

  String? _examTitle;
  int _duration = 0;
  final _shortAnswerController = TextEditingController();
  final _shortAnswerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questionSelectionScrollController = ScrollController();

    final args = Modular.args.data as Map<String, dynamic>?;
    _examId = args?['examId'] ?? 0;
    _subjectId = args?['subjectId'] ?? 0;

    _examTitle = args?['examTitle'] ?? '';
    _duration = args?['duration'] ?? 0;
    Utils.debugLog(_duration);

    final initialTime = _duration * 60;
    // final initialTime = 10;
    _examBloc.add(ResetExamData());
    _remainingTimeNotifier = ValueNotifier<int>(initialTime);
    _loadQuestions();
    _startTimer();
    _setupShortAnswerFocusListener();
  }

  void _setupShortAnswerFocusListener() {
    _shortAnswerFocusNode.addListener(() {
      if (!_shortAnswerFocusNode.hasFocus) {
        // User unfocused the text input, save the answer
        if (_currentPage < _examBloc.state.questions.length) {
          final currentQuestion = _examBloc.state.questions[_currentPage];
          if (currentQuestion.type == 'short_answer' &&
              currentQuestion.orderIndex != null) {
            _saveShortAnswer(currentQuestion.orderIndex!);
          }
        }
      }
    });
  }

  void _saveShortAnswer(int questionOrderIndex) {
    final answerText = _shortAnswerController.text.trim();

    setState(() {
      _userAnswers[questionOrderIndex] = answerText.isNotEmpty
          ? answerText
          : null;
    });

    _examBloc.add(
      AddUserAnswer(
        examId: _examId,
        questionOrderIndex: questionOrderIndex,
        answerOrderIndex: null,
        shortAnswer: answerText.isNotEmpty ? answerText : null,
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeNotifier != null) {
        final currentTime = _remainingTimeNotifier!.value;
        if (currentTime > 0) {
          _remainingTimeNotifier!.value = currentTime - 1;
        } else {
          _timer?.cancel();
          NavigationHelper.goBack();
        }
      }
    });
  }

  Future<void> _loadQuestions() async {
    _examBloc.add(GetExamQuestions(examId: _examId));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _remainingTimeNotifier?.dispose();
    _pageController.dispose();
    _questionSelectionScrollController.dispose();
    _shortAnswerController.dispose();
    _shortAnswerFocusNode.dispose();
    // _examBloc.add(ResetExamData());
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _examBloc.state.questions.length - 1) {
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

  void _showSubmitDialog() {
    AppDialog.show(
      title: context.localization.submitTitle,
      message: context.localization.submitMessage,
      confirmText: context.localization.submit,
      cancelText: context.localization.cancel,
      onConfirm: () {
        AppDialog.hide();
        _examBloc.add(
          SubmitExam(
            examId: _examId,
            timeSpent: _duration * 60 - _remainingTimeNotifier!.value,
            subjectId: _subjectId,
          ),
        );
        AppIndicator.show();
      },
      onCancel: () {
        AppDialog.hide();
      },
      dismissible: false,
    );
  }

  void _showExitDialog() {
    AppDialog.show(
      title: context.localization.exitTitle,
      message: context.localization.exitMessage,
      confirmText: context.localization.exit,
      cancelText: context.localization.cancel,
      onConfirm: () {
        _examBloc.add(ResetExamData());
        AppDialog.hide();
        Modular.to.pop();
      },
      onCancel: () {
        AppDialog.hide();
      },
      dismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          _showExitDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_examTitle ?? 'Questions'),

          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _showExitDialog();
            },
          ),
          actions: [
            Button(
              onPress: _showSubmitDialog,
              showEffect: false,
              child: Text(
                context.localization.submit,
                style: Styles.large.regular.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ).paddingOnly(right: 16),
          ],
        ),
        body: BlocBuilder<ExamBloc, ExamState>(
          bloc: _examBloc,
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
                                      _examBloc.state.questions.length) {
                                    final previousQuestion =
                                        _examBloc.state.questions[_currentPage];
                                    if (previousQuestion.type ==
                                            'short_answer' &&
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
                                      _examBloc.state.questions.length) {
                                    final newQuestion =
                                        _examBloc.state.questions[index];
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
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          final existingAnswer =
                                              _userAnswers[question
                                                  .orderIndex!];
                                          if (_shortAnswerController.text !=
                                              (existingAnswer?.toString() ??
                                                  '')) {
                                            _shortAnswerController.text =
                                                existingAnswer?.toString() ??
                                                '';
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
                      Expanded(
                        child: _remainingTimeNotifier != null
                            ? ExamTimerWidget(
                                remainingTimeNotifier: _remainingTimeNotifier!,
                              )
                            : SizedBox(),
                      ),

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
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel question) {
    final questionOrderIndex = question.orderIndex;
    final selectedAnswerOrderIndex = _userAnswers[questionOrderIndex];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(question.orderIndex.toString()),
          DisplayHtml(
            htmlContent: question.content ?? '',
            dataType: question.dataType,
          ),

          const SizedBox(height: 12),
          if (question.type == 'choice') ...[
            ...question.answers!.asMap().entries.map((entry) {
              final answer = entry.value;
              final answerOrderIndex = answer.orderIndex;
              final isSelected = selectedAnswerOrderIndex == answerOrderIndex;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Button(
                  onPress: () {
                    if (questionOrderIndex == null) return;
                    if (_userAnswers[questionOrderIndex] != answerOrderIndex) {
                      setState(() {
                        _userAnswers[questionOrderIndex] = answerOrderIndex;
                      });
                      _examBloc.add(
                        AddUserAnswer(
                          examId: _examId,
                          questionOrderIndex: questionOrderIndex,
                          isCorrect: answer.isCorrect ?? false,
                          answerOrderIndex: answerOrderIndex,
                        ),
                      );
                    }

                    // }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isSelected ? 3 : 4,
                      horizontal: isSelected ? 15 : 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: DisplayHtml(
                      htmlContent: answer.content ?? '',
                      dataType: answer.dataType,
                      fontSize: 16,
                      maxWidth: MediaQuery.of(context).size.width - 80,
                    ),
                  ),
                ),
              );
            }).toList(),
          ] else if (question.type == 'short_answer') ...[
            TextInput(
              controller: _shortAnswerController,
              focusNode: _shortAnswerFocusNode,
              keyboardType: TextInputType.number,
              placeholder: 'Nhập đáp án',
            ),
          ] else ...[
            ...question.answers!.asMap().entries.map((entry) {
              final answer = entry.value;
              final answerOrderIndex = answer.orderIndex;
              String? trueFalseAnswer = _userAnswers[questionOrderIndex];
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
                    _examBloc.add(
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
                      vertical: trueFalseAnswer?[entry.key] != null ? 3 : 4,
                      horizontal: trueFalseAnswer?[entry.key] != null ? 15 : 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          trueFalseAnswer?[entry.key] != null &&
                              trueFalseAnswer?[entry.key] != '-'
                          ? (trueFalseAnswer![entry.key] == 'T'
                                ? AppColors.success.withValues(alpha: 0.05)
                                : AppColors.danger.withValues(alpha: 0.05))
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            trueFalseAnswer?[entry.key] != null &&
                                trueFalseAnswer?[entry.key] != '-'
                            ? (trueFalseAnswer![entry.key] == 'T'
                                  ? AppColors.success
                                  : AppColors.danger)
                            : AppColors.borderColor,
                        width:
                            trueFalseAnswer?[entry.key] != null &&
                                trueFalseAnswer?[entry.key] != '-'
                            ? 2
                            : 1,
                      ),
                    ),
                    child: DisplayHtml(
                      htmlContent: answer.content ?? '',
                      dataType: answer.dataType,
                      fontSize: 16,
                      maxWidth: MediaQuery.of(context).size.width - 80,
                    ),
                  ),
                ),
              );
            }).toList(),
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
        itemCount: _examBloc.state.questions.length,
        itemBuilder: (context, index) {
          final question = _examBloc.state.questions[index];
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
              if (_currentPage < _examBloc.state.questions.length) {
                final previousQuestion =
                    _examBloc.state.questions[_currentPage];
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
              if (index < _examBloc.state.questions.length) {
                final newQuestion = _examBloc.state.questions[index];
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
