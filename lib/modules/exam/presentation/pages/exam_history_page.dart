import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/models/exam_history_model.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/exam/general/exam_module_routes.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_bloc.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_event.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_state.dart';

class ExamHistoryPage extends StatefulWidget {
  const ExamHistoryPage({super.key});

  @override
  State<ExamHistoryPage> createState() => _ExamHistoryPageState();
}

class _ExamHistoryPageState extends State<ExamHistoryPage> {
  final _examBloc = Modular.get<ExamBloc>();

  @override
  void initState() {
    super.initState();
    _examBloc.add(GetHistories());
  }

  String _formatTime(int? time) {
    if (time == null) return '--';
    if (time < 60) {
      return '$time giây';
    } else if (time < 3600) {
      final mins = time ~/ 60;
      return '$mins phút';
    }
    final minute = time ~/ 60;
    final hours = minute ~/ 60;
    final mins = minute % 60;
    if (mins == 0) return '$hours giờ';
    return '$hours giờ $mins phút';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.localization.history)),
      body: BlocBuilder<ExamBloc, ExamState>(
        bloc: _examBloc,
        builder: (context, state) {
          final histories = state.examHistories;

          if (histories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[400]),
                  12.verticalSpace,
                  Text(
                    'Chưa có lịch sử làm bài',
                    style: Styles.medium.secondary,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _examBloc.add(GetHistories());
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final item = histories[index];
                return _buildHistoryItem(item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(ExamHistoryModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Button(
        onPress: () {
          NavigationHelper.navigate(
            '${AppRoutes.moduleExam}${ExamModuleRoutes.examQuestionsResult}',
            args: {
              'historyId': item.id,
              'examTitle': item.exam?.title,
              'examId': item.examId,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.exam?.title ?? '',
                      style: Styles.medium.smb,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Text(
                          item.score?.toString() ?? '',
                          style: Styles.small.smb,
                        ),
                        12.horizontalSpace,
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        4.horizontalSpace,
                        Text(
                          _formatTime(item.timeSpent),
                          style: Styles.small.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  NavigationHelper.navigate(
                    '${AppRoutes.moduleApp}${AppModuleRoutes.questions}',
                    args: {
                      'examId': item.examId,
                      'examTitle': '',
                      'isReview': true,
                    },
                  );
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
