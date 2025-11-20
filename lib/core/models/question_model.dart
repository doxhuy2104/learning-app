import 'package:equatable/equatable.dart';

class QuestionModel extends Equatable {
  final String? questionId;
  final String? examId;
  final String? paragraphId;
  final String?
  type; // multiple_choice, true_false, short_answer, essay, fill_blank
  final String? content;
  final String? dataType;
  final Map<String, dynamic>? options;
  final String? explanation;
  final int? orderIndex;
  final DateTime? createdAt;

  const QuestionModel({
    this.questionId,
    this.examId,
    this.paragraphId,
    this.type,
    this.content,
    this.dataType,
    this.options,
    this.explanation,
    this.orderIndex,
    this.createdAt,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final String? questionId = mapData['questionId'];
    final String? examId = mapData['examId'];
    final String? paragraphId = mapData['paragraphId'];
    final String? type = mapData['type'];
    final String? content = mapData['content'];
    final String? dataType = mapData['dataType'];
    final Map<String, dynamic>? options = mapData['options'];
    final String? explanation = mapData['explanation'];
    final int? orderIndex = mapData['orderIndex'];
    final DateTime? createdAt = mapData['createdAt'] != null
        ? DateTime.tryParse(mapData['createdAt'].toString())
        : null;

    return QuestionModel(
      questionId: questionId,
      examId: examId,
      paragraphId: paragraphId,
      type: type,
      content: content,
      dataType: dataType,
      options: options,
      explanation: explanation,
      orderIndex: orderIndex,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'examId': examId,
    'paragraphId': paragraphId,
    'type': type,
    'content': content,
    'dataType': dataType,
    'options': options,
    'explanation': explanation,
    'orderIndex': orderIndex,
    'createdAt': createdAt?.toIso8601String(),
  };

  QuestionModel copyWith({
    String? questionId,
    String? examId,
    String? paragraphId,
    String? type,
    String? content,
    String? dataType,
    Map<String, dynamic>? options,
    String? explanation,
    int? orderIndex,
    DateTime? createdAt,
  }) {
    return QuestionModel(
      questionId: questionId ?? this.questionId,
      examId: examId ?? this.examId,
      paragraphId: paragraphId ?? this.paragraphId,
      type: type ?? this.type,
      content: content ?? this.content,
      dataType: dataType ?? this.dataType,
      options: options ?? this.options,
      explanation: explanation ?? this.explanation,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [questionId];

  @override
  String toString() {
    return 'Question: id:$questionId, examId: $examId, paragraphId: $paragraphId, type: $type, content: $content, dataType: $dataType, orderIndex: $orderIndex';
  }
}
