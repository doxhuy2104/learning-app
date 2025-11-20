import 'package:equatable/equatable.dart';

class UserAnswerModel extends Equatable {
  final String? userAnswerId;
  final String? userId;
  final String? examId;
  final String? questionId;
  final String? userAnswer;
  final bool? isCorrect;
  final int? pointsEarned;
  final int? time;
  final DateTime? answeredAt;

  const UserAnswerModel({
    this.userAnswerId,
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

    final String? userAnswerId = mapData['userAnswerId'];
    final String? userId = mapData['userId'];
    final String? examId = mapData['examId'];
    final String? questionId = mapData['questionId'];
    final String? userAnswer = mapData['userAnswer'];
    final bool? isCorrect = mapData['isCorrect'];
    final int? pointsEarned = mapData['pointsEarned'];
    final int? time = mapData['time'];
    final DateTime? answeredAt = mapData['answeredAt'] != null
        ? DateTime.tryParse(mapData['answeredAt'].toString())
        : null;

    return UserAnswerModel(
      userAnswerId: userAnswerId,
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
    'userAnswerId': userAnswerId,
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
    String? userAnswerId,
    String? userId,
    String? examId,
    String? questionId,
    String? userAnswer,
    bool? isCorrect,
    int? pointsEarned,
    int? time,
    DateTime? answeredAt,
  }) {
    return UserAnswerModel(
      userAnswerId: userAnswerId ?? this.userAnswerId,
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
  List<Object?> get props => [userAnswerId];

  @override
  String toString() {
    return 'UserAnswer: id:$userAnswerId, userId: $userId, examId: $examId, questionId: $questionId, isCorrect: $isCorrect, pointsEarned: $pointsEarned, time: $time';
  }
}
