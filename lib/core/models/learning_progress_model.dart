import 'package:equatable/equatable.dart';

class LearningProgressModel extends Equatable {
  final String? progressId;
  final String? userId;
  final String? lessonId;
  final String? status; // not_started, in_progress, completed, skipped
  final DateTime? startTime;
  final DateTime? completionTime;
  final int? timeSpentMinutes;
  final double? completionPercentage;

  const LearningProgressModel({
    this.progressId,
    this.userId,
    this.lessonId,
    this.status,
    this.startTime,
    this.completionTime,
    this.timeSpentMinutes,
    this.completionPercentage,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final String? progressId = mapData['progressId'];
    final String? userId = mapData['userId'];
    final String? lessonId = mapData['lessonId'];
    final String? status = mapData['status'];
    final DateTime? startTime = mapData['startTime'] != null
        ? DateTime.tryParse(mapData['startTime'].toString())
        : null;
    final DateTime? completionTime = mapData['completionTime'] != null
        ? DateTime.tryParse(mapData['completionTime'].toString())
        : null;
    final int? timeSpentMinutes = mapData['timeSpentMinutes'];
    final double? completionPercentage = mapData['completionPercentage'] != null
        ? (mapData['completionPercentage'] as num).toDouble()
        : null;

    return LearningProgressModel(
      progressId: progressId,
      userId: userId,
      lessonId: lessonId,
      status: status,
      startTime: startTime,
      completionTime: completionTime,
      timeSpentMinutes: timeSpentMinutes,
      completionPercentage: completionPercentage,
    );
  }

  Map<String, dynamic> toJson() => {
    'progressId': progressId,
    'userId': userId,
    'lessonId': lessonId,
    'status': status,
    'startTime': startTime?.toIso8601String(),
    'completionTime': completionTime?.toIso8601String(),
    'timeSpentMinutes': timeSpentMinutes,
    'completionPercentage': completionPercentage,
  };

  LearningProgressModel copyWith({
    String? progressId,
    String? userId,
    String? lessonId,
    String? status,
    DateTime? startTime,
    DateTime? completionTime,
    int? timeSpentMinutes,
    double? completionPercentage,
  }) {
    return LearningProgressModel(
      progressId: progressId ?? this.progressId,
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      completionTime: completionTime ?? this.completionTime,
      timeSpentMinutes: timeSpentMinutes ?? this.timeSpentMinutes,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }

  @override
  List<Object?> get props => [progressId];

  @override
  String toString() {
    return 'LearningProgress: id:$progressId, userId: $userId, lessonId: $lessonId, status: $status, timeSpentMinutes: $timeSpentMinutes, completionPercentage: $completionPercentage';
  }
}
