// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeadRequestBackEntity _$HeadRequestBackEntityFromJson(
    Map<String, dynamic> json) {
  return HeadRequestBackEntity(
      msgFlag: json['msgFlag'] as int,
      userNotificationList: (json['userNotificationList'] as List)
          .map(
              (e) => UserNotificationEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      chatContentListAll: (json['chatContentListAll'] as List)
          .map((e) => ChatContentEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      userAllFriendList: (json['userAllFriendList'] as List)
          .map((e) => UserEntity.fromJson(e as Map<String, dynamic>))
          .toList());
}

Map<String, dynamic> _$HeadRequestBackEntityToJson(
        HeadRequestBackEntity instance) =>
    <String, dynamic>{
      'msgFlag': instance.msgFlag,
      'userNotificationList': instance.userNotificationList,
      'userAllFriendList': instance.userAllFriendList,
      'chatContentListAll': instance.chatContentListAll
    };

UserNotificationEntity _$UserNotificationEntityFromJson(
    Map<String, dynamic> json) {
  return UserNotificationEntity(
      ntid: json['ntid'] as String,
      flag_read: json['flag_read'] as int,
      level: json['level'] as int,
      uid_from: json['uid_from'] as int,
      uid_to: json['uid_to'] as int,
      time: json['time'] as String);
}

Map<String, dynamic> _$UserNotificationEntityToJson(
        UserNotificationEntity instance) =>
    <String, dynamic>{
      'ntid': instance.ntid,
      'flag_read': instance.flag_read,
      'level': instance.level,
      'uid_from': instance.uid_from,
      'uid_to': instance.uid_to,
      'time': instance.time
    };

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return UserEntity(
      avatar_img: json['avatar_img'] as String,
      uid: json['uid'] as int,
      born_day: json['born_day'] as int,
      born_month: json['born_month'] as int,
      born_year: json['born_year'] as int,
      sex: json['sex'] as int,
      mail: json['mail'] as String,
      address: json['address'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      school: json['school'] as String,
      flag_online: json['flag_online'] as int,
      friend: json['friend'] as int);
}

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'sex': instance.sex,
      'avatar_img': instance.avatar_img,
      'school': instance.school,
      'born_year': instance.born_year,
      'born_month': instance.born_month,
      'born_day': instance.born_day,
      'phone': instance.phone,
      'address': instance.address,
      'mail': instance.mail,
      'flag_online': instance.flag_online,
      'friend': instance.friend
    };

ChatContentEntity _$ChatContentEntityFromJson(Map<String, dynamic> json) {
  return ChatContentEntity(
      chatContentList: (json['chatContentList'] as List)
          .map((e) => ChatContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      friendId: json['friendId'] as int);
}

Map<String, dynamic> _$ChatContentEntityToJson(ChatContentEntity instance) =>
    <String, dynamic>{
      'chatContentList': instance.chatContentList,
      'friendId': instance.friendId
    };

ChatContent _$ChatContentFromJson(Map<String, dynamic> json) {
  return ChatContent(
      sender: json['sender'] as int,
      time: json['time'] as String,
      content: json['content'] as String);
}

Map<String, dynamic> _$ChatContentToJson(ChatContent instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'time': instance.time,
      'content': instance.content
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
      name: json['name'] as String,
      avatar_img: json['avatar_img'] as String,
      address: json['address'] as String,
      sex: json['sex'] as int,
      school: json['school'] as String,
      born_day: json['born_day'] as int,
      born_year: json['born_year'] as int,
      born_month: json['born_month'] as int,
      mail: json['mail'] as String,
      phone: json['phone'] as String,
      uid: json['uid'] as int);
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'name': instance.name,
      'avatar_img': instance.avatar_img,
      'address': instance.address,
      'sex': instance.sex,
      'school': instance.school,
      'born_day': instance.born_day,
      'born_month': instance.born_month,
      'born_year': instance.born_year,
      'mail': instance.mail,
      'phone': instance.phone,
      'uid': instance.uid
    };
