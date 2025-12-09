import 'package:equatable/equatable.dart';

class ExamModel extends Equatable {
  final int? id;
  final int? lessonId;
  final int? courseId;
  final String? title;
  final String? url;
  final int? orderIndex;
  final int? duration;

  const ExamModel({
    this.id,
    this.lessonId,
    this.courseId,
    this.title,
    this.url,
    this.orderIndex,
    this.duration,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? lessonId = mapData['lessonId'];
    final int? courseId = mapData['courseId'];
    final String? title = mapData['title'];
    final String? url = mapData['url'];
    final int? orderIndex = mapData['orderIndex'];
    final int? duration = mapData['duration'];

    return ExamModel(
      id: id,
      lessonId: lessonId,
      courseId: courseId,
      title: title,
      url: url,
      orderIndex: orderIndex,
      duration: duration,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lessonId': lessonId,
    'courseId': courseId,
    'title': title,
    'url': url,
    'orderIndex': orderIndex,
    'duration': duration,
  };

  ExamModel copyWith({
    int? id,
    int? lessonId,
    int? courseId,
    String? title,
    String? url,
    int? orderIndex,
    int? duration,
  }) {
    return ExamModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      url: url ?? this.url,
      orderIndex: orderIndex ?? this.orderIndex,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Exam: id:$id, lessonId: $lessonId, courseId: $courseId, title: $title, url: $url, orderIndex: $orderIndex, duration: $duration';
  }
}
