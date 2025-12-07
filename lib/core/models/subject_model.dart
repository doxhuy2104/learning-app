import 'package:equatable/equatable.dart';

class SubjectModel extends Equatable {
  final int? id;
  final String? title;
  final String? url;
  final String? image;
  const SubjectModel({this.id, this.title, this.url, this.image});

  static SubjectModel? fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final String? title = mapData['title'];
    final String? url = mapData['url'];
    final String? image = mapData['image'];

    return SubjectModel(id: id, title: title, url: url, image: image);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'url': url,
    'image': image,
  };

  SubjectModel copyWith({int? id, String? title, String? url, String? image}) {
    return SubjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [id, title, url, image];

  @override
  String toString() {
    return 'Subject: id:$id, title: $title, url: $url, image: $image';
  }
}
