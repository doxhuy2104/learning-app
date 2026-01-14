import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/components/buttons/outline_button.dart';
import 'package:learning_app/core/components/buttons/primary_button.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/modules/exam/general/exam_module_routes.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_bloc.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_state.dart';

class ExamResultPage extends StatelessWidget {
  const ExamResultPage({super.key});

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả bài thi'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationHelper.goBack(),
        ),
      ),
      body: BlocBuilder<ExamBloc, ExamState>(
        bloc: Modular.get<ExamBloc>(),
        builder: (context, state) {
          final history = state.examHistory;
          if (history == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final score = history.score ?? 0;
          final timeSpentSeconds = history.timeSpent ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Điểm',
                        style: Styles.large.smb.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      8.verticalSpace,

                      Text(
                        score.toStringAsFixed(2),
                        style: Styles.h1.smb.copyWith(color: AppColors.primary),
                      ),

                      12.verticalSpace,

                      Text(
                        'Thời gian: ${_formatTime(timeSpentSeconds)}',
                        style: Styles.medium.regular,
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,

                PrimaryButton(
                  onPress: () {
                    NavigationHelper.push(
                      '${AppRoutes.moduleExam}${ExamModuleRoutes.examQuestionsResult}',
                      args: {
                        'examId': history.examId,
                        'examTitle': 'Kết quả bài thi',
                      },
                    );
                  },
                  text: 'Xem chi tiết',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
