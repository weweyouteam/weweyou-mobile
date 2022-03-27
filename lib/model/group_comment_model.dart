class GroupCommentModel {
  GroupCommentModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<GroupComment> data;

  GroupCommentModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>GroupComment.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class GroupComment {
  GroupComment({
    required this.groupId,
    required this.comment,
    required this.group,
  });
  late final int groupId;
  late final String comment;
  late final GroupData group;

  GroupComment.fromJson(Map<String, dynamic> json){
    groupId = json['group_id'];
    comment = json['comment'];
    group = GroupData.fromJson(json['group']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['group_id'] = groupId;
    _data['comment'] = comment;
    _data['group'] = group.toJson();
    return _data;
  }
}

class GroupData {
  GroupData({
    required this.id,
    required this.name,
    required this.description,
    this.image,
  });
  late final int id;
  late final String name;
  late final String description;
  late final Null image;

  GroupData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['image'] = image;
    return _data;
  }
}