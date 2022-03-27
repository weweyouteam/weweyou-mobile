class GroupMemberModel {
  GroupMemberModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Data> data;

  GroupMemberModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.groupId,
    required this.memberId,
    required this.member,
    required this.group,
  });
  late final int groupId;
  late final int memberId;
  late final Member member;
  late final GroupDetail group;

  Data.fromJson(Map<String, dynamic> json){
    groupId = json['group_id'];
    memberId = json['member_id'];
    member = Member.fromJson(json['member']);
    group = GroupDetail.fromJson(json['group']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['group_id'] = groupId;
    _data['member_id'] = memberId;
    _data['member'] = member.toJson();
    _data['group'] = group.toJson();
    return _data;
  }
}

class Member {
  Member({
    required this.id,
    required this.name,
    required this.email,
    this.city,
    required this.address,
    this.latitude,
    this.longitude,
  });
  late final int id;
  late final String name;
  late final String email;
  late final String? city;
  late final String address;
  late final String? latitude;
  late final String? longitude;

  Member.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    city = null;
    address = json['address'];
    latitude = null;
    longitude = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['city'] = city;
    _data['address'] = address;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}

class GroupDetail {
  GroupDetail({
    required this.id,
    required this.name,
    required this.description,
    this.image,
  });
  late final int id;
  late final String name;
  late final String description;
  late final Null image;

  GroupDetail.fromJson(Map<String, dynamic> json){
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