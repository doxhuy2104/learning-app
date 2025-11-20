part of 'exam_bloc.dart';

sealed class ExamState extends Equatable {
  const ExamState();
  
  @override
  List<Object> get props => [];
}

final class ExamInitial extends ExamState {}
