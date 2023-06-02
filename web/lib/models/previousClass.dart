 


// class Hotel {
//   String hotelName;
//   HotelData hotelData;
//   List<Seller> seller;

//   Hotel({
//   required  this.hotelName,
//   required  this.hotelData,
//   required  this.seller,
//   });

//   factory Hotel.fromJson(Map<String, dynamic> json) {
//     final hotelName = json.keys.first; // Get the variable hotel name

//     return Hotel(
//       hotelName: hotelName,
//       hotelData: HotelData.fromJson(json[hotelName]['hotel']),
//       seller: List<Seller>.from(json[hotelName]['seller'].map((seller) => Seller.fromJson(seller))),
//     );
//   }
// }

// class HotelData {
//   String hotelId;
//   String hotelName;
//   String category;
//   String location;
//   String picture;
//   String promoText;
//   String lowPrice;
//   String currency;
//   String detailsLink;
//   String agency;

//   HotelData({
//   required  this.hotelId,
//   required  this.hotelName,
//   required  this.category,
//   required  this.location,
//  required   this.picture,
//   required  this.promoText,
//   required  this.lowPrice,
//   required  this.currency,
//   required  this.detailsLink,
//    required this.agency,
//   });

//   factory HotelData.fromJson(Map<String, dynamic> json) {
//     return HotelData(
//       hotelId: json['hotelId'],
//       hotelName: json['hotelName'],
//       category: json['category'],
//       location: json['location'],
//       picture: json['Picture'],
//       promoText: json['PromoText'],
//       lowPrice: json['lowPrice'],
//       currency: json['currency'],
//       detailsLink: json['detailsLink'],
//       agency: json['Agency'],
//     );
//   }
// }

// class Seller {
//   String brochureFilename;
//   int id;
//   String name;
//   String website;
//   String address;
//   List<dynamic> city;
//   List<dynamic> user;
//   Api api;

//   Seller({
//   required  this.brochureFilename,
//   required  this.id,
//   required  this.name,
//   required  this.website,
//   required  this.address,
//   required  this.city,
//  required   this.user,
//  required   this.api,
//   });

//   factory Seller.fromJson(Map<String, dynamic> json) {
//     return Seller(
//       brochureFilename: json['brochureFilename'],
//       id: json['id'],
//       name: json['name'],
//       website: json['website'],
//       address: json['address'],
//       city: List<dynamic>.from(json['city']),
//       user: List<dynamic>.from(json['user']),
//       api: Api.fromJson(json['api']),
//     );
//   }
// }

// class Api {
//   int id;
//   String baseUrl;
//   String apiKeyValue;
//   String login;
//   String password;
//   List<dynamic> apiProducts;

//   Api({
//    required this.id,
//    required this.baseUrl,
//   required  this.apiKeyValue,
//    required this.login,
//    required this.password,
//   required  this.apiProducts,
//   });

//   factory Api.fromJson(Map<String, dynamic> json) {
//     return Api(
//       id: json['id'],
//       baseUrl: json['baseUrl'],
//       apiKeyValue: json['apiKeyValue'],
//       login: json['login'],
//       password: json['password'],
//       apiProducts: List<dynamic>.from(json['apiProducts']),
//     );
//   }
// }
