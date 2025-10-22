import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? userId;
  final String? avatar;
  final String? username;
  final String? accessToken;

  const UserModel({this.userId, this.avatar, this.username, this.accessToken});

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? userId = mapData['userId'];
    final String? avatar = mapData['avatar'];
    final String? username = mapData['username'];
    final String? accessToken = mapData['accessToken'];

    return UserModel(
      userId: userId,
      avatar: avatar,
      username: username,
      accessToken: accessToken,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'avatar': avatar,
    'username': username,
    'accessToken': accessToken,
  };

  UserModel copyWith({
    int? userId,
    String? avatar,
    String? username,
    String? accessToken,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  List<Object?> get props => [userId];

  @override
  String toString() {
    return 'User: id:$userId, avatar: $avatar, username: $username, accessToken: $accessToken';
  }
}
