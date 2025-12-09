import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:learning_app/core/components/app_dialog.dart';
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
  Map<int, int?> _selectedAnswers = {};

  Timer? _timer;
  ValueNotifier<int>? _remainingTimeNotifier;

  late int _examId;
  String? _examTitle;
  int _duration = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questionSelectionScrollController = ScrollController();

    final args = Modular.args.data as Map<String, dynamic>?;
    _examId = args?['examId'] ?? 0;
    _examTitle = args?['examTitle'] ?? '';
    _duration = args?['duration'] ?? 0;
    Utils.debugLog(_duration);

    final initialTime = _duration * 60;
    _remainingTimeNotifier = ValueNotifier<int>(initialTime);
    _loadQuestions();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeNotifier != null) {
        final currentTime = _remainingTimeNotifier!.value;
        if (currentTime > 0) {
          _remainingTimeNotifier!.value = currentTime - 1;
        } else {
          _timer?.cancel();
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
    _examBloc.add(ResetExamData());
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
        _examBloc.add(ResetExamData());
        AppDialog.hide();
        NavigationHelper.goBack();
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
                    ? _buildSkeleton().paddingAll(16)
                    : Expanded(
                        child: Column(
                          children: [
                            _buildQuestionSelection(),
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
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
          // listener: (context, state) {},
          // child: ,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel question) {
    final questionOrderIndex = question.orderIndex;
    final selectedAnswerOrderIndex = _selectedAnswers[questionOrderIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DisplayHtml(htmlContent: question.content ?? ''),
          const SizedBox(height: 12),
          if (question.answers != null && question.answers!.isNotEmpty) ...[
            ...question.answers!.asMap().entries.map((entry) {
              final answer = entry.value;
              final answerOrderIndex = answer.orderIndex;
              final isSelected = selectedAnswerOrderIndex == answerOrderIndex;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Button(
                  onPress: () {
                    if (questionOrderIndex == null) return;
                    // if (isSelected) {
                    //   _selectedAnswers.remove(questionId);
                    // }
                    //  else {
                    if (_selectedAnswers[questionOrderIndex] !=
                        answerOrderIndex) {
                      setState(() {
                        _selectedAnswers[questionOrderIndex] = answerOrderIndex;
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
                    padding: EdgeInsets.all(isSelected ? 15 : 16),
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
                      fontSize: 16,
                      maxWidth: MediaQuery.of(context).size.width - 80,
                    ),
                  ),
                ),
              );
            }).toList(),
          ] else
            TextInput(
              keyboardType: TextInputType.number,
              placeholder: 'Nhập đáp án',
            ),
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
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 200,
            ),
          ),
          12.verticalSpace,
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 70,
            ),
          ),
          12.verticalSpace,
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 70,
            ),
          ),
          12.verticalSpace,
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 70,
            ),
          ),
          12.verticalSpace,
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              borderRadius: BorderRadius.circular(16),
              width: double.infinity,
              height: 70,
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListView.builder(
        controller: _questionSelectionScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _examBloc.state.questions.length,
        itemBuilder: (context, index) {
          final questionOrderIndex =
              _examBloc.state.questions[index].orderIndex;
          final isAnswered = _selectedAnswers[questionOrderIndex] != null;
          final isCurrent = index == _currentPage;

          return GestureDetector(
            onTap: () {
              _pageController.jumpToPage(index);
              setState(() {
                _currentPage = index;
              });
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
