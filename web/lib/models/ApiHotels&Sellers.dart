/* import 'package:web/models/Hotels.dart';

class Hotel {
  //String hotelName;
  Hotels hotelData;
  List<Seller> seller;

  Hotel({
 // required  this.hotelName,
  required  this.hotelData,
  required  this.seller
  });

  /* factory Hotel.fromJson(Map<String, dynamic> json) {
    final hotelName = json.keys.first; // Get the variable hotel name

    return Hotel(
      hotelName: hotelName,
      hotelData: Hotels.fromJson(json['hotel']),
      seller: List<Seller>.from(json['seller'].map((seller) => Seller.fromJson(seller))),
    );
  } */
  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
        seller: List<Seller>.from(json['seller']),
       hotelData: Hotels.fromJson(json['hotel']),
      // hotelName: hotelName.toString(),
     

      );

  Map<String, dynamic> toJson() => {
        "seller": seller.toList(),
        "hotelData": hotelData,
      };
      
}
 
 
 class Hotels {
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
  List<Seller> seller;

  Hotels({
   required this.hotelId,
   required this.hotelName,
    required this.category,
  required  this.location,
 required   this.picture,
  required  this.promoText,
   required this.lowPrice,
  required  this.currency,
  required  this.detailsLink,
 required   this.agency,
 required   this.seller,
  });

  factory Hotels.fromJson(Map<String, dynamic> json) {
    final hotelName = json.keys.first; // Get the variable hotel name

    return Hotels(
      hotelId: json[hotelName]['hotelId'],
      hotelName: hotelName,
      category: json[hotelName]['category'],
      location: json[hotelName]['location'],
      picture: json[hotelName]['Picture'],
      promoText: json[hotelName]['PromoText'],
      lowPrice: json[hotelName]['lowPrice'],
      currency: json[hotelName]['currency'],
      detailsLink: json[hotelName]['detailsLink'],
      agency: json[hotelName]['Agency'],
      seller: List<Seller>.from(json[hotelName]['seller'].map((seller) => Seller.fromJson(seller))),
    );
  }
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
 required   this.brochureFilename,
 required   this.id,
  required  this.name,
  required  this.website,
  required  this.address,
  required  this.city,
  required  this.user,
  required  this.api,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
     final hotelName = json.keys.first; // Get the variable hotel name
    return Seller(
      brochureFilename: json[hotelName]['brochureFilename'],
      id: json[hotelName]['id'],
      name: json[hotelName]['name'],
      website: json[hotelName]['website'],
      address: json[hotelName]['address'],
      city: List<dynamic>.from(json[hotelName]['city']),
      user: List<dynamic>.from(json[hotelName]['user']),
      api: Api.fromJson(json[hotelName]['api']),
    );
  }
}

class Api {
  int id;
  String baseUrl;
  String apiKeyValue;
  String login;
  String password;
  List<dynamic> apiProducts;

  Api({
 required   this.id,
   required this.baseUrl,
 required   this.apiKeyValue,
required    this.login,
required    this.password,
 required   this.apiProducts,
  });

  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(
      id: json['id'],
      baseUrl: json['baseUrl'],
      apiKeyValue: json['apiKeyValue'],
      login: json['login'],
      password: json['password'],
      apiProducts: List<dynamic>.from(json['apiProducts']),
    );
  }
}
  */

// To parse this JSON data, do
//
//     final hotelsSellers = hotelsSellersFromJson(jsonString);

import 'dart:convert';

Map<String, Hotels> hotelsSellersFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, Hotels>(k, Hotels.fromJson(v)));

