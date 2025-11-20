import 'package:equatable/equatable.dart';

class LessonModel extends Equatable {
  final String? lessonId;
  final String? courseId;
  final String? title;
  final String? url;
  final int? orderIndex;

  const LessonModel({
    this.lessonId,
    this.courseId,
    this.title,
    this.url,
    this.orderIndex,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final String? lessonId = mapData['lessonId'];
    final String? courseId = mapData['courseId'];
    final String? title = mapData['title'];
    final String? url = mapData['url'];
    final int? orderIndex = mapData['orderIndex'];

    return LessonModel(
      lessonId: lessonId,
      courseId: courseId,
      title: title,
      url: url,
      orderIndex: orderIndex,
    );
  }

  Map<String, dynamic> toJson() => {
    'lessonId': lessonId,
    'courseId': courseId,
    'title': title,
    'url': url,
    'orderIndex': orderIndex,
  };

  LessonModel copyWith({
    String? lessonId,
    String? courseId,
    String? title,
    String? url,
    int? orderIndex,
  }) {
    return LessonModel(
      lessonId: lessonId ?? this.lessonId,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      url: url ?? this.url,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  List<Object?> get props => [lessonId];

  @override
  String toString() {
    return 'Lesson: id:$lessonId, courseId: $courseId, title: $title, url: $url, orderIndex: $orderIndex';
  }
}
