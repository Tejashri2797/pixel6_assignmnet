class PostCodeDetailsModal {
  String? status;
  int? statusCode;
  int? postcode;
  List<City>? city;
  List<City>? state;

  PostCodeDetailsModal({
    this.status,
    this.statusCode,
    this.postcode,
    this.city,
    this.state,
  });

  factory PostCodeDetailsModal.fromJson(Map<String, dynamic> json) => PostCodeDetailsModal(
    status: json["status"],
    statusCode: json["statusCode"],
    postcode: json["postcode"],
    city: json["city"] == null ? [] : List<City>.from(json["city"]!.map((x) => City.fromJson(x))),
    state: json["state"] == null ? [] : List<City>.from(json["state"]!.map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "postcode": postcode,
    "city": city == null ? [] : List<dynamic>.from(city!.map((x) => x.toJson())),
    "state": state == null ? [] : List<dynamic>.from(state!.map((x) => x.toJson())),
  };
}

class City {
  int? id;
  String? name;

  City({
    this.id,
    this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}