import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/exam_model.dart';
import 'package:learning_app/core/models/user_answer_model.dart';

class ExamHistoryModel extends Equatable {
  final int? id;
  final int? examId;
  final int? subjectId;

  final double? score;
  final int? timeSpent;
  final List<UserAnswerModel>? answers;
  final ExamModel? exam;
  const ExamHistoryModel({
    this.id,
    this.examId,
    this.score,
    this.timeSpent,
    this.answers,
    this.exam,
    this.subjectId,
  });

  static ExamHistoryModel? fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? examId = mapData['examId'];
    final int? subjectId = mapData['subjectId'];

    final dynamic rawScore = mapData['score'];
    double? score;
    if (rawScore != null) {
      if (rawScore is num) {
        score = rawScore.toDouble();
      } else {
        score = double.tryParse(rawScore.toString());
      }
    }
    final int? timeSpent = mapData['timeSpent'];
    final List<UserAnswerModel>? answers =
        (mapData['answers'] as List<dynamic>?)
            ?.map(
              (e) =>
                  UserAnswerModel.fromJson(e as Map<String, dynamic>)
                      as UserAnswerModel,
            )
            .toList();
    final ExamModel? exam = ExamModel.fromJson(
      mapData['exam'] as Map<String, dynamic>?,
    );
    return ExamHistoryModel(
      id: id,
      examId: examId,
      subjectId: subjectId,
      score: score,
      timeSpent: timeSpent,
      answers: answers,
      exam: exam,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'examId': examId,
    'subjectId': subjectId,
    'score': score,
    'timeSpent': timeSpent,
    'answers': answers?.map((e) => e.toJson()).toList(),
    'exam': exam?.toJson(),
  };

  @override
  List<Object?> get props => [
    id,
    examId,
    subjectId,
    score,
    timeSpent,
    answers.hashCode,
    exam.hashCode,
  ];

  @override
  String toString() {
    return 'ExamHistory: id:$id, examId: $examId, score: $score, timeSpent: $timeSpent, answers: $answers';
  }
}
