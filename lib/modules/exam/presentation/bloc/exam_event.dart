
import 'package:equatable/equatable.dart';

sealed class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object> get props => [];
}
 class GetExams extends ExamEvent{}