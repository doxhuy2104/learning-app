import 'package:equatable/equatable.dart';

class AnswerModel extends Equatable {
  final int? id;
  final int? questionId;
  final int? orderIndex;
  final bool? isCorrect;
  final String? content;
    final String? dataType;

  const AnswerModel({
    this.id,
    this.questionId,
    this.orderIndex,
    this.isCorrect,
    this.content,
    this.dataType
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? questionId = mapData['questionId'];
    final int? orderIndex = mapData['orderIndex'];
    final bool? isCorrect = mapData['isCorrect'];
    final String? content = mapData['content'];
    final String? dataType = mapData['dataType'];

    return AnswerModel(
      id: id,
      questionId: questionId,
      orderIndex: orderIndex,
      isCorrect: isCorrect,
      content:content,
      dataType:dataType
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'questionId': questionId,
    'orderIndex': orderIndex,
    'isCorrect': isCorrect,
    'content':content,
    'dataType':dataType
  };

  AnswerModel copyWith({
    int? id,
    int? questionId,
    int? orderIndex,
    bool? isCorrect,
    String? content,
    String? dataType
  }) {
    return AnswerModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      orderIndex: orderIndex ?? this.orderIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      content:content ?? this.content,
      dataType:dataType ?? this.dataType
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Answer: id:$id, questionId: $questionId, orderIndex: $orderIndex, isCorrect: $isCorrect, content: $content';
  }
}
