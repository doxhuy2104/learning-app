import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/models/course_model.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/practice/data/repositories/practice_repository.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_bloc.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_state.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<StatefulWidget> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final _repository = Modular.get<PracticeRepository>();
  List<CourseModel> _courses = [];
  int? _subjectId;
  @override
  void initState() {
    super.initState();
    final args = Modular.args.data as Map<String, dynamic>?;

    _subjectId = args?['subjectId'];
  }

  void _loadCourses() async {
    final rt = await _repository.getCourses(subjectId: _subjectId ?? -1);

    rt.fold(
      (l) {
        Utils.debugLogError(l.reason);
      },
      (r) {
        _courses = r;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDimensions.insetTop(context).verticalSpace,
          Text(
            context.localization.practice,
            style: Styles.h4.regular,
          ).paddingOnly(left: 16),
        ],
      ),
    );
  }
}
