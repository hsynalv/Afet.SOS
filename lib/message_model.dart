class MessageModel {
  int? packetId;
  Source? source;
  Action? action;
  int? routeId;
  List<Data>? data;

  MessageModel(
      {this.packetId, this.source, this.action, this.routeId, this.data});

  MessageModel.fromJson(Map<String, dynamic> json) {
    packetId = json['packet_id'];
    source =
        json['source'] != null ? new Source.fromJson(json['source']) : null;
    action =
        json['action'] != null ? new Action.fromJson(json['action']) : null;
    routeId = json['route_id'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packet_id'] = this.packetId;
    if (this.source != null) {
      data['source'] = this.source!.toJson();
    }
    if (this.action != null) {
      data['action'] = this.action!.toJson();
    }
    data['route_id'] = this.routeId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Source {
  int? id;
  String? name;

  Source({this.id, this.name});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Action {
  int? type;
  int? ext;

  Action({this.type, this.ext});

  Action.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    ext = json['ext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['ext'] = this.ext;
    return data;
  }
}

class Data {
  Source? source;
  String? data;

  Data({this.source, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    source =
        json['source'] != null ? new Source.fromJson(json['source']) : null;
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.source != null) {
      data['source'] = this.source!.toJson();
    }
    data['data'] = this.data;
    return data;
  }
}