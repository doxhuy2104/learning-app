import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/lesson_model.dart';

class CourseModel extends Equatable {
  final int? id;
  final String? title;
  final String? url;
  final bool? isExam;
  final List<LessonModel>? lessons;
  const CourseModel({
    this.id,
    this.title,
    this.url,
    this.isExam,
    this.lessons,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final String? title = mapData['title'];
    final String? url = mapData['url'];
    final bool? isExam = mapData['isExam'];
    final List<LessonModel>? lessons = (mapData['lessons'] as List<dynamic>?)
        ?.map(
          (e) => LessonModel.fromJson(e as Map<String, dynamic>) as LessonModel,
        )
        .toList();

    return CourseModel(
      id: id,
      title: title,
      url: url,
      isExam: isExam,
      lessons: lessons,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'url': url,
    'isExam': isExam,
    'lessons': lessons?.map((e) => e.toJson()).toList(),
  };

  CourseModel copyWith({
    int? id,
    String? title,
    String? url,
    bool? isExam,
    List<LessonModel>? lessons,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      isExam: isExam ?? this.isExam,
      lessons: lessons ?? this.lessons,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'Course: id:$id, title: $title, url: $url, isExam: $isExam, lessons: ${lessons?.length ?? 0}';
  }
}
