import 'package:equatable/equatable.dart';

class ExamHistoryModel extends Equatable {
  final int? id;
  final int? examId;
  final double? score;
  final int? timeSpent;
  final int? subjectId;

  const ExamHistoryModel({
    this.id,
    this.examId,
    this.score,
    this.timeSpent,
    this.subjectId,
  });

  static ExamHistoryModel? fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? examId = mapData['examId'];
    final double? score = mapData['score'] != null
        ? (mapData['score'] as num).toDouble()
        : null;
    final int? timeSpent = mapData['timeSpent'];
    final DateTime? completedAt = mapData['completedAt'] != null
        ? DateTime.tryParse(mapData['completedAt'].toString())
        : null;
    final int? subjectId = mapData['subjectId'];
    final String? subjectName = mapData['subjectName'];

    return ExamHistoryModel(
      id: id,
      examId: examId,
      score: score,
      timeSpent: timeSpent,
      subjectId: subjectId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'examId': examId,
    'score': score,
    'timeSpent': timeSpent,
    'subjectId': subjectId,
  };

  @override
  List<Object?> get props => [
    id,
    examId,
    score,
    timeSpent,
    subjectId,
  ];
}
