import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/models/exam_history_model.dart';
import 'package:learning_app/core/models/subject_model.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_bloc.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_state.dart';
import 'package:learning_app/modules/exam/general/exam_module_routes.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_bloc.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_event.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_state.dart';
import 'package:learning_app/modules/practice/data/repositories/practice_repository.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final _examBloc = Modular.get<ExamBloc>();
  final _accountBloc = Modular.get<AccountBloc>();

  @override
  void initState() {
    super.initState();
    _examBloc.add(GetExams());
  }

  String _formatTime(int? minutes) {
    if (minutes == null) return '--';
    if (minutes < 60) return '$minutes phút';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) return '$hours giờ';
    return '$hours giờ $mins phút';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) return 'Vừa xong';
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Đề thi'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        bloc: _accountBloc,
        builder: (context, accountState) {
          final user = accountState.user;
          final subjects = user?.group?.subjects ?? [];

          if (subjects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  16.verticalSpace,
                  Text(
                    'Chưa chọn khối thi',
                    style: Styles.large.regular.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    'Vui lòng chọn khối thi trong thông tin tài khoản',
                    style: Styles.medium.secondary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ).paddingSymmetric(h: 32),
            );
          }

          return BlocBuilder<ExamBloc, ExamState>(
            bloc: _examBloc,
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  _examBloc.add(GetExams());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Cards Section
                      _buildSubjectSection(subjects).paddingOnly(top: 8),

                      // Exam History Section
                      _buildExamHistorySection(state.examHistory),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSubjectSection(List<SubjectModel> subjects) {
    return Container(
      width: AppDimensions.fullscreenWidth,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khối ${_accountBloc.state.user?.group?.name}',
            style: Styles.h5.smb,
          ),
          12.verticalSpace,
          Row(
            spacing: 8,
            children: [
              _buildSubjectCard(subjects[0]),
              _buildSubjectCard(subjects[1]),
              _buildSubjectCard(subjects[2]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(SubjectModel subject) {
    final shortTitle =
        subject.title
            ?.replaceAll('Giáo dục Kinh tế và Pháp luật', 'GDKTPL')
            .replaceAll('Giáo dục', '')
            .trim() ??
        'Môn học';

    return Expanded(
      child: Container(
        height: (AppDimensions.fullscreenWidth - 48) / 3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Button(
          onPress: () {
            NavigationHelper.navigate(
              '${AppRoutes.moduleExam}${ExamModuleRoutes.subjectExam}',
              args: {'subjectId': subject.id, 'name': subject.title},
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              subject.image!.endsWith('png')
                  ? CachedNetworkImage(imageUrl: subject.image ?? '', width: 40)
                  : SvgPicture.network(subject.image ?? '', width: 40),
              4.verticalSpace,
              Text(
                shortTitle,
                style: Styles.medium.smb,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamHistorySection(List<ExamHistoryModel> history) {
    final recentHistory = history.take(5).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lịch sử làm bài', style: Styles.h5.smb),
              if (history.length > 5)
                TextButton(
                  onPressed: () {
                    // Navigate to full history page
                  },
                  child: Text(
                    'Xem tất cả',
                    style: Styles.medium.regular.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          12.verticalSpace,
          if (recentHistory.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.history, size: 48, color: Colors.grey[400]),
                    12.verticalSpace,
                    Text(
                      'Chưa có lịch sử làm bài',
                      style: Styles.medium.secondary,
                    ),
                  ],
                ),
              ),
            )
          else
            ...recentHistory.map((item) => _buildHistoryItem(item)),
        ],
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigate to review exam
          NavigationHelper.navigate(
            '${AppRoutes.moduleApp}${AppModuleRoutes.questions}',
            args: {
              'examId': item.examId,
              'examTitle': item.examTitle,
              'isReview': true,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.quiz, color: AppColors.primary, size: 24),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.examTitle ?? 'Đề thi',
                      style: Styles.medium.smb,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        4.horizontalSpace,
                        Text(
                          '${item.score?.toStringAsFixed(1) ?? '0.0'}/10',
                          style: Styles.small.smb.copyWith(
                            color: Colors.amber[700],
                          ),
                        ),
                        12.horizontalSpace,
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        4.horizontalSpace,
                        Text(
                          _formatTime(item.timeSpentMinutes),
                          style: Styles.small.secondary,
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Text(
                      _formatDate(item.completedAt),
                      style: Styles.xsmall.secondary,
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
                      'examTitle': item.examTitle,
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
