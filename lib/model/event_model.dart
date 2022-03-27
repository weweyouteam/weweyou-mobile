class EventModel{
  String id,title,description,image,type,location,date,day,month,userId;
  String startDate,startTime,officalTicket;
  bool freeTicket,paidTicket,onlineTicket,offlineTicket,private,confidential,onlineEvent;
  String price;
  bool paused,popular,trending;
  String city,country;
  int tickets,dateTimeMilli;
  double latitude,longitude;
  String mainEventId;
  List participants;

  EventModel.fromMap(Map<String,dynamic> map)
      : id=map['id'],
        title = map['title'],
        participants = map['participants'],
        userId = map['userId'],
        latitude = map['latitude'],
        longitude = map['longitude'],
        paused = map['paused'],
        popular = map['popular'],
        trending = map['trending'],
        city = map['city'],
        country = map['country'],
        description = map['description']??"No Description",
        image = map['image'],
        dateTimeMilli = map['dateTimeMilli'],
        type = map['type'],
        location = map['location'],
        tickets = map['tickets'],
        startDate = map['startDate'],
        date = map['date'],
        day = map['day'],
        month = map['month'],
        startTime = map['startTime'],
        officalTicket = map['officalTicket'],
        freeTicket = map['freeTicket'],
        paidTicket = map['paidTicket'],
        onlineTicket = map['onlineTicket'],
        offlineTicket = map['offlineTicket'],
        private = map['private'],
        price = map['price'],
        confidential = map['confidential'],
        mainEventId = map['mainEventId'],
        onlineEvent = map['onlineEvent'];
}


class EventModelClass {
  EventModelClass({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Event> data;

  EventModelClass.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Event.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Event {
  Event({
    required this.id,
    required this.is_active,
    required this.title,
    this.description,
    required this.faq,
    this.thumbnail,
    this.poster,
    this.images,
    this.videoLink,
    this.venue,
    required this.address,
    this.city,
    this.state,
    this.zipcode,
    this.countryId,
    required this.startDate,
    this.endDate,
    required this.startTime,
    this.endTime,
    required this.repetitive,
    required this.featured,
    required this.status,
    required this.metaTitle,
    required this.metaKeywords,
    required this.metaDescription,
    required this.categoryId,
    required this.userId,
    required this.addToFacebook,
    required this.createdAt,
    required this.updatedAt,
    required this.slug,
    required this.priceType,
    this.latitude,
    this.longitude,
    required this.itemSku,
    required this.publish,
    this.isPublishable,
    required this.mergeSchedule,
    this.excerpt,
    required this.offlinePaymentInfo,
    this.privateListing,
    this.confidentialListing,
    this.online,
    required this.parentId,
  });
  late final int id;
  late final String title;
  late final String? description;
  late final String faq;
  late final int is_active;
  late final String? thumbnail;
  late final String? poster;
  late final String? images;
  late final String? videoLink;
  late final String? venue;
  late final String address;
  late final String? city;
  late final String? state;
  late final String? zipcode;
  late final int? countryId;
  late final String startDate;
  late final String? endDate;
  late final String startTime;
  late final String? endTime;
  late final int repetitive;
  late final int featured;
  late final int status;
  late final String metaTitle;
  late final String metaKeywords;
  late final String metaDescription;
  late final int categoryId;
  late final int userId;
  late final String addToFacebook;
  late final String createdAt;
  late final String updatedAt;
  late final String slug;
  late final int priceType;
  late final String? latitude;
  late final String? longitude;
  late final int itemSku;
  late final int publish;
  late final String? isPublishable;
  late final int mergeSchedule;
  late final String? excerpt;
  late final String offlinePaymentInfo;
  late final String? privateListing;
  late final String? confidentialListing;
  late final String? online;
  late final int parentId;

  Event.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title']??"no title";
    description = json['description']??"No description";
    faq = json['faq'];
    thumbnail = null;
    poster = null;
    images = json['images']??"";
    videoLink = null;
    venue = null;
    address = json['address']??"no address";
    city = null;
    state = null;
    zipcode = null;
    countryId = null;
    startDate = json['start_date'];
    endDate = null;
    startTime = json['start_time'];
    endTime = null;
    repetitive = json['repetitive'];
    is_active = json['is_active'];
    featured = json['featured'];
    status = json['status'];
    metaTitle = json['metaTitle'];
    metaKeywords = json['metaKeywords'];
    metaDescription = json['metaDescription'];
    categoryId = json['category_id'];
    userId = json['user_id'];
    addToFacebook = json['addToFacebook'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    slug = json['slug'];
    priceType = json['price_type'];
    latitude = json['latitude']??"0";
    longitude = json['longitude']??"0";
    itemSku = json['item_sku'];
    publish = json['publish'];
    isPublishable = null;
    mergeSchedule = json['merge_schedule'];
    excerpt = null;
    offlinePaymentInfo = json['offlinePaymentInfo'];
    privateListing = null;
    confidentialListing = null;
    online = null;
    parentId = json['parent_id']??-1;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['is_active'] = is_active;
    _data['description'] = description;
    _data['faq'] = faq;
    _data['thumbnail'] = thumbnail;
    _data['poster'] = poster;
    _data['images'] = images;
    _data['video_link'] = videoLink;
    _data['venue'] = venue;
    _data['address'] = address;
    _data['city'] = city;
    _data['state'] = state;
    _data['zipcode'] = zipcode;
    _data['country_id'] = countryId;
    _data['start_date'] = startDate;
    _data['end_date'] = endDate;
    _data['start_time'] = startTime;
    _data['end_time'] = endTime;
    _data['repetitive'] = repetitive;
    _data['featured'] = featured;
    _data['status'] = status;
    _data['meta_title'] = metaTitle;
    _data['meta_keywords'] = metaKeywords;
    _data['meta_description'] = metaDescription;
    _data['category_id'] = categoryId;
    _data['user_id'] = userId;
    _data['add_to_facebook'] = addToFacebook;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['slug'] = slug;
    _data['price_type'] = priceType;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['item_sku'] = itemSku;
    _data['publish'] = publish;
    _data['is_publishable'] = isPublishable;
    _data['merge_schedule'] = mergeSchedule;
    _data['excerpt'] = excerpt;
    _data['offline_payment_info'] = offlinePaymentInfo;
    _data['private_listing'] = privateListing;
    _data['confidential_listing'] = confidentialListing;
    _data['online'] = online;
    _data['parent_id'] = parentId;
    return _data;
  }
}
