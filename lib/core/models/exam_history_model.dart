import 'package:equatable/equatable.dart';

class ExamHistoryModel extends Equatable {
  final int? id;
  final int? examId;
  final String? examTitle;
  final double? score;
  final int? timeSpentMinutes;
  final DateTime? completedAt;
  final int? subjectId;
  final String? subjectName;

  const ExamHistoryModel({
    this.id,
    this.examId,
    this.examTitle,
    this.score,
    this.timeSpentMinutes,
    this.completedAt,
    this.subjectId,
    this.subjectName,
  });

  static ExamHistoryModel? fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? examId = mapData['examId'];
    final String? examTitle = mapData['examTitle'];
    final double? score = mapData['score'] != null
        ? (mapData['score'] as num).toDouble()
        : null;
    final int? timeSpentMinutes = mapData['timeSpentMinutes'];
    final DateTime? completedAt = mapData['completedAt'] != null
        ? DateTime.tryParse(mapData['completedAt'].toString())
        : null;
    final int? subjectId = mapData['subjectId'];
    final String? subjectName = mapData['subjectName'];

    return ExamHistoryModel(
      id: id,
      examId: examId,
      examTitle: examTitle,
      score: score,
      timeSpentMinutes: timeSpentMinutes,
      completedAt: completedAt,
      subjectId: subjectId,
      subjectName: subjectName,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'examId': examId,
    'examTitle': examTitle,
    'score': score,
    'timeSpentMinutes': timeSpentMinutes,
    'completedAt': completedAt?.toIso8601String(),
    'subjectId': subjectId,
    'subjectName': subjectName,
  };

  @override
  List<Object?> get props => [
    id,
    examId,
    examTitle,
    score,
    timeSpentMinutes,
    completedAt,
    subjectId,
    subjectName,
  ];
}
