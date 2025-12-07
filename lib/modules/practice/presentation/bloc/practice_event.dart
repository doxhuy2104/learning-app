import 'package:equatable/equatable.dart';

sealed class PracticeEvent extends Equatable {
  const PracticeEvent();

  @override
  List<Object> get props => [];
}

class GetSubjects extends PracticeEvent {}
