class GroupModel {
  GroupModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Group> data;

  GroupModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Group.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Group {
  Group({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int userId;
  late final String name;
  late final String description;
  late final String image;
  late final String createdAt;
  late final String updatedAt;

  Group.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    description = json['description'];
    image = json['image']??"";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['name'] = name;
    _data['description'] = description;
    _data['image'] = image;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}