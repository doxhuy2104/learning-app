import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final String? courseId;
  final String? title;
  final String? description;
  final String? url;
  final bool? isExam;

  const CourseModel({
    this.courseId,
    this.title,
    this.description,
    this.url,
    this.isExam,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final String? courseId = mapData['courseId'];
    final String? title = mapData['title'];
    final String? description = mapData['description'];
    final String? url = mapData['url'];
    final bool? isExam = mapData['isExam'];

    return CourseModel(
      courseId: courseId,
      title: title,
      description: description,
      url: url,
      isExam: isExam,
    );
  }

  Map<String, dynamic> toJson() => {
    'courseId': courseId,
    'title': title,
    'description': description,
    'url': url,
    'isExam': isExam,
  };

  CourseModel copyWith({
    String? courseId,
    String? title,
    String? description,
    String? url,
    bool? isExam,
  }) {
    return CourseModel(
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      isExam: isExam ?? this.isExam,
    );
  }

  @override
  List<Object?> get props => [courseId];

  @override
  String toString() {
    return 'Course: id:$courseId, title: $title, description: $description, url: $url, isExam: $isExam';
  }
}
