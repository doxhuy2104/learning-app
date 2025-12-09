import 'package:equatable/equatable.dart';

class UserAnswerModel extends Equatable {
  final int? id;
  final int? examId;
  final int? questionOrderIndex;
  final int? answerOrderIndex;
  final bool? isCorrect;
  final int? score;
  final int? time;
  final DateTime? answeredAt;
  final String? shortAnswer;
  const UserAnswerModel({
    this.id,
    this.examId,
    this.questionOrderIndex,
    this.answerOrderIndex,
    this.isCorrect,
    this.score,
    this.time,
    this.answeredAt,
    this.shortAnswer,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? userId = mapData['userId'];
    final int? examId = mapData['examId'];
    final int? questionOrderIndex = mapData['questionOrderIndex'];
    final int? answerOrderIndex = mapData['answerOrderIndex'];
    final bool? isCorrect = mapData['isCorrect'];
    final int? score = mapData['score'];
    final int? time = mapData['time'];
    final DateTime? answeredAt = mapData['answeredAt'] != null
        ? DateTime.tryParse(mapData['answeredAt'].toString())
        : null;
    final String? shortAnswer = mapData['shortAnswers'];

    return UserAnswerModel(
      id: id,
      examId: examId,
      questionOrderIndex: questionOrderIndex,
      answerOrderIndex: answerOrderIndex,
      isCorrect: isCorrect,
      score: score,
      time: time,
      answeredAt: answeredAt,
      shortAnswer: shortAnswer,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'examId': examId,
    'questionOrderIndex': questionOrderIndex,
    'answerOrderIndex': answerOrderIndex,
    'isCorrect': isCorrect,
    'score': score,
    'time': time,
    'answeredAt': answeredAt?.toIso8601String(),
    'shortAnswer': shortAnswer,
  };

  UserAnswerModel copyWith({
    int? id,
    int? examId,
    int? questionOrderIndex,
    int? answerOrderIndex,
    bool? isCorrect,
    int? score,
    int? time,
    DateTime? answeredAt,
    String? shortAnswer,
  }) {
    return UserAnswerModel(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      questionOrderIndex: questionOrderIndex ?? this.questionOrderIndex,
      answerOrderIndex: answerOrderIndex ?? this.answerOrderIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      score: score ?? this.score,
      time: time ?? this.time,
      answeredAt: answeredAt ?? this.answeredAt,
      shortAnswer: shortAnswer ?? this.shortAnswer,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'UserAnswer: id:$id, examId: $examId, questionOrderIndex: $questionOrderIndex, isCorrect: $isCorrect, score: $score, time: $time, shortAnswer: $shortAnswer';
  }
}
