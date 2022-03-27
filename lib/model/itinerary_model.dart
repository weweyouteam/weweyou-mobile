import 'event_model.dart';

class ItineraryModel {
  ItineraryModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Itinerary> data;

  ItineraryModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Itinerary.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Itinerary {
  Itinerary({
    required this.id,
    required this.userId,
    required this.isActive,
    required this.evants,
  });
  late final int id;
  late final int userId;
  late final int isActive;
  late final List<Event> evants;

  Itinerary.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    isActive = json['is_active'];
    evants = List.from(json['evants']).map((e)=>Event.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['is_active'] = isActive;
    _data['evants'] = evants.map((e)=>e.toJson()).toList();
    return _data;
  }
}
