import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/modules/app/data/repositories/app_repository.dart';
import 'package:learning_app/modules/app/presentation/blocs/app_event.dart';
import 'package:learning_app/modules/app/presentation/blocs/app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  final AppRepository repository;
  AppBloc({required this.repository}) : super(AppState.initial()) {
    on<AppEvent>((event, emit) async {
      
    });
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return state.toJson();
  }
}
