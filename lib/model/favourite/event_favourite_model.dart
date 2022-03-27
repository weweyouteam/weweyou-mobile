import '../event_model.dart';

class EventFavoriteModel {
  EventFavoriteModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Data> data;

  EventFavoriteModel.fromJson(Map<String, dynamic> json){
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
    required this.id,
    required this.eventId,
    required this.event,
  });
  late final int id;
  late final int eventId;
  late final Event event;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    eventId = json['event_id'];
    event = Event.fromJson(json['event']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['event_id'] = eventId;
    _data['event'] = event.toJson();
    return _data;
  }
}
