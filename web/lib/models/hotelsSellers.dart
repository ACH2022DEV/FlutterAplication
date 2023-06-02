// To parse this JSON data, do
//
//     final hotelsSellers = hotelsSellersFromJson(jsonString);

import 'dart:convert';

/* List<HotelsSellers> hotelsSellersFromJson(String str) =>
    List<HotelsSellers>.from(
        json.decode(str).map((x) => HotelsSellers.fromJson(x)));

String hotelsSellersToJson(List<HotelsSellers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson()))); */

class HotelsSellers {
  Seller? seller;
  Data data;

  HotelsSellers({
     this.seller,
    required this.data,
  });

  factory HotelsSellers.fromJson(Map<String, dynamic> json) => HotelsSellers(
        seller: Seller.fromJson(json["seller"]),
       data: Data.fromJson(json["data"]),
     

      );

  Map<String, dynamic> toJson() => {
        "seller": seller!.toJson(),
        "data": data.toJson(),
      };
      
     
    
}

class Data {
  String? method;
  List<Response> response;

  Data({
     this.method,
    required this.response,
  });

  /* //ajouter par moi
   Data copyWith({List<Response>? response}) {
    return Data(method:method,response: response ?? this.response);
  }
  //ajouter par moi */

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        method: json["method"],
        response: List<Response>.from(
            json["response"].map((x) => Response.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
        /* List<Response> getFiveStarHotels() {
    return response.where((hotel) => hotel.category == '5').toList();
  }  */
      
}

class Response {
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

  Response({
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

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        hotelId: json["hotelId"],
        hotelName: json["hotelName"],
        category: json["category"],
        location: json["location"],
        picture: json["Picture"],
        promoText: json["PromoText"],
        lowPrice: json["lowPrice"],
        currency: json["currency"],
        detailsLink: json["detailsLink"],
        agency: json["Agency"],
      );

  Map<String, dynamic> toJson() => {
        "hotelId": hotelId,
        "hotelName": hotelName,
        "category": category,
        "location": location,
        "Picture": picture,
        "PromoText": promoText,
        "lowPrice": lowPrice,
        "currency": currency,
        "detailsLink": detailsLink,
        "Agency": agency,
      };
}

class Seller {
  String brochureFilename;
  int id;
  String name;
  String website;
  String address;
  List<dynamic> city;
  List<dynamic> user;
  Api api;

  Seller({
    required this.brochureFilename,
    required this.id,
    required this.name,
    required this.website,
    required this.address,
    required this.city,
    required this.user,
    required this.api,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        brochureFilename: json["brochureFilename"],
        id: json["id"],
        name: json["name"],
        website: json["website"],
        address: json["address"],
        city: List<dynamic>.from(json["city"].map((x) => x)),
        user: List<dynamic>.from(json["user"].map((x) => x)),
        api: Api.fromJson(json["api"]),
      );

  Map<String, dynamic> toJson() => {
        "brochureFilename": brochureFilename,
        "id": id,
        "name": name,
        "website": website,
        "address": address,
        "city": List<dynamic>.from(city.map((x) => x)),
        "user": List<dynamic>.from(user.map((x) => x)),
        "api": api.toJson(),
      };
}

class Api {
  int id;
  String baseUrl;
  String apiKeyValue;
  String login;
  String password;
  List<dynamic> apiProducts;

  Api({
    required this.id,
    required this.baseUrl,
    required this.apiKeyValue,
    required this.login,
    required this.password,
    required this.apiProducts,
  });

  factory Api.fromJson(Map<String, dynamic> json) => Api(
        id: json["id"],
        baseUrl: json["baseUrl"],
        apiKeyValue: json["apiKeyValue"],
        login: json["login"],
        password: json["password"],
        apiProducts: List<dynamic>.from(json["apiProducts"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "baseUrl": baseUrl,
        "apiKeyValue": apiKeyValue,
        "login": login,
        "password": password,
        "apiProducts": List<dynamic>.from(apiProducts.map((x) => x)),
      };
}
