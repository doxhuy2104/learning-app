import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/course_model.dart';
import 'package:learning_app/core/models/subject_model.dart';

final class PracticeState extends Equatable {
  final List<SubjectModel> subjects;

  const PracticeState._({this.subjects = const []});

  const PracticeState.initial() : this._();

  PracticeState setState({List<SubjectModel>? subjects}) {
    return PracticeState._(subjects: subjects ?? this.subjects);
  }

  PracticeState.fromJson(Map<String, dynamic> json)
    : subjects =
          (json['subjects'] as List<dynamic>?)
              ?.map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
              .whereType<SubjectModel>()
              .toList() ??
          [];

  Map<String, dynamic> toJson() => {
    'subjects': subjects.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object> get props => [subjects.hashCode];
}
