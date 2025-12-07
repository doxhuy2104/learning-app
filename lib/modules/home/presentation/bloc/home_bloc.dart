import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/home/data/repositories/home_repository.dart';
import 'package:learning_app/modules/home/presentation/bloc/home_event.dart';
import 'package:learning_app/modules/home/presentation/bloc/home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  HomeBloc({required this.repository}) : super(const HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      if (event is GetSubjects) {
        Utils.debugLog('Get subjects');
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
  HomeState? fromJson(Map<String, dynamic> json) {
    return HomeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return state.toJson();
  }
}
