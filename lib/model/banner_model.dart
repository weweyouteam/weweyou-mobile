class BannerModel {
  BannerModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Banners> data;

  BannerModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Banners.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Banners {
  Banners({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.imagepath,
    required this.link,
  });
  late final int id;
  late final String title;
  late final String subtitle;
  late final String image;
  late final String imagepath;
  late final String link;

  Banners.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    image = json['image'];
    imagepath = json['imagepath'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['subtitle'] = subtitle;
    _data['image'] = image;
    _data['imagepath'] = imagepath;
    _data['link'] = link;
    return _data;
  }
}