import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/models/exam_model.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/app/data/repositories/app_repository.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/exam/data/repositories/exam_repository.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_bloc.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_event.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_state.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  final _repository = Modular.get<AppRepository>();
  List<ExamModel> _exams = [];
  int? _courseId;
  int? _lessonId;

  String _year = '';
  @override
  void initState() {
    super.initState();

    final args = Modular.args.data as Map<String, dynamic>;
    _courseId = args['courseId'];
    _lessonId = args['lessonId'];

    _year = args['year'];
    loadExams();
  }

  void loadExams() async {
    final rt = await _repository.getExams(
      courseId: _courseId,
      lessonId: _lessonId,
    );
    rt.fold(
      (l) {
        Utils.debugLogError(l.reason);
      },
      (r) {
        setState(() {
          _exams = r;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_year)),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _exams.length,
          itemBuilder: (context, index) {
            final exam = _exams[index];
            return Container(
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
              child: Button(
                borderRadius: BorderRadius.circular(12),
                onPress: () {
                  NavigationHelper.navigate(
                    '${AppRoutes.moduleApp}${AppModuleRoutes.questions}',
                    args: {'examId': exam.id, 'examTitle': exam.title},
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exam.title ?? '',
                              style: Styles.large.smb,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ).paddingOnly(bottom: 8);
          },
        ),
      ),
    );
  }
}
