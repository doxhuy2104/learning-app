import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/practice/data/repositories/practice_repository.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_event.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_state.dart';

class PracticeBloc extends HydratedBloc<PracticeEvent, PracticeState> {
  final PracticeRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  PracticeBloc({required this.repository})
    : super(const PracticeState.initial()) {
    on<PracticeEvent>((event, emit) async {
      if (event is GetSubjects && state.subjects.isEmpty) {
        final rt = await repository.getSubjects();

        rt.fold(
          (l) {
            Utils.debugLogError(l.reason);
          },
          (r) {
            emit(state.setState(subjects: r));
          },
        );
      }
    });
  }

  @override
  PracticeState? fromJson(Map<String, dynamic> json) {
    return PracticeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PracticeState state) {
    return state.toJson();
  }
}
