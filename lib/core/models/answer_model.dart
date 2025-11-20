import 'package:equatable/equatable.dart';

class AnswerModel extends Equatable {
  final String? answerId;
  final String? questionId;
  final int? orderIndex;
  final bool? isCorrect;

  const AnswerModel({
    this.answerId,
    this.questionId,
    this.orderIndex,
    this.isCorrect,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final String? answerId = mapData['answerId'];
    final String? questionId = mapData['questionId'];
    final int? orderIndex = mapData['orderIndex'];
    final bool? isCorrect = mapData['isCorrect'];

    return AnswerModel(
      answerId: answerId,
      questionId: questionId,
      orderIndex: orderIndex,
      isCorrect: isCorrect,
    );
  }

  Map<String, dynamic> toJson() => {
    'answerId': answerId,
    'questionId': questionId,
    'orderIndex': orderIndex,
    'isCorrect': isCorrect,
  };

  AnswerModel copyWith({
    String? answerId,
    String? questionId,
    int? orderIndex,
    bool? isCorrect,
  }) {
    return AnswerModel(
      answerId: answerId ?? this.answerId,
      questionId: questionId ?? this.questionId,
      orderIndex: orderIndex ?? this.orderIndex,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  List<Object?> get props => [answerId];

  @override
  String toString() {
    return 'Answer: id:$answerId, questionId: $questionId, orderIndex: $orderIndex, isCorrect: $isCorrect';
  }
}
