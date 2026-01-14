import 'package:equatable/equatable.dart';

class UserAnswerModel extends Equatable {
  final int? id;
  final int? historyId;
  final int? questionOrderIndex;
  final int? answerOrderIndex;
  final bool? isCorrect;
  final int? score;
  final int? time;
  final String? shortAnswer;
  final String? trueFalseAnswer;
  const UserAnswerModel({
    this.id,
    this.historyId,
    this.questionOrderIndex,
    this.answerOrderIndex,
    this.isCorrect,
    this.score,
    this.time,
    this.shortAnswer,
    this.trueFalseAnswer,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? historyId = mapData['historyId'];
    final int? questionOrderIndex = mapData['questionOrderIndex'];
    final int? answerOrderIndex = mapData['answerOrderIndex'];
    final bool? isCorrect = mapData['isCorrect'];
    final dynamic rawScore = mapData['score'];
    final int? score = rawScore is num
        ? rawScore.toInt()
        : int.tryParse(rawScore?.toString() ?? '');
    final int? time = mapData['time'];
    final String? shortAnswer = mapData['shortAnswers'];
    final String? trueFalseAnswer = mapData['trueFalseAnswer'];

    return UserAnswerModel(
      id: id,
      historyId: historyId,
      questionOrderIndex: questionOrderIndex,
      answerOrderIndex: answerOrderIndex,
      isCorrect: isCorrect,
      score: score,
      time: time,
      shortAnswer: shortAnswer,
      trueFalseAnswer: trueFalseAnswer,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'historyId': historyId,
    'questionOrderIndex': questionOrderIndex,
    'answerOrderIndex': answerOrderIndex,
    'isCorrect': isCorrect,
    'score': score,
    'time': time,
    'shortAnswer': shortAnswer,
    'trueFalseAnswer': trueFalseAnswer,
  };

  UserAnswerModel copyWith({
    int? id,
    int? historyId,
    int? questionOrderIndex,
    int? answerOrderIndex,
    bool? isCorrect,
    int? score,
    int? time,
    String? shortAnswer,
    String? trueFalseAnswer,
  }) {
    return UserAnswerModel(
      id: id ?? this.id,
      historyId: historyId ?? this.historyId,
      questionOrderIndex: questionOrderIndex ?? this.questionOrderIndex,
      answerOrderIndex: answerOrderIndex ?? this.answerOrderIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      score: score ?? this.score,
      time: time ?? this.time,
      shortAnswer: shortAnswer ?? this.shortAnswer,
      trueFalseAnswer: trueFalseAnswer ?? this.trueFalseAnswer,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'UserAnswer: id:$id, historyId: $historyId, questionOrderIndex: $questionOrderIndex, isCorrect: $isCorrect, score: $score, time: $time, shortAnswer: $shortAnswer, trueFalseAnswer: $trueFalseAnswer';
  }
}
