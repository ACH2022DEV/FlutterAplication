
class Api_Circuit {
  String id;
  String voyageName;
  String agency;
  String currency;
  String detailsLink;
  String picture;
  String depart;
  String pays;
  String category;

  Api_Circuit({
    required this.id,
    required this.voyageName,
    required this.agency,
    required this.currency,
    required this.detailsLink,
    required this.picture,
    required this.depart,
    required this.pays,
    required this.category,
  });

  factory Api_Circuit.fromJson(Map<String, dynamic> json) {
    return Api_Circuit(
      id: json['id'] as String,
      voyageName: json['voyageName'] as String,
      agency: json['agency'] as String,
      currency: json['currency'] as String,
      detailsLink: json['detailsLink'] as String,
      picture: json['Picture'] as String,
      depart: json['depart'] as String,
      pays: json['pays'] as String,
      category: json['category'] as String,
    );
  }
}
