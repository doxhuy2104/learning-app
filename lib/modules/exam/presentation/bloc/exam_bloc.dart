import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  ExamBloc() : super(ExamInitial()) {
    on<ExamEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
