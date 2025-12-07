import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/course_model.dart';
import 'package:learning_app/core/models/exam_history_model.dart';

final class ExamState extends Equatable {
  final List<CourseModel> exams;
  final List<ExamHistoryModel> examHistory;
  final int weeklyGoal;
  final int weeklyCompleted;
  final int monthlyGoal;
  final int monthlyCompleted;

  const ExamState._({
    this.exams = const [],
    this.examHistory = const [],
    this.weeklyGoal = 6,
    this.weeklyCompleted = 4,
    this.monthlyGoal = 24,
    this.monthlyCompleted = 18,
  });
  const ExamState.initial() : this._();
  ExamState setState({
    List<CourseModel>? exams,
    List<ExamHistoryModel>? examHistory,
    int? weeklyGoal,
    int? weeklyCompleted,
    int? monthlyGoal,
    int? monthlyCompleted,
  }) {
    return ExamState._(
      exams: exams ?? this.exams,
      examHistory: examHistory ?? this.examHistory,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      weeklyCompleted: weeklyCompleted ?? this.weeklyCompleted,
      monthlyGoal: monthlyGoal ?? this.monthlyGoal,
      monthlyCompleted: monthlyCompleted ?? this.monthlyCompleted,
    );
  }

  ExamState.fromJson(Map<String, dynamic> json)
    : exams =
          (json['exams'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
              .whereType<CourseModel>()
              .toList() ??
          [],
      examHistory =
          (json['examHistory'] as List<dynamic>?)
              ?.map((e) => ExamHistoryModel.fromJson(e as Map<String, dynamic>))
              .whereType<ExamHistoryModel>()
              .toList() ??
          [],
      weeklyGoal = json['weeklyGoal'] ?? 6,
      weeklyCompleted = json['weeklyCompleted'] ?? 0,
      monthlyGoal = json['monthlyGoal'] ?? 24,
      monthlyCompleted = json['monthlyCompleted'] ?? 0;

  Map<String, dynamic> toJson() => {
    'exams': exams.map((e) => e.toJson()).toList(),
    'examHistory': examHistory.map((e) => e.toJson()).toList(),
    'weeklyGoal': weeklyGoal,
    'weeklyCompleted': weeklyCompleted,
    'monthlyGoal': monthlyGoal,
    'monthlyCompleted': monthlyCompleted,
  };

  @override
  List<Object> get props => [
    exams.hashCode,
    examHistory.hashCode,
    weeklyGoal,
    weeklyCompleted,
    monthlyGoal,
    monthlyCompleted,
  ];
}
