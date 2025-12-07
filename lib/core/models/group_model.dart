import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/subject_model.dart';

class GroupModel extends Equatable {
  final int? id;
  final String? name;
  final List<SubjectModel>? subjects;

  const GroupModel({this.id, this.name, this.subjects});

  static GroupModel? fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final String? name = mapData['name'];
    final List<SubjectModel>? subjects = (mapData['subjects'] as List<dynamic>?)
        ?.map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
        .whereType<SubjectModel>()
        .toList();

    return GroupModel(id: id, name: name, subjects: subjects);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'subjects': subjects?.map((e) => e.toJson()).toList(),
  };

  GroupModel copyWith({int? id, String? name, List<SubjectModel>? subjects}) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subjects: subjects ?? this.subjects,
    );
  }

  @override
  List<Object?> get props => [id, name, subjects];

  @override
  String toString() {
    return 'Group: id:$id, name:$name, subjects:$subjects';
  }
}
