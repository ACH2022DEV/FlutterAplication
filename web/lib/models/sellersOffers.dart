  import 'package:t3_market_place/models/sellersModels.dart';

class SellerOffers {
  int id;
  Offer offer;
  Seller seller;
  String creationDate;
  String startDate;

  SellerOffers({
    required this.id,
    required this.offer,
    required this.seller,
    required this.creationDate,
    required this.startDate,
  });
 factory SellerOffers.fromJson(Map<String, dynamic> json) {
    return SellerOffers(
      id: json['id'],
      offer: Offer.fromJson(json['offer']),
      seller: Seller.fromJson(json['seller']),
      creationDate: json['creationDate'],
      startDate: json['startDate'],
    );
  }



}

class Offer {
  int id;
  String name;
  int nbDays;
  List<OfferProductType> offerProductTypes;

  Offer({
    required this.id,
    required this.name,
    required this.nbDays,
    required this.offerProductTypes,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
     List<dynamic> offerProductTypesJson = json['offerProductTypes'];
    List<OfferProductType> offerProductTypes = offerProductTypesJson
        .map((json) => OfferProductType.fromJson(json))
        .toList();

    return Offer(
      id: json['id'],
      name: json['name'],
      nbDays: json['nbDays'],
      offerProductTypes: offerProductTypes,
    );
  }
}


class ProductType {
  int id;
  String name;

  ProductType({
    required this.id,
    required this.name,
  });
  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'],
      name: json['name'],
    );
  }
}

class OfferProductType {
  int id;
  ProductType productType;
  String maxItems;
  double price;

  OfferProductType({
    required this.id,
    required this.productType,
    required this.maxItems,
    required this.price,
  });
   factory OfferProductType.fromJson(Map<String, dynamic> json) {
    return OfferProductType(
      id: json['id'],
      productType: ProductType.fromJson(json['productType']),
      maxItems: json['maxItems'],
      price: json['price'],
    );
  }
}
/************************************code2 */
/*  import 'dart:convert';

import 'package:web/models/sellersModels.dart';

List<SellerOffers> sellerOffersFromJson(String str) => List<SellerOffers>.from(json.decode(str).map((x) => SellerOffers.fromJson(x)));

String sellerOffersToJson(List<SellerOffers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SellerOffers {
    SellerOffers({
        required this.id,
        required this.offer,
        required this.seller,
        required this.creationDate,
        required this.startDate,
    });

    int id;
    Offer offer;
    Seller seller;
    DateTime creationDate;
    DateTime startDate;

    factory SellerOffers.fromJson(Map<String, dynamic> json) => SellerOffers(
        id: json["id"],
        offer: Offer.fromJson(json["offer"]),
        seller: Seller.fromJson(json["seller"]),
        creationDate: DateTime.parse(json["creationDate"]),
        startDate: DateTime.parse(json["startDate"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "offer": offer.toJson(),
        "seller": seller.toJson(),
        "creationDate": creationDate.toIso8601String(),
        "startDate": startDate.toIso8601String(),
    };
}

class Offer {
    Offer({
        required this.id,
        required this.name,
        required this.nbDays,
        required this.offerProductTypes,
    });

    int id;
    String name;
    int nbDays;
    List<OfferProductType> offerProductTypes;

    factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        name: json["name"],
        nbDays: json["nbDays"],
        offerProductTypes: List<OfferProductType>.from(json["offerProductTypes"].map((x) => OfferProductType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nbDays": nbDays,
        "offerProductTypes": List<dynamic>.from(offerProductTypes.map((x) => x.toJson())),
    };
}

class OfferProductType {
    OfferProductType({
        required this.id,
        required this.productType,
        required this.maxItems,
        required this.price,
    });

    int id;
    ProductType productType;
    String maxItems;
    int price;

    factory OfferProductType.fromJson(Map<String, dynamic> json) => OfferProductType(
        id: json["id"],
        productType: ProductType.fromJson(json["productType"]),
        maxItems: json["maxItems"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "productType": productType.toJson(),
        "maxItems": maxItems,
        "price": price,
    };
}

class ProductType {
    ProductType({
        required this.id,
        required this.name,
    });

    int id;
    String name;

    factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

/* class Seller {
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

    String brochureFilename;
    int id;
    String name;
    String website;
    String address;
    List<dynamic> city;
    List<dynamic> user;
    Api api;

    factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        brochureFilename: json["brochureFilename"],
        id: json["id"],
        name: json["name"],
        website: json["website"],
        address: json["address"],
        city: List<dynamic>.from(json["city"].map((x) => x)),
        user: List<dynamic>.from(json["user"].map((x) => x)),
        api: Api.fromJson(json["api"]),
    ); */

   /*  Map<String, dynamic> toJson() => {
        "brochureFilename": brochureFilename,
        "id": id,
        "name": name,
        "website": website,
        "address": address,
        "city": List<dynamic>.from(city.map((x) => x)),
        "user": List<dynamic>.from(user.map((x) => x)),
        "api": api.toJson(),
    };
} */

class Api {
    Api({
        required this.id,
        required this.baseUrl,
        required this.apiKeyValue,
        required this.login,
        required this.password,
        required this.apiProducts,
    });

    int id;
    String baseUrl;
    String apiKeyValue;
    String login;
    String password;
    List<dynamic> apiProducts;

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
 */