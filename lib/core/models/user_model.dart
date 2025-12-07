import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/group_model.dart';

class UserModel extends Equatable {
  final int? userId;
  final String? avatar;
  final String? fullName;
  final String? accessToken;
  final String? email;
  final String? loginType;
  final GroupModel? group;

  const UserModel({
    this.userId,
    this.avatar,
    this.fullName,
    this.accessToken,
    this.email,
    this.loginType,
    this.group,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? userId = mapData['userId'];
    final String? avatar = mapData['avatar'];
    final String? fullName = mapData['fullName'];
    final String? accessToken = mapData['accessToken'];
    final String? email = mapData['email'];
    final String? loginType = mapData['loginType'];
    final GroupModel? group = GroupModel.fromJson(
      mapData['group'] as Map<String, dynamic>?,
    );

    return UserModel(
      userId: userId,
      avatar: avatar,
      fullName: fullName,
      accessToken: accessToken,
      email: email,
      loginType: loginType,
      group: group,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'avatar': avatar,
    'fullName': fullName,
    'accessToken': accessToken,
    'email': email,
    'loginType': loginType,
    'group': group?.toJson(),
  };

  UserModel copyWith({
    int? userId,
    String? avatar,
    String? fullName,
    String? accessToken,
    String? email,
    String? loginType,
    GroupModel? group,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      avatar: avatar ?? this.avatar,
      fullName: fullName ?? this.fullName,
      accessToken: accessToken ?? this.accessToken,
      email: email ?? this.email,
      loginType: loginType ?? this.loginType,
      group: group ?? this.group,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    avatar,
    fullName,
    accessToken,
    email,
    loginType,
    group,
  ];

  @override
  String toString() {
    return 'User: id:$userId, avatar: $avatar, fullName: $fullName, accessToken: $accessToken, email: $email, loginType:$loginType, group:$group';
  }
}