String hotelsSellersToJson(Map<String, Hotels> data) => json.encode(
    Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Hotels {
  String hotelName;
  Hotel hotel;
  List<Seller> sellers;

  Hotels({
    required this.hotelName,
    required this.hotel,
    required this.sellers,
  });
  factory Hotels.fromJson(Map<String, dynamic> json) {
    final hotelName = json.keys.first; // Get the variable hotel name

    return Hotels(
      hotelName: hotelName,
      hotel: Hotel.fromJson(json["hotel"]),
      sellers:
          List<Seller>.from(json["sellers"].map((x) => Seller.fromJson(x))),
    );
  }

  //get first => null;
  Map<String, dynamic> toJson() => {
        "hotel": hotel.toJson(),
        "sellers": List<dynamic>.from(sellers.map((x) => x.toJson())),
      };
  List<Hotels> filterHotelsByRating(List<Hotels> hotels, String rating) {
    return hotels.where((hotel) {
      // Check if the hotel's rating is greater than or equal to the specified value
      return hotel.hotel.category == rating;
    }).toList();
  }

  /* List<Hotels> filterHotelsByName(List<Hotels> hotels, String name) {
    return hotels.where((hotel) {
      // Check if the hotel's rating is greater than or equal to the specified value
      return hotel.hotel.hotelName.toLowerCase().contains(name.toLowerCase());
    }).toList();
  } */
  List<Hotels> filterHotelsByName(List<Hotels> hotels, String name) {
    return hotels.where((hotel) {
      return hotel.hotel.hotelName.toLowerCase().startsWith(name.toLowerCase());
    }).toList();
  }

  List<Hotels> filterHotelsByPrix(
      List<Hotels> hotels, int minPrix, int maxPrix) {
    return hotels.where((hotel) {
      // Check if any seller's price falls within the specified range
      return hotel.sellers.any((seller) {
        final sellerPrix = int.tryParse(seller.prixSeller);
        return sellerPrix != null &&
            sellerPrix >= minPrix &&
            sellerPrix <= maxPrix;
      });
    }).toList();
  }

  List<Hotels> filterHotelsByPriceLowTohightHight(List<Hotels> hotels) {
    List<Hotels> sortedHotels =
        List.from(hotels); // Crée une copie de la liste originale

    sortedHotels.sort((a, b) => a.hotel.lowPrice.compareTo(b.hotel.lowPrice));

    return sortedHotels;
  }

  List<Hotels> filterHotelsByPriceHighToLow(List<Hotels> hotels) {
    List<Hotels> sortedHotels =
        List.from(hotels); // Crée une copie de la liste originale
  //  sortedHotels.sort();
    sortedHotels.sort((a, b) => b.hotel.lowPrice.compareTo(a.hotel.lowPrice));

    return sortedHotels;
  }

  /* List<Hotels> filterHotelsByRating2(List<Hotels> hotels, double rating) {
      return hotels.where((hotel) {
        // Vérifiez si le classement (rating) de l'hôtel est supérieur ou égal à la valeur spécifiée
        return hotel.hotel.category == rating;
      }).toList();
    }  */
}

class Hotel {
  String hotelId;
  String hotelName;
  String category;
  String location;
  String picture;
  // String? latitude;
  // String? longitude;
  String promoText;
  String lowPrice;
  String currency;
  String detailsLink;
  String agency;

  Hotel({
    required this.hotelId,
    required this.hotelName,
    required this.category,
    required this.location,
    required this.picture,
    required this.promoText,
    //  this.latitude,
    //     this.longitude,
    required this.lowPrice,
    required this.currency,
    required this.detailsLink,
    required this.agency,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
        hotelId: json["hotelId"],
        hotelName: json["hotelName"],
        category: json["category"],
        location: json["location"],
        picture: json["Picture"],
        promoText: json["PromoText"],
        // latitude: json["Latitude"],
        // longitude: json["Longitude"],
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
        //  "Latitude": latitude,
        // "Longitude": longitude,
        "lowPrice": lowPrice,
        "currency": currency,
        "detailsLink": detailsLink,
        "Agency": agency,
      };
}

class Seller {
  SellerData sellerData;
  String prixSeller;
  String detailsLink;

  Seller({
    required this.sellerData,
    required this.prixSeller,
    required this.detailsLink,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        sellerData: SellerData.fromJson(json["sellerData"]),
        prixSeller: json["PrixSeller"] ?? Null,
        detailsLink: json["detailsLink"],
      );

  Map<String, dynamic> toJson() => {
        "sellerData": sellerData.toJson(),
        "PrixSeller": prixSeller,
        "detailsLink": detailsLink,
      };
}

class SellerData {
  String brochureFilename;
  int id;
  String name;
  String website;
  String address;
  List<dynamic> city;
  List<dynamic> user;
  Api api;

  SellerData({
    required this.brochureFilename,
    required this.id,
    required this.name,
    required this.website,
    required this.address,
    required this.city,
    required this.user,
    required this.api,
  });

  factory SellerData.fromJson(Map<String, dynamic> json) => SellerData(
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
  //  List<ApiProduct> apiProducts;

  Api({
    required this.id,
    required this.baseUrl,
    required this.apiKeyValue,
    required this.login,
    required this.password,
    //required this.apiProducts,
  });

  factory Api.fromJson(Map<String, dynamic> json) => Api(
        id: json["id"],
        baseUrl: json["baseUrl"],
        apiKeyValue: json["apiKeyValue"],
        login: json["login"],
        password: json["password"],
        //  apiProducts: List<ApiProduct>.from(json["apiProducts"].map((x) => ApiProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "baseUrl": baseUrl,
        "apiKeyValue": apiKeyValue,
        "login": login,
        "password": password,
        //  "apiProducts": List<dynamic>.from(apiProducts.map((x) => x.toJson())),
      };
}

class ApiProduct {
  int id;
  String name;
  ProductType productType;
  String idProductFromApi;
  List<dynamic> sellerOfferHasProduct;
  List<ApiProductClick> apiProductClicks;

  ApiProduct({
    required this.id,
    required this.name,
    required this.productType,
    required this.idProductFromApi,
    required this.sellerOfferHasProduct,
    required this.apiProductClicks,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) => ApiProduct(
        id: json["id"],
        name: json["name"],
        productType: ProductType.fromJson(json["productType"]),
        idProductFromApi: json["idProductFromApi"],
        sellerOfferHasProduct:
            List<dynamic>.from(json["SellerOffer_has_Product"].map((x) => x)),
        apiProductClicks: List<ApiProductClick>.from(
            json["apiProductClicks"].map((x) => ApiProductClick.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "productType": productType.toJson(),
        "idProductFromApi": idProductFromApi,
        "SellerOffer_has_Product":
            List<dynamic>.from(sellerOfferHasProduct.map((x) => x)),
        "apiProductClicks":
            List<dynamic>.from(apiProductClicks.map((x) => x.toJson())),
      };
}

class ApiProductClick {
  int id;
  String date;
  String? ipTraveler;
  String? ipLocation;
  dynamic traveler;

  ApiProductClick({
    required this.id,
    required this.date,
    this.ipTraveler,
    this.ipLocation,
    this.traveler,
  });

  factory ApiProductClick.fromJson(Map<String, dynamic> json) =>
      ApiProductClick(
        id: json["id"],
        date: json["date"],
        ipTraveler: json["ipTraveler"],
        ipLocation: json["ipLocation"],
        traveler: json["traveler"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "ipTraveler": ipTraveler,
        "ipLocation": ipLocation,
        "traveler": traveler,
      };
}

class ProductType {
  int id;
  String name;

  ProductType({
    required this.id,
    required this.name,
  });

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
  List<List<dynamic>> apiProducts;

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
        apiProducts: List<List<dynamic>>.from(json["apiProducts"]
            .map((x) => List<dynamic>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "baseUrl": baseUrl,
        "apiKeyValue": apiKeyValue,
        "login": login,
        "password": password,
        "apiProducts": List<dynamic>.from(
            apiProducts.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}
 */