import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/answer_model.dart';

class QuestionModel extends Equatable {
  final int? id;
  final int? examId;
  final int? paragraphId;
  final String?
  type; // multiple_choice, true_false, short_answer, essay, fill_blank
  final String? content;
  final String? dataType;
  final List<AnswerModel>? answers;
  final String? explanation;
  final int? orderIndex;
  final DateTime? createdAt;

  const QuestionModel({
    this.id,
    this.examId,
    this.paragraphId,
    this.type,
    this.content,
    this.dataType,
    this.answers,
    this.explanation,
    this.orderIndex,
    this.createdAt,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? examId = mapData['examId'];
    final int? paragraphId = mapData['paragraphId'];
    final String? type = mapData['type'];
    final String? content = mapData['content'];
    final String? dataType = mapData['dataType'];
    final List<AnswerModel>? answers = (mapData['answers'] as List<dynamic>?)
        ?.map(
          (e) => AnswerModel.fromJson(e as Map<String, dynamic>) as AnswerModel,
        )
        .toList();
    final String? explanation = mapData['explanation'];
    final int? orderIndex = mapData['orderIndex'];
    final DateTime? createdAt = mapData['createdAt'] != null
        ? DateTime.tryParse(mapData['createdAt'].toString())
        : null;

    return QuestionModel(
      id: id,
      examId: examId,
      paragraphId: paragraphId,
      type: type,
      content: content,
      dataType: dataType,
      answers: answers,
      explanation: explanation,
      orderIndex: orderIndex,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'examId': examId,
    'paragraphId': paragraphId,
    'type': type,
    'content': content,
    'dataType': dataType,
    'answers': answers?.map((e) => e.toJson()).toList(),
    'explanation': explanation,
    'orderIndex': orderIndex,
    'createdAt': createdAt?.toIso8601String(),
  };

  QuestionModel copyWith({
    int? id,
    int? examId,
    int? paragraphId,
    String? type,
    String? content,
    String? dataType,
    List<AnswerModel>? answers,
    String? explanation,
    int? orderIndex,
    DateTime? createdAt,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      paragraphId: paragraphId ?? this.paragraphId,
      type: type ?? this.type,
      content: content ?? this.content,
      dataType: dataType ?? this.dataType,
      answers: answers ?? this.answers,
      explanation: explanation ?? this.explanation,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Question: id:$id, examId: $examId, paragraphId: $paragraphId, type: $type, content: $content, dataType: $dataType, orderIndex: $orderIndex, answers: ${answers?.length ?? 0}';
  }
}
