/* import 'dart:html';
import 'dart:typed_data';

class Seller {
  int id;
 // String name;
 // String? website;
  //String address;
 // City city;   //final List<dynamic> city;
//  List<dynamic> user;
  Api api;
  String brochureFilename;
  Seller({
    required this.id,
   // required this.name,
  //  required this.website,
    //required this.address,
    required this.brochureFilename,
    required this.api,
   // required this.city,
   // required this.user,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] as int,
      //name: json['name'],
   //   website : json['website'] ?? '',
      // address : json['address']  ? json['address'] : "",
      brochureFilename: json['brochureFilename'] ??"" ,
     // api: json['api'] != null ? Api.fromJson(json['api']) : null,
      api: Api.fromJson(json['api'] ?? {}),
     // city: City.fromJson(json['city'] ?? {}),
    //  city: json['city'] as List<dynamic>,
     // user: json['user'] as List<dynamic>,
 // user: User.fromJson(json['user'] ?? {}),
      );
  }

  toJson() {}
}

//add City Class

class City {
  int id;
  String name;
  String latitude;
  String longitude;
  bool active;
 // Country_code country_code;
  City({
    required this.id,
    required this.name,
   required this.latitude,
    required this.longitude,
    required this.active,
    //required this.country_code,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] as String,
      latitude: json['latitude']  ??"",
      longitude: json['longitude'] ??"",
      active: json['active'],
   //   country_code: Country_code.fromJson(json['country_code']),
    );
  }
}

//en of CityClass

//add country class
class Country_code {
  //String code;
 // String? alpha3;
  //String? name;
  //String? capital;
  String currency;
  int phone_code;
  Country_code({
  //  required this.code,
   // required this.name,
   // required this.alpha3,
  //  required this.capital,
    required this.currency,
    required this.phone_code,
  });

  factory Country_code.fromJson(Map<String, dynamic> json) {
    return Country_code(
     // code: json['code'] ??"",
    //  name: json['name']??"" ,
   //   alpha3: json['alpha3'] ??"",
    //   capital: json['capital'] ??"" ,
      currency: json['currency'],
      phone_code: json['phone_code'],
    );
  }
}

//end of countryClass
//add Api class
class Api {
  int? id;
  String baseUrl;
  String apiKeyValue;
  String login;
  String password;
   //List<dynamic> apiProducts;

  Api({
    required this.id,
    required this.baseUrl,
    required this.apiKeyValue,
    required this.login,
    required this.password,
   //  required this.apiProducts,

  });

  factory Api.fromJson(Map<String, dynamic> json) {
    return Api(
      id: json['id'] ,
      baseUrl: json['baseUrl'] ??"",
      apiKeyValue: json['apiKeyValue'] ??"",
      login: json['login'] ??"",
      password: json['password']??"",
      //apiProducts: (json['apiProducts']??"" as List<dynamic>)
    );
  }
}

//end of ApiClass

 */
// To parse this JSON data, do
//
//     final seller = sellerFromJson(jsonString);

