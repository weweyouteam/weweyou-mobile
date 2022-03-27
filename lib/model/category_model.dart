class CategoryModel {
  CategoryModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Category> data;

  CategoryModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Category.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.thumb,
    required this.image,
    required this.template,
  });
  late final int id;
  late final String name;
  late final String slug;
  late final String createdAt;
  late final String updatedAt;
  late final int status;
  late final String thumb;
  late final String image;
  late final int template;

  Category.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name']??"";
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    thumb = json['thumb'];
    image = json['image']??"";
    template = json['template'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['slug'] = slug;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['status'] = status;
    _data['thumb'] = thumb;
    _data['image'] = image;
    _data['template'] = template;
    return _data;
  }
}