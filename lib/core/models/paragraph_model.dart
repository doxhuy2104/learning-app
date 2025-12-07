import 'package:equatable/equatable.dart';

class ParagraphModel extends Equatable {
  final int? id;
  final int? examId;
  final String? title;
  final String? content;
  final String? url;
  final int? orderIndex;

  const ParagraphModel({
    this.id,
    this.examId,
    this.title,
    this.content,
    this.url,
    this.orderIndex,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? examId = mapData['examId'];
    final String? title = mapData['title'];
    final String? content = mapData['content'];
    final String? url = mapData['url'];
    final int? orderIndex = mapData['orderIndex'];

    return ParagraphModel(
      id: id,
      examId: examId,
      title: title,
      content: content,
      url: url,
      orderIndex: orderIndex,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'examId': examId,
    'title': title,
    'content': content,
    'url': url,
    'orderIndex': orderIndex,
  };

  ParagraphModel copyWith({
    int? id,
    int? examId,
    String? title,
    String? content,
    String? url,
    int? orderIndex,
  }) {
    return ParagraphModel(
      id: id ?? this.id,
      examId: examId ?? this.examId,
      title: title ?? this.title,
      content: content ?? this.content,
      url: url ?? this.url,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Paragraph: id:$id, examId: $examId, title: $title, content: $content, url: $url, orderIndex: $orderIndex';
  }
}