/* import 'dart:convert';

List<Seller> sellerFromJson(String str) => List<Seller>.from(json.decode(str).map((x) => Seller.fromJson(x)));

String sellerToJson(List<Seller> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Seller {
    int id;
    String name;
    String website;
    String address;
    City city;
    User user;
    Api? api;
    String brochureFilename;
    List<SellerOffer> sellerOffers;

    Seller({
        required this.id,
        required this.name,
        required this.website,
        required this.address,
        required this.city,
        required this.user,
        this.api,
        required this.brochureFilename,
        required this.sellerOffers,
    });

    factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        name: json["name"],
        website: json["website"],
        address: json["address"],
        city: City.fromJson(json["city"]),
        user: User.fromJson(json["user"]),
        api: json["api"] == null ? null : Api.fromJson(json["api"]),
        brochureFilename: json["brochureFilename"],
        sellerOffers: List<SellerOffer>.from(json["sellerOffers"].map((x) => SellerOffer.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "website": website,
        "address": address,
        "city": city.toJson(),
        "user": user.toJson(),
        "api": api?.toJson(),
        "brochureFilename": brochureFilename,
        "sellerOffers": List<dynamic>.from(sellerOffers.map((x) => x.toJson())),
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
        apiProducts: List<List<dynamic>>.from(json["apiProducts"].map((x) => List<dynamic>.from(x.map((x) => x)))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "baseUrl": baseUrl,
        "apiKeyValue": apiKeyValue,
        "login": login,
        "password": password,
        "apiProducts": List<dynamic>.from(apiProducts.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}

class City {
    int id;
    String name;
    dynamic latitude;
    dynamic longitude;
    bool active;
    CountryCode countryCode;

    City({
        required this.id,
        required this.name,
        this.latitude,
        this.longitude,
        required this.active,
        required this.countryCode,
    });

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        active: json["active"],
        countryCode: CountryCode.fromJson(json["country_code"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "active": active,
        "country_code": countryCode.toJson(),
    };
}

class CountryCode {
    String code;
    String alpha3;
    String name;
    String capital;
    dynamic currency;
    int phoneCode;

    CountryCode({
        required this.code,
        required this.alpha3,
        required this.name,
        required this.capital,
        this.currency,
        required this.phoneCode,
    });

    factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
        code: json["code"],
        alpha3: json["alpha3"],
        name: json["name"],
        capital: json["capital"],
        currency: json["currency"],
        phoneCode: json["phone_code"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "alpha3": alpha3,
        "name": name,
        "capital": capital,
        "currency": currency,
        "phone_code": phoneCode,
    };
}

class SellerOffer {
    int id;
    Offer offer;
    String creationDate;
    String startDate;

    SellerOffer({
        required this.id,
        required this.offer,
        required this.creationDate,
        required this.startDate,
    });

    factory SellerOffer.fromJson(Map<String, dynamic> json) => SellerOffer(
        id: json["id"],
        offer: Offer.fromJson(json["offer"]),
        creationDate: json["creationDate"],
        startDate: json["startDate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "offer": offer.toJson(),
        "creationDate": creationDate,
        "startDate": startDate,
    };
}

class Offer {
    int id;
    String name;
    int nbDays;
    List<List<dynamic>> offerProductTypes;

    Offer({
        required this.id,
        required this.name,
        required this.nbDays,
        required this.offerProductTypes,
    });

    factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        name: json["name"],
        nbDays: json["nbDays"],
        offerProductTypes: List<List<dynamic>>.from(json["offerProductTypes"].map((x) => List<dynamic>.from(x.map((x) => x)))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nbDays": nbDays,
        "offerProductTypes": List<dynamic>.from(offerProductTypes.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}

class User {
    int id;
    String email;
    List<String> roles;
    bool isVerified;
    String username;
    String displayName;

    User({
        required this.id,
        required this.email,
        required this.roles,
        required this.isVerified,
        required this.username,
        required this.displayName,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        isVerified: json["isVerified"],
        username: json["username"],
        displayName: json["display_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "isVerified": isVerified,
        "username": username,
        "display_name": displayName,
    };
}
 */
// To parse this JSON data, do
//
//     final seller = sellerFromJson(jsonString);

import 'dart:convert';

List<Seller> sellerFromJson(String str) =>
    List<Seller>.from(json.decode(str).map((x) => Seller.fromJson(x)));

