import '../event_model.dart';

class ItineraryFavouriteModel {
  ItineraryFavouriteModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Data> data;

  ItineraryFavouriteModel.fromJson(Map<String, dynamic> json){
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
    required this.itineraryId,
    required this.eventId,
    required this.event,
  });
  late final int itineraryId;
  late final int eventId;
  late final List<Event> event;

  Data.fromJson(Map<String, dynamic> json){
    itineraryId = json['itinerary_id'];
    eventId = json['event_id'];
    event = List.from(json['event']).map((e)=>Event.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['itinerary_id'] = itineraryId;
    _data['event_id'] = eventId;
    _data['event'] = event.map((e)=>e.toJson()).toList();
    return _data;
  }
}
