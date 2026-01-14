import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/models/course_model.dart';
import 'package:learning_app/core/models/lesson_model.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/exam/data/repositories/exam_repository.dart';
import 'package:learning_app/modules/exam/general/exam_module_routes.dart';
import 'package:learning_app/modules/practice/data/repositories/practice_repository.dart';
import 'package:learning_app/modules/practice/general/practice_module_routes.dart';

class SubjectCoursePage extends StatefulWidget {
  const SubjectCoursePage({super.key});

  @override
  State<StatefulWidget> createState() => _SubjectCoursePageState();
}

class _SubjectCoursePageState extends State<SubjectCoursePage> {
  String _name = '';
  int _subjectId = -1;
  List<CourseModel> _exams = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    final args = Modular.args.data as Map<String, dynamic>?;

    _name = args?['name'] ?? '';
    final subjectIdValue = args?['subjectId'];
    if (subjectIdValue is int) {
      _subjectId = subjectIdValue;
    } else if (subjectIdValue is String) {
      _subjectId = int.tryParse(subjectIdValue) ?? -1;
    } else {
      _subjectId = -1;
    }

    _loadExams();
  }

  Future<void> _loadExams() async {
    final repository = Modular.get<PracticeRepository>();
    final rt = await repository.getCourses(subjectId: _subjectId);
    await Future.delayed(Duration(seconds: 2));
    rt.fold(
      (l) {
        Utils.debugLogError(l.reason);
        setState(() {
          _isLoading = false;
        });
      },
      (r) {
        setState(() {
          _isLoading = false;
          _exams = r;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(_name),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadExams,
        child: _isLoading
            ? _buildSkeletonList()
            : _exams.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _exams.length,
                itemBuilder: (context, index) {
                  final exam = _exams[index];
                  return _buildExamCard(exam).paddingOnly(bottom: 12);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[400]),
          16.verticalSpace,
          Text(
            'Chưa có đề thi',
            style: Styles.large.regular.copyWith(color: Colors.grey[600]),
          ),
          8.verticalSpace,
          Text(
            'Vui lòng thử lại sau',
            style: Styles.medium.secondary,
            textAlign: TextAlign.center,
          ),
        ],
      ).paddingSymmetric(h: 32),
    );
  }

  Widget _buildExamCard(CourseModel exam) {
    final lessonCount = exam.lessons?.length ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.only(bottom: 8),
          title: Text(
            exam.title ?? 'Đề thi',
            style: Styles.large.smb,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          children: lessonCount > 0
              ? List.generate(
                  lessonCount,
                  (index) => _buildLessonItem(exam.lessons![index], index),
                )
              : [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Chưa có bài học',
                      style: Styles.medium.secondary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(LessonModel lesson, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // childrenPadding: EdgeInsets.only(bottom: 8),
        title: Text(
          lesson.title ?? '',
          style: Styles.medium.regular,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        children: List.generate(
          lesson.exams?.length ?? 0,
          (index) => Button(
            onPress: () {
              NavigationHelper.navigate(
                '${AppRoutes.modulePractice}${PracticeModuleRoutes.courseQuestions}',
                args: {
                  'examId': lesson.exams?[index].id,
                  'subjectId': lesson.subjectId,
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                border: BoxBorder.fromLTRB(
                  top: BorderSide(color: AppColors.borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(lesson.exams?[index].title ?? '')),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.black54,
                  ),
                ],
              ),
            ).paddingOnly(left: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return Column(
      spacing: 12,
      children: [
        _buildSkeletonItem(),
        _buildSkeletonItem(),
        _buildSkeletonItem(),
        _buildSkeletonItem(),
        _buildSkeletonItem(),
        _buildSkeletonItem(),
        _buildSkeletonItem(),
      ],
    ).paddingOnly(top: 16, left: 16, right: 16);
  }

  Widget _buildSkeletonItem() {
    return SkeletonItem(
      child: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          borderRadius: BorderRadius.circular(16),
          height: 80,
          width: double.infinity,
        ),
      ),
    );
  }
}
