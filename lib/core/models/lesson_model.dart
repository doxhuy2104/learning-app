import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/exam_model.dart';

class LessonModel extends Equatable {
  final int? id;
  final int? courseId;
  final String? title;
  final String? url;
  final int? orderIndex;
  final List<ExamModel>? exams;

  const LessonModel({
    this.id,
    this.courseId,
    this.title,
    this.url,
    this.orderIndex,
    this.exams,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final int? courseId = mapData['courseId'];
    final String? title = mapData['title'];
    final String? url = mapData['url'];
    final int? orderIndex = mapData['orderIndex'];
    final List<ExamModel>? exams = (mapData['exams'] as List<dynamic>?)
        ?.map((e) => ExamModel.fromJson(e as Map<String, dynamic>) as ExamModel)
        .toList();
    return LessonModel(
      id: id,
      courseId: courseId,
      title: title,
      url: url,
      orderIndex: orderIndex,
      exams: exams,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'title': title,
    'url': url,
    'orderIndex': orderIndex,
    'exams': exams?.map((e) => e.toJson()).toList(),
  };

  LessonModel copyWith({
    int? id,
    int? courseId,
    String? title,
    String? url,
    int? orderIndex,
    List<ExamModel>? exams,
  }) {
    return LessonModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      url: url ?? this.url,
      orderIndex: orderIndex ?? this.orderIndex,
      exams: exams ?? this.exams,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Lesson: id:$id, courseId: $courseId, title: $title, url: $url, orderIndex: $orderIndex, exams: $exams';
  }
}
