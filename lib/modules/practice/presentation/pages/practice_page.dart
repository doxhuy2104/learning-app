import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learning_app/core/components/buttons/button.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_dimensions.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/extensions/localized_extension.dart';
import 'package:learning_app/core/extensions/num_extension.dart';
import 'package:learning_app/core/extensions/widget_extension.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/practice/general/practice_module_routes.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_bloc.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_event.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_state.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<StatefulWidget> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final _practiceBloc = Modular.get<PracticeBloc>();
  @override
  void initState() {
    super.initState();
    if (_practiceBloc.state.subjects.isEmpty) {
      _practiceBloc.add(GetSubjects());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: Text(context.localization.practice),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<PracticeBloc, PracticeState>(
        bloc: _practiceBloc,
        builder: (context, state) {
          return state.subjects.isEmpty
              ? const Center(
                  child: Text(
                    'No subjects available',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    _practiceBloc.add(GetSubjects());
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: state.subjects.length,
                    itemBuilder: (context, index) {
                      final subject = state.subjects[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Button(
                          onPress: () {
                            NavigationHelper.navigate(
                              '${AppRoutes.modulePractice}${PracticeModuleRoutes.subjectCourse}',
                              args: {
                                'subjectId': subject.id,
                                'name': subject.title,
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            spacing: 8,
                            children: [
                              subject.image!.endsWith('png')
                                  ? CachedNetworkImage(
                                      imageUrl: subject.image ?? '',
                                      width: 40,
                                    )
                                  : SvgPicture.network(
                                      subject.image ?? '',
                                      width: 40,
                                    ),
                              Text(
                                subject.title ?? '',
                                style: Styles.large.smb,
                              ),
                            ],
                          ).paddingSymmetric(h: 16, v: 8),
                        ),
                      ).paddingOnly(bottom: 8);
                    },
                  ).paddingOnly(bottom: AppDimensions.paddingNavBar),
                );
        },
      ),
    );
  }
}
