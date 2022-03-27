

class TicketModel {
  late final String title,description,price ;
  late final int online,quantity,offline,free,paid;


  TicketModel(this.title, this.quantity, this.description,
      this.online, this.offline, this.free, this.paid,this.price);

  TicketModel.fromJson(Map<String, dynamic> json){
    title = json['title'];
    quantity = json['quantity'];
    description = json['description'];
    //price = json['price'];
    online = json['online'];
    offline = json['offline'];
    free = json['free'];
    price = json['price'];
    paid = json['paid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['paid'] = paid;
    _data['free'] = free;
    _data['price'] = price;
    _data['offline'] = offline;
    _data['online'] = online;
   // _data['price'] = price;
    _data['description'] = description;
    _data['quantity'] = quantity;
    _data['title'] = title;
    return _data;
  }


}

class EventTicketModel {
  EventTicketModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<Tickets> data;

  EventTicketModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Tickets.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Tickets {
  Tickets({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    this.description,
    required this.eventId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.customerLimit,
    required this.online,
    required this.offline,
    required this.free,
    required this.paid,
  });
  late final int id;
  late final String title;
  late final String price;
  late final int quantity;
  late final String? description;
  late final int eventId;
  late final String createdAt;
  late final String updatedAt;
  late final int status;
  late final int customerLimit;
  late final int online;
  late final int offline;
  late final int free;
  late final int paid;

  Tickets.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    price = json['price'];
    quantity = json['quantity'];
    description = null;
    eventId = json['event_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    customerLimit = json['customerLimit']??0;
    online = json['online']??0;
    offline = json['offline']??0;
    free = json['free']??0;
    paid = json['paid']??0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['price'] = price;
    _data['quantity'] = quantity;
    _data['description'] = description;
    _data['event_id'] = eventId;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['status'] = status;
    _data['customer_limit'] = customerLimit;
    _data['online'] = online;
    _data['offline'] = offline;
    _data['free'] = free;
    _data['paid'] = paid;
    return _data;
  }
}

