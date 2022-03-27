class MyTicketModel {
  MyTicketModel({
    required this.code,
    required this.message,
    required this.data,
  });
  late final String code;
  late final String message;
  late final List<TicketData> data;

  MyTicketModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>TicketData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class TicketData {
  TicketData({
    required this.id,
    required this.eventId,
    required this.ticketId,
    required this.quantity,
    required this.ticket,
  });
  late final int id;
  late final int eventId;
  late final int ticketId;
  late final int quantity;
  late final MyTicket ticket;

  TicketData.fromJson(Map<String, dynamic> json){
    id = json['id'];
    eventId = json['event_id'];
    ticketId = json['ticket_id'];
    quantity = json['quantity'];
    ticket = MyTicket.fromJson(json['ticket']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['event_id'] = eventId;
    _data['ticket_id'] = ticketId;
    _data['quantity'] = quantity;
    _data['ticket'] = ticket.toJson();
    return _data;
  }
}

class MyTicket {
  MyTicket({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
  });
  late final int id;
  late final String title;
  late final String price;
  late final String description;

  MyTicket.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['price'] = price;
    _data['description'] = description;
    return _data;
  }
}