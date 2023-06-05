import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/hotelsSellers.dart';

class ProductsPage2 extends StatefulWidget {
  const ProductsPage2({Key? key}) : super(key: key);

  //final List<Api_Hotels> products;

  //const ProductsPage({required Key key, required this.products}): super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage2> {
  List<HotelsSellers> products = [];

  List<HotelsSellers> products2 = [];

  bool _loading = true;
  Color favoriteColor = Color.fromARGB(255, 183, 183, 182);
  @override
  void initState() {
    super.initState();

    fetchHotels();
  }

  Future<void> fetchHotels() async {
    // final url = Uri.parse('http://btob.3t.tn/getProducts?product=hotels');
    final url = Uri.parse('http://user3-market.3t.tn/ApiHotel/getApiHotels');
    // final headers = {'Accept': 'application/json', 'Access-Control-Allow-Origin': '*'};
    final body = {
      "checkIn": "2023-03-27",
      "checkOut": "2023-03-28",
      "city": "Sousse",
      "hotelName": "",
      "boards": [],
      "rating": [],
      "occupancies": {
        "1": {
          "adult": "2",
          "child": {"value": "2", "age": "2"}
        }
      },
      "channel": "b2c",
      "language": "fr_FR",
      "onlyAvailableHotels": false,
      "marketId": "1",
      "customerId": "7",
      "backend": 0,
      "filtreSearch": []
    };

    var response = await http.post(url, body: jsonEncode(body));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      //  var rest = jsonData["data"] ;
      // var ProductsMap = jsonDecode(response.body);
//List<dynamic> products = HotelsSellers.fromJson(ProductsMap);

      //print(jsonData);

      products = jsonData
          .map<HotelsSellers>((json) => HotelsSellers.fromJson(json))
          .toList();
      products2 = products;
      print(products2);
      setState(() {
        _loading = false;
        print(_loading);
      });
      // setState(() {
      //  if (products.isNotEmpty) {

      // }
      //  });

      //return response;
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      // margin: EdgeInsets.all(40),

      child: _loading
          ? Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 20,
                      height: 1000,
                      margin: EdgeInsets.only(top: 50, bottom: 50, left: 170),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 183, 2),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                            ignoreGestures: true,
                          ),
                          RatingBar.builder(
                            initialRating: 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 183, 2),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                            ignoreGestures: true,
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 183, 2),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                            ignoreGestures: true,
                          ),
                          RatingBar.builder(
                            initialRating: 4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 183, 2),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                            ignoreGestures: true,
                          ),
                          RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 183, 2),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                            ignoreGestures: false,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  // Filter hotels with a category of 5

                  Expanded(
                    flex: 4,
                    child: Container(
                      //width: double.maxFinite,
                      margin: EdgeInsets.only(top: 50, bottom: 50),
                      padding: const EdgeInsets.all(10),
                      // height: double.infinity,

                      child: ListView.builder(
                        /*   primary: false,
                        shrinkWrap: false, */ // changed from false to true
                        shrinkWrap: true,
                        itemCount: products2.length,

                        /*   gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3), */

                        itemBuilder: (context, int index) {
                          final hotel = products2[index];
                          final response = hotel.data.response;

                          //   print('index $index');

                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: response.length,
                              itemBuilder: (BuildContext context, int index) {
                                double ratingValue = double.parse(
                                    hotel.data.response[index].category);

                                print('$index ,$response');
                                return Container(
                                  height: 300,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Stack(
                                          children: [
                                            // L'image à afficher

                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.network(
                                                hotel.data.response[index]
                                                    .picture,
                                                fit: BoxFit.cover,
                                                height: double.infinity,
                                              ),
                                            ),
                                            // ),
                                            // Le bouton "favori"
                                            Positioned(
                                              top:
                                                  10, // Ajuster la position verticale selon vos besoins
                                              right:
                                                  10, // Ajuster la position horizontale selon vos besoins
                                              child: InkWell(
                                                onTap: () {
                                                  // Code à exécuter lorsque l'utilisateur clique sur le bouton "favori"
                                                  bool isFavorite =
                                                      false; // Vérifier si le produit est déjà dans les favoris
                                                  if (isFavorite) {
                                                  } else {
                                                    // Ajouter le produit aux favoris
                                                    // ...
                                                    setState(() {
                                                      favoriteColor = Colors
                                                          .red; // Mettre la couleur en rouge
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 30,
                                                  color: favoriteColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'HotelName: ${hotel.data.response[index].hotelName.toString()}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  //   fontFamily:String.fromEnvironment(deprecated)
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              RatingBar.builder(
                                                initialRating: ratingValue,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 30.0,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Color.fromARGB(
                                                      255, 255, 183, 2),
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                                ignoreGestures: true,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Price : ${hotel.data.response[index].lowPrice.toString()}' +
                                                    '${hotel.data.response[index].currency.toString()}',
                                                style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  ClipOval(
                                                    child: Image.network(
                                                      'http://user3-market.3t.tn/getImages?filename=${hotel.seller!.brochureFilename}',
                                                      fit: BoxFit.cover,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  SizedBox(width: 7),
                                                  Text(
                                                    hotel.seller!.name
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on,
                                                          size: 30,
                                                        ),
                                                        Text(
                                                          '${hotel.data.response[index].location.toString()}',
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  TextButton(
                                                    onPressed: () {
                                                      print('ee');
                                                    },
                                                    child: Row(
                                                      children: [
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            elevation:
                                                                5, // hauteur de l'élévation
                                                            backgroundColor: Colors
                                                                    .grey[
                                                                800], // couleur de fond
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        12,
                                                                    horizontal:
                                                                        16), // padding
                                                          ),
                                                          onPressed: () async {
                                                            var url = hotel
                                                                .data
                                                                .response[index]
                                                                .detailsLink
                                                                .toString();

                                                            // ignore: deprecated_member_use
                                                            if (await canLaunch(
                                                                url)) {
                                                              // ignore: deprecated_member_use
                                                              await launch(url);
                                                            } else {
                                                              throw 'Impossible d\'ouvrir $url';
                                                            }
                                                          },
                                                          child: Text(
                                                            'Voir Offer',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.minPositive,
                      height: double.maxFinite,
                      margin: EdgeInsets.only(top: 50, bottom: 50, left: 170),
                      padding: const EdgeInsets.all(10),
                      /*   decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                       /*  boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ], */
                      ), */
                    ),
                  ),
                ]),
    )));
  }
}
