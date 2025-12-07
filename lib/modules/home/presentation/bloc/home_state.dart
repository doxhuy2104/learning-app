import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/subject_model.dart';

final class HomeState extends Equatable {
  final List<SubjectModel> subjects;

  const HomeState._({this.subjects = const []});
  const HomeState.initial() : this._();
  HomeState setState({List<SubjectModel>? subjects}) {
    return HomeState._(subjects: subjects ?? this.subjects);
  }

  HomeState.fromJson(Map<String, dynamic> json)
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
