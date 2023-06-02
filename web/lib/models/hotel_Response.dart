
class Api_Hotels {
  String hotelId;
  String hotelName;
  String category;
  String location;
String picture;
 String promoText;
  String lowPrice;
  String currency;
  String detailsLink;
  String agency;

  Api_Hotels({
    required this.hotelId,
    required this.hotelName,
    required this.category,
    required this.location,
    required this.picture,
   required this.promoText,
    required this.lowPrice,
    required this.currency,
    required this.detailsLink,
    required this.agency,
  });

  factory Api_Hotels.fromJson(Map<String, dynamic> json) {
    return Api_Hotels(
      hotelId: json['hotelId'] ??"",
      hotelName: json['hotelName'] as String,
      category: json['category'] as String,
     location: json['location'] as String,
     
      picture: json['Picture'] as String,
      promoText: json['PromoText'] as String,
      lowPrice: json['lowPrice'] as String,
    //   lowPrice: double.parse(json['lowPrice']), // Parse as double
      currency: json['currency'] as String,
      detailsLink: json['detailsLink'] as String,
      agency: json['Agency'] as String,
    );
  }

  toJson() {}
}