String sellerToJson(List<Seller> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Seller {
  int id;
  String name;
  String website;
  String address;
  City city;
  User user;
  Api? api;
  String brochureFilename;
  List<SellerOffer> sellerOffers;

  Seller({
    required this.id,
    required this.name,
    required this.website,
    required this.address,
    required this.city,
    required this.user,
    this.api,
    required this.brochureFilename,
    required this.sellerOffers,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        name: json["name"],
        website: json["website"],
        address: json["address"],
        city: City.fromJson(json["city"]),
        user: User.fromJson(json["user"]),
        api: json["api"] == null ? null : Api.fromJson(json["api"]),
        brochureFilename: json["brochureFilename"],
        sellerOffers: List<SellerOffer>.from(
            json["sellerOffers"].map((x) => SellerOffer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "website": website,
        "address": address,
        "city": city.toJson(),
        "user": user.toJson(),
        "api": api?.toJson(),
        "brochureFilename": brochureFilename,
        "sellerOffers": List<dynamic>.from(sellerOffers.map((x) => x.toJson())),
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
    //   required this.apiProducts,
  });

  factory Api.fromJson(Map<String, dynamic> json) => Api(
        id: json["id"],
        baseUrl: json["baseUrl"],
        apiKeyValue: json["apiKeyValue"],
        login: json["login"],
        password: json["password"],
        //   apiProducts: List<ApiProduct>.from(json["apiProducts"].map((x) => ApiProduct.fromJson(x))),
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
  List<dynamic> productType;
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
        productType: List<dynamic>.from(json["productType"].map((x) => x)),
        idProductFromApi: json["idProductFromApi"],
        sellerOfferHasProduct:
            List<dynamic>.from(json["SellerOffer_has_Product"].map((x) => x)),
        apiProductClicks: List<ApiProductClick>.from(
            json["apiProductClicks"].map((x) => ApiProductClick.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "productType": List<dynamic>.from(productType.map((x) => x)),
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

class City {
  int id;
  String name;
  dynamic latitude;
  dynamic longitude;
  bool active;
  CountryCode countryCode;

  City({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    required this.active,
    required this.countryCode,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        active: json["active"],
        countryCode: CountryCode.fromJson(json["country_code"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "active": active,
        "country_code": countryCode.toJson(),
      };
}

class CountryCode {
  String code;
  String alpha3;
  String name;
  String capital;
  dynamic currency;
  int phoneCode;

  CountryCode({
    required this.code,
    required this.alpha3,
    required this.name,
    required this.capital,
    this.currency,
    required this.phoneCode,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
        code: json["code"],
        alpha3: json["alpha3"],
        name: json["name"],
        capital: json["capital"],
        currency: json["currency"],
        phoneCode: json["phone_code"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "alpha3": alpha3,
        "name": name,
        "capital": capital,
        "currency": currency,
        "phone_code": phoneCode,
      };
}

class SellerOffer {
  int id;
  Offer offer;
  String creationDate;
  String startDate;

  SellerOffer({
    required this.id,
    required this.offer,
    required this.creationDate,
    required this.startDate,
  });

  factory SellerOffer.fromJson(Map<String, dynamic> json) => SellerOffer(
        id: json["id"],
        offer: Offer.fromJson(json["offer"]),
        creationDate: json["creationDate"],
        startDate: json["startDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer": offer.toJson(),
        "creationDate": creationDate,
        "startDate": startDate,
      };
}

class Offer {
  int id;
  String name;
  int nbDays;
  List<List<dynamic>> offerProductTypes;

  Offer({
    required this.id,
    required this.name,
    required this.nbDays,
    required this.offerProductTypes,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        name: json["name"],
        nbDays: json["nbDays"],
        offerProductTypes: List<List<dynamic>>.from(json["offerProductTypes"]
            .map((x) => List<dynamic>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nbDays": nbDays,
        "offerProductTypes": List<dynamic>.from(
            offerProductTypes.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class User {
  int id;
  String email;
  List<String> roles;
  bool isVerified;
  String username;
  String displayName;

  User({
    required this.id,
    required this.email,
    required this.roles,
    required this.isVerified,
    required this.username,
    required this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        isVerified: json["isVerified"],
        username: json["username"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "isVerified": isVerified,
        "username": username,
        "display_name": displayName,
      };
}
