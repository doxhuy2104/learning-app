import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/components/buttons/outline_button.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/components/display_html.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_bloc.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_event.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_state.dart';

class ExamQuestionsResultPage extends StatefulWidget {
  const ExamQuestionsResultPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamQuestionsResultPageState();
}

class _ExamQuestionsResultPageState extends State<ExamQuestionsResultPage> {
  final _examBloc = Modular.get<ExamBloc>();
  late PageController _pageController;
  late ScrollController _questionSelectionScrollController;
  int _currentPage = 0;

  String? _examTitle;
  int? _historyId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _questionSelectionScrollController = ScrollController();
    final args = Modular.args.data as Map<String, dynamic>;
    _examTitle = args['examTitle'] ?? '';
    if (args['historyId'] != null) {
      _examBloc.add(
        GetHistory(historyId: args['historyId'], examId: args['examId']),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _questionSelectionScrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_examTitle ?? 'Questions'),
        backgroundColor: Colors.white,
        actions: [
          Button(
            onPress: () {
              NavigationHelper.replace(
                '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
              );
            },
            showEffect: false,
            child: Icon(Icons.home_outlined),
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
                          _buildQuestionSelection(state),
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
                                return _buildQuestionCard(question, state);
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
                    Expanded(child: SizedBox()),

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
    );
  }

  Widget _buildQuestionCard(QuestionModel question, ExamState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DisplayHtml(htmlContent: question.content ?? ''),
          const SizedBox(height: 12),
          if (question.type == 'choice') ...[
            ...question.answers!.asMap().entries.map((entry) {
              final answer = entry.value;
              final isUserChoosed =
                  state.userAnswers[question.orderIndex]?.answerOrderIndex ==
                  answer.orderIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: answer.isCorrect ?? false ? 3 : 4,
                    horizontal: answer.isCorrect ?? false ? 15 : 16,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: answer.isCorrect ?? false
                        ? AppColors.trueColor.withOpacity(0.05)
                        : isUserChoosed
                        ? AppColors.fail.withOpacity(0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: answer.isCorrect ?? false
                          ? AppColors.trueColor
                          : isUserChoosed
                          ? AppColors.fail
                          : AppColors.borderColor,
                      width: answer.isCorrect ?? false ? 2 : 1,
                    ),
                  ),
                  child: DisplayHtml(
                    htmlContent: answer.content ?? '',
                    fontSize: 16,
                    maxWidth: MediaQuery.of(context).size.width - 80,
                  ),
                ),
              );
            }).toList(),
            if (question.explanation != null) ...[
              12.verticalSpace,
              Text(
                'Giải thích:',
                style: Styles.medium.smb.copyWith(color: Colors.black87),
              ),
              6.verticalSpace,
              DisplayHtml(
                htmlContent: question.explanation ?? '',
                fontSize: 15,
                maxWidth: MediaQuery.of(context).size.width - 80,
              ),
            ],
          ] else if (question.type == 'short_answer') ...[
            // TextInput(
            //   keyboardType: TextInputType.number,
            //   placeholder: 'Nhập đáp án',
            //   disable: true,
            // ),
            Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                border: BoxBorder.all(
                  color:
                      state.userAnswers[question.orderIndex]?.shortAnswer ==
                          null
                      ? AppColors.borderColor
                      : state.userAnswers[question.orderIndex]?.isCorrect ??
                            false
                      ? AppColors.trueColor
                      : AppColors.fail,
                ),
                borderRadius: BorderRadius.circular(44),
                color:
                    state.userAnswers[question.orderIndex]?.shortAnswer == null
                    ? Colors.white
                    : state.userAnswers[question.orderIndex]?.isCorrect ?? false
                    ? AppColors.trueColor.withValues(alpha: 0.05)
                    : AppColors.fail.withValues(alpha: 0.05),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 8),
              child: state.userAnswers[question.orderIndex]?.shortAnswer != null
                  ? Text(
                      state.userAnswers[question.orderIndex]?.shortAnswer ?? '',
                      style: Styles.medium.regular.copyWith(
                        color:
                            state.userAnswers[question.orderIndex]?.isCorrect ??
                                false
                            ? AppColors.trueColor
                            : AppColors.fail,
                      ),
                    )
                  : SizedBox(),
            ),
            if (question.explanation != null) ...[
              12.verticalSpace,
              Text(
                'Giải thích:',
                style: Styles.medium.smb.copyWith(color: Colors.black87),
              ),
              6.verticalSpace,
              DisplayHtml(
                htmlContent: question.explanation ?? '',
                fontSize: 15,
                maxWidth: MediaQuery.of(context).size.width - 80,
              ),
            ],
          ] else ...[
            ...question.answers!.asMap().entries.map((entry) {
              final answer = entry.value;
              String userAnswer =
                  state.userAnswers[question.orderIndex]?.trueFalseAnswer?[entry
                      .key] ??
                  '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: userAnswer == 'T' || userAnswer == 'F' ? 3 : 4,
                    horizontal: userAnswer == 'T' || userAnswer == 'F'
                        ? 15
                        : 16,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: userAnswer == 'T'
                        ? AppColors.trueColor.withValues(alpha: 0.05)
                        : userAnswer == 'F'
                        ? AppColors.fail.withValues(alpha: 0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: userAnswer == 'T'
                          ? AppColors.trueColor
                          : userAnswer == 'F'
                          ? AppColors.fail
                          : AppColors.borderColor,
                      width: userAnswer == 'T' || userAnswer == 'F' ? 2 : 1,
                    ),
                  ),
                  child: DisplayHtml(
                    htmlContent: answer.content ?? '',
                    fontSize: 16,
                    maxWidth: MediaQuery.of(context).size.width - 80,
                  ),
                ),
              );
            }).toList(),
            if (question.explanation != null) ...[
              12.verticalSpace,
              Text(
                'Giải thích:',
                style: Styles.medium.smb.copyWith(color: Colors.black87),
              ),
              6.verticalSpace,
              DisplayHtml(
                htmlContent: question.explanation ?? '',
                fontSize: 15,
                maxWidth: MediaQuery.of(context).size.width - 80,
              ),
            ],
          ],
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

  Widget _buildQuestionSelection(ExamState state) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _questionSelectionScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: state.questions.length,
        itemBuilder: (context, index) {
          final question = state.questions[index];
          final questionOrderIndex = question.orderIndex;
          final userAnswer = state.userAnswers[questionOrderIndex];
          final isCorrect = userAnswer?.isCorrect;
          final isAnswered = userAnswer != null;
          final isCurrent = index == _currentPage;

          Color bgColor;
          Color borderColor;
          Color textColor;

          if (isCurrent) {
            bgColor = AppColors.primary;
            borderColor = AppColors.primary;
            textColor = Colors.white;
          } else if (!isAnswered) {
            bgColor = Colors.white;
            borderColor = AppColors.borderColor;
            textColor = AppColors.primaryText;
          } else if (isCorrect == null) {
            // Màu vàng cho isCorrect = null
            bgColor = Colors.amber.withOpacity(0.1);
            borderColor = Colors.amber;
            textColor = Colors.amber.shade700;
          } else if (isCorrect) {
            bgColor = AppColors.trueColor.withOpacity(0.1);
            borderColor = AppColors.trueColor;
            textColor = AppColors.trueColor;
          } else {
            bgColor = AppColors.fail.withOpacity(0.1);
            borderColor = AppColors.fail;
            textColor = AppColors.fail;
          }

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
                color: bgColor,
                border: Border.all(
                  color: borderColor,
                  width: isCurrent ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: Styles.small.regular.copyWith(
                    color: textColor,
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
}
