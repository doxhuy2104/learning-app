import 'package:equatable/equatable.dart';

class UserAnswerModel extends Equatable {
  final int? id;
  final int? userId;
  final int? examId;
  final int? questionId;
  final String? userAnswer;
  final bool? isCorrect;
  final int? pointsEarned;
  final int? time;
  final DateTime? answeredAt;

  const UserAnswerModel({
    this.id,
    this.userId,
    this.examId,
    this.questionId,
    this.userAnswer,
    this.isCorrect,
    this.pointsEarned,
    this.time,
    this.answeredAt,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? userId = mapData['userId'];
    final int? examId = mapData['examId'];
    final int? questionId = mapData['questionId'];
    final String? userAnswer = mapData['userAnswer'];
    final bool? isCorrect = mapData['isCorrect'];
    final int? pointsEarned = mapData['pointsEarned'];
    final int? time = mapData['time'];
    final DateTime? answeredAt = mapData['answeredAt'] != null
        ? DateTime.tryParse(mapData['answeredAt'].toString())
        : null;

    return UserAnswerModel(
      id: id,
      userId: userId,
      examId: examId,
      questionId: questionId,
      userAnswer: userAnswer,
      isCorrect: isCorrect,
      pointsEarned: pointsEarned,
      time: time,
      answeredAt: answeredAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'examId': examId,
    'questionId': questionId,
    'userAnswer': userAnswer,
    'isCorrect': isCorrect,
    'pointsEarned': pointsEarned,
    'time': time,
    'answeredAt': answeredAt?.toIso8601String(),
  };

  UserAnswerModel copyWith({
    int? id,
    int? userId,
    int? examId,
    int? questionId,
    String? userAnswer,
    bool? isCorrect,
    int? pointsEarned,
    int? time,
    DateTime? answeredAt,
  }) {
    return UserAnswerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      examId: examId ?? this.examId,
      questionId: questionId ?? this.questionId,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      time: time ?? this.time,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'UserAnswer: id:$id, userId: $userId, examId: $examId, questionId: $questionId, isCorrect: $isCorrect, pointsEarned: $pointsEarned, time: $time';
  }
}
