import 'package:equatable/equatable.dart';

class ParagraphModel extends Equatable {
  final String? paragraphId;
  final String? examId;
  final String? title;
  final String? content;
  final String? url;
  final int? orderIndex;

  const ParagraphModel({
    this.paragraphId,
    this.examId,
    this.title,
    this.content,
    this.url,
    this.orderIndex,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final String? paragraphId = mapData['paragraphId'];
    final String? examId = mapData['examId'];
    final String? title = mapData['title'];
    final String? content = mapData['content'];
    final String? url = mapData['url'];
    final int? orderIndex = mapData['orderIndex'];

    return ParagraphModel(
      paragraphId: paragraphId,
      examId: examId,
      title: title,
      content: content,
      url: url,
      orderIndex: orderIndex,
    );
  }

  Map<String, dynamic> toJson() => {
    'paragraphId': paragraphId,
    'examId': examId,
    'title': title,
    'content': content,
    'url': url,
    'orderIndex': orderIndex,
  };

  ParagraphModel copyWith({
    String? paragraphId,
    String? examId,
    String? title,
    String? content,
    String? url,
    int? orderIndex,
  }) {
    return ParagraphModel(
      paragraphId: paragraphId ?? this.paragraphId,
      examId: examId ?? this.examId,
      title: title ?? this.title,
      content: content ?? this.content,
      url: url ?? this.url,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  List<Object?> get props => [paragraphId];

  @override
  String toString() {
    return 'Paragraph: id:$paragraphId, examId: $examId, title: $title, content: $content, url: $url, orderIndex: $orderIndex';
  }
}
