import 'package:equatable/equatable.dart';

class AnswerModel extends Equatable {
  final int? id;
  final int? questionId;
  final int? orderIndex;
  final bool? isCorrect;
  final String? content;

  const AnswerModel({
    this.id,
    this.questionId,
    this.orderIndex,
    this.isCorrect,
    this.content
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? questionId = mapData['questionId'];
    final int? orderIndex = mapData['orderIndex'];
    final bool? isCorrect = mapData['isCorrect'];
    final String? content = mapData['content'];

    return AnswerModel(
      id: id,
      questionId: questionId,
      orderIndex: orderIndex,
      isCorrect: isCorrect,
      content:content
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'questionId': questionId,
    'orderIndex': orderIndex,
    'isCorrect': isCorrect,
    'content':content
  };

  AnswerModel copyWith({
    int? id,
    int? questionId,
    int? orderIndex,
    bool? isCorrect,
    String? content
  }) {
    return AnswerModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      orderIndex: orderIndex ?? this.orderIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      content:content ?? this.content
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Answer: id:$id, questionId: $questionId, orderIndex: $orderIndex, isCorrect: $isCorrect, content: $content';
  }
}
