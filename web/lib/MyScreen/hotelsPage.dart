import 'dart:convert';
import 'package:intl/intl.dart';

 import 'dart:html' as html;
 import 'dart:html';
 import 'dart:js' as js; //commented for mobile
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:t3_market_place/MyScreen/ResponsiveHotelView.dart';
import 'package:t3_market_place/MyScreen/header.dart';
import 'package:t3_market_place/MyScreen/MoteurRenWeb.dart';
import 'package:t3_market_place/MyScreen/responsive.dart';
import 'package:t3_market_place/MyScreen/webView_sitesAgency.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/ModelDeFiltrage.dart';
import '../models/ApiHotels&Sellers.dart';
import 'carousel.dart';
import 'MoteurRenMobile.dart';
import 'headerContainer.dart';
import 'menu.dart';

class HotelsPage extends StatefulWidget {
  /*  HotelsPage({
    super.key,
    required this.pro,
   
  });
  int counter;
  bool showContainer; */
  @override
  _HotelsPageState createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  final PagingController<int, Hotels> _pagingController =
      PagingController(firstPageKey: 0);
  List<Hotels> _data = [];

  //late Hotels item;
  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey);
    });
    saveCheckInOutDates();
  }

  String Nbchambres = '';
  int numberOfDays = 0;
  String destination = '';
  String formattedCheckin = '';
  String formattedCheckout = '';
  Future<void> saveCheckInOutDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String checkin = prefs.getString('checkin') ?? '';
    String checkout = prefs.getString('checkout') ?? '';
    DateTime checkInDate = DateTime.parse(checkin);
    DateTime checkOutDate = DateTime.parse(checkout);
    destination = prefs.getString('destination') ?? '';
    formattedCheckin = DateFormat('dd/MM/yyyy').format(DateTime.parse(checkin));
    formattedCheckout =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(checkout));
    //  prefs.setString('checkout', '$checkOutDate');
    numberOfDays = checkOutDate.difference(checkInDate).inDays;
    print('numberOfDays$numberOfDays');
    Nbchambres = prefs.getString('chambre') ?? '';
  }

  String inputValue = '';
  List<Hotels> filteredHotels = [];
  bool Rating = false;
  bool name = false;
  bool prix = false;
  bool view = true;

  bool showContainer = false;
//verification
  bool isEXist = false;
  int counter = 0;
  Future<void> verifier(Hotels item) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? existingFavourites = prefs.getStringList('Favouris') ?? [];
    String itemHotelJson = json.encode(item.toJson());

    if (existingFavourites.contains(itemHotelJson)) {
      isEXist = true;
    }
  }

//verification
  //int lenghtList=0;
  bool isExtraFeatures = true;
  Color favoriteColor = Color.fromARGB(255, 183, 183, 182);
  RangeValues _selectedPriceRange = RangeValues(0, 100);
  // Valeurs de prix sélectionnées
  Future<void> filtreByPrix(int minprix, int maxprix) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> hotelsJsonList = prefs.getStringList('products') ?? [];

    final hotelsList = hotelsJsonList
        .map((hotelJson) => Hotels.fromJson(json.decode(hotelJson)))
        .toList();
    //filteredHotels.clear();
    List<Hotels> filteredHotelsName = [];

    for (Hotels hotelSeller in hotelsList) {
      filteredHotels =
          hotelSeller.filterHotelsByPrix(hotelsList, minprix, maxprix).toList();

      if (filteredHotels.isNotEmpty) {
        filteredHotels.addAll(filteredHotelsName);
        print('_data123$_data');

        // Réinitialiser le PagingController

        // Fetch new data

        setState(() {});
        Rating = false;
        view = false;
        name = false;
        prix = true;
      }
    }
  }

  Future<void> filtreByRating(double rating) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> hotelsJsonList = prefs.getStringList('products') ?? [];

    final hotelsList = hotelsJsonList
        .map((hotelJson) => Hotels.fromJson(json.decode(hotelJson)))
        .toList();
    //filteredHotels.clear();
    List<Hotels> filteredHotelsSellers = [];

    for (Hotels hotelSeller in hotelsList) {
      filteredHotels = hotelSeller
          .filterHotelsByRating(hotelsList, rating.toString())
          .toList();

      if (filteredHotels.isNotEmpty) {
        filteredHotels.addAll(filteredHotelsSellers);
        print('_data123$_data');

        List<String> productsJsonList = filteredHotels
            .map((product) => json.encode(product.toJson()))
            .toList();
        List<String> hotelsSessionList =
            prefs.getStringList('productsFiltrer') ?? [];
        if (hotelsSessionList.isNotEmpty) {
          prefs.remove('productsFiltrer');
        }
        prefs.setStringList('productsFiltrer', productsJsonList);

        setState(() {
          name = false;
          view = false;
          Rating = true;
        });
      }
    }
  }

//end

  List<bool> favoriteStatusList = [];
  List<bool> isExtraFeaturesList = [];
  bool isFavorite = false;
  List<String> Fvouris = [];
  late List<String> hotelsJsonList;
  late int selectedFavoriteIndex;
  //get  iplocation and  ipTravelor
  /* Future<String> getLocationDescription(double latitude, double longitude) async {
  final coordinates = new Coordinates(latitude, longitude);
  final addresses = await GeocodingPlatform.instance.placemarkFromCoordinates(
    coordinates.latitude, coordinates.longitude);

  if (addresses.isNotEmpty) {
    final firstAddress = addresses.first;
    final description =
        '${firstAddress.country} - ${firstAddress.administrativeArea} - ${firstAddress.locality}';
    return description;
  }

  return 'Address not found';
} */

  String ipLocationForweb = '';

  Future<void> getCurrentLocationForweb() async {
    try {
      bool isGeolocationSupported = js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('geolocation');

      if (!isGeolocationSupported) {
        print(
            'La géolocalisation n\'est pas prise en charge par le navigateur.');
        return;
      }

      final position =
          await html.window.navigator.geolocation.getCurrentPosition();

      ipLocationForweb =
          '${position.coords!.latitude},${position.coords!.longitude}';
      print('ipLocationForweb: $ipLocationForweb');
      // Call your API creation method with the obtained values
      // createApiProduct(ipLocation, ipTraveler);
    } catch (e) {
      print('Erreur lors de l\'obtention de la localisation : $e');
    }
  } 
 
  Future<String> getIPAddress() async {
    try {
      var response =
          await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['ip'];
      } else {
        // Gérer les erreurs de requête
        return '';
      }
    } catch (e) {
      // Gérer les erreurs d'exception
      return '';
    }
  }

  String ipLocation = '';
  Future<void> getCurrentLocation() async {
    final geolocator = GeolocatorPlatform.instance;

    try {
      // Vérifier si la permission de localisation est accordée
      LocationPermission permission = await geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          print('Permission de localisation refusée');
          return;
        }
      }

      // Obtenir la position actuelle
      Position position = await geolocator.getCurrentPosition();

      // Utiliser la position pour l'envoyer à l'API
      ipLocation = '${position.latitude},${position.longitude}';
      print('iplocation$ipLocation');
      // Appeler la méthode de création de l'API avec les valeurs obtenues
      // createApiProduct(ipLocation, ipTraveler);
    } catch (e) {
      print('Erreur lors de l\'obtention de la localisation : $e');
    }
  }

  Future<void> filtreByName(String inputValue) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> hotelsJsonList = prefs.getStringList('products') ?? [];

    final hotelsList = hotelsJsonList
        .map((hotelJson) => Hotels.fromJson(json.decode(hotelJson)))
        .toList();
    //filteredHotels.clear();
    List<Hotels> filteredHotelsName = [];

    for (Hotels hotelSeller in hotelsList) {
      filteredHotels =
          hotelSeller.filterHotelsByName(hotelsList, inputValue).toList();

      if (filteredHotels.isNotEmpty) {
        //   filteredHotels.clear();
        filteredHotels.addAll(filteredHotelsName);
        print('_data123$_data');

        setState(() {
          Rating = false;
          view = false;
          name = true;
        });
        /*  setState(() {
       
    Rating = true;
  });
 */
        // _pagingController.refresh();
      }
    }
  }

  Future<void> _fetchData(int pageKey) async {
    final prefs = await SharedPreferences.getInstance();
    hotelsJsonList = prefs.getStringList('products') ?? [];
    final hotelsList = hotelsJsonList
        .map((hotelJson) => Hotels.fromJson(json.decode(hotelJson)))
        .toList();
    favoriteStatusList = List.generate(hotelsList.length, (index) => false);
    isExtraFeaturesList = List.generate(hotelsList.length, (index) => false);

    final lenghtList = hotelsList.length;

    print(lenghtList);
    print('filteredHotels456$filteredHotels');
    // Generate new data for the current page
    final startIndex = pageKey * 3;
    final endIndex = startIndex + 3;

    if (endIndex < hotelsList.length) {
      List<Hotels> newData = hotelsList.sublist(startIndex, endIndex);

      setState(() {
        _data.addAll(newData);
        print('added$startIndex');
      });

      final isLastPage = endIndex >= hotelsList.length;
      if (isLastPage) {
        _pagingController.appendLastPage(_data);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newData, nextPageKey);
      }
    }
  }

//apiProductClick
  String HotelName = '';
  int apiCode = 0;
  String HotelId = '';
  Future<void> createApiProduct() async {
    final url =
        Uri.parse('http://user3-market.3t.tn/api/product/newApiProduct');
    final headers = {'Content-Type': 'application/json'};
    String ipTraveler = await getIPAddress();

    final body = jsonEncode({
      "name": HotelName.toString(),
      "productType": 19,
      "api": apiCode,
      "idProductFromApi": HotelId,
      "apiProductClick": {
        "ipLocation": ipLocationForweb,
        "ipTraveler": ipTraveler
      }
    });
    print('Body$body');
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        // Requête réussie, le produit a été créé avec succès
        print('Produit créé avec succès');
      } else {
        // La requête a échoué
        print('Erreur lors de la création du produit : ${response.statusCode}');
      }
    } catch (e) {
      // Une erreur s'est produite lors de la requête
      print('Erreur : $e');
    }
  }

//end apiproductClick
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Responsive.isMobile(context)
            ? PreferredSize(
                preferredSize: Size.fromHeight(62.h),
                child: AppBar(
                  title: Container(
                    child: SafeArea(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Container(
                            child: Text(
                          '$destination',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        )),
                        Text(
                          '$formattedCheckin' + '-' + '$formattedCheckout ',
                          style:
                              TextStyle(color: Colors.black, fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Container(
                          width: 500,
                          height: 20.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                height: 10.h,
                                width: 90.w,
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      /*  boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // Décalage de l'ombre vers le bas
        ),
      ], */
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          //Icons.filter_list,
                                          Icons.tune,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          size: 20.sp,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Filters',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 60, 60, 60),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Container(
                                height: 10.h,
                                width: 150.w,
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      /*  boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // Décalage de l'ombre vers le bas
        ),
      ], */
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.black,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Price low to high',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 60, 60, 60),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Container(
                                height: 10.h,
                                width: 100.w,
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      /*  boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // Décalage de l'ombre vers le bas
        ),
      ], */
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Rating',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 60, 60, 60),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),

                              SizedBox(
                                width: 5.w,
                              ),
                              Container(
                                height: 10.h,
                                width: 100.w,
                                child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      /*  boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3), // Décalage de l'ombre vers le bas
        ),
      ], */
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.store,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Sellers',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              // Add more filter containers as needed
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      // Set the desired color for the back button
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Navigate back to the previous page
                    },
                  ),
                ))
            : null,
        backgroundColor: !Responsive.isDesktop(context)
            ? Color.fromARGB(255, 255, 255, 255)
            : null,
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(4, 4, 4, 1),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
            child: ListView(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                DrawerHeader(
                    child: Container(
                  child: Center(
                      child: Center(
                          child: Row(children: [
                    //   if(Responsive.isMobile(context))
                    Text(
                      "3T",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 255, 0, 0),
                        shadows: [
                          Shadow(
                            color: Colors.grey,
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 2.sp, right: 2.sp),
                      height: 20.h.h, // Adjust the height as needed
                      width:
                          3, // Set the width to define the separator line thickness
                      color: Color.fromARGB(
                          255, 0, 0, 0), // Set the color of the separator line
                    ),
                    Text(
                      'MarketPlace',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 0, 0, 0),
                        shadows: [
                          Shadow(
                            color: Colors.grey,
                            offset: Offset(2, 2),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    //  if(Responsive.isMobile(context))
                    /* Image.asset(
                    '../../android/app/src/assets/images/3TLOGO.png',
                    width: 200,
                    height: 22,
                  ),  */
                  ]))),
                )),
                MobMenu()
              ],
            ),
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //   if (Responsive.isDesktop(context))
              // if(MediaQuery.of(context).size.width > 1500 )
              /*   Expanded(
              flex: 2,
              child: Container(
                  width: 20.w,
                  height: 1000.h,
                  margin: EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                      left: MediaQuery.of(context).size.width > 1500
                          ? 170
                          : MediaQuery.of(context).size.width > 1200 &&
                                  MediaQuery.of(context).size.width < 1500
                              ? 80
                              : 40),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Filtrer By HotelName:',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: List.generate(
                              extraFilter.length,
                              (index) => Row(
                                children: [
                                  Checkbox(
                                    value: extraFilter[index]['is_selected'],
                                    onChanged: (e) {
                                      extraFilter[index]['is_selected'] =
                                          !extraFilter[index]['is_selected'];
                                      setState(() {});
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                  Text(
                                    extraFilter[index]['title'],
                                    style: GoogleFonts.roboto(
                                      textStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                        child:Text(
                              'Catégories',
                              style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                  fontSize: 25.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )),
                            TextButton(
                              onPressed: () {
                                // filtreByRating(1);
                                //   navigate();
                              },
                              child: RatingBar.builder(
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
                                  //print(rating);
                                  // filtreByRating(rating);
                                },
                                ignoreGestures: true,
                              ),
                              // SizedBox(width: 10),
                              /*   Text(
                                ' 1.0',
                                style: TextStyle(
                                  color: Color.fromARGB(145, 77, 55, 42),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ), */
                            ),
                            TextButton(
                              onPressed: () {
                                //   filtreByRating(2);
                              },
                              child: RatingBar.builder(
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
                                  //  filtreByRating(rating);
                                },
                                ignoreGestures: true,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                //    filtreByRating(3);
                              },
                              child: RatingBar.builder(
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
                                  //   filtreByRating(rating);
                                },
                                ignoreGestures: true,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                //    filtreByRating(4);
                              },
                              child: RatingBar.builder(
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
                                  //   filtreByRating(rating);
                                },
                                ignoreGestures: true,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                //  filtreByRating(5);
                              },
                              child: RatingBar.builder(
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
                                ignoreGestures: true,
                              ),
                            ),
                            //add some details

                            Column(
                              children: [
                                Center(child:
                                Text(
                                  'Filtrer By Price:',
                                  style: TextStyle(
                                    fontSize: 20,
                                     color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                RangeSlider(
                                  values: _selectedPriceRange,
                                  min: 0,
                                  max: 1000,
                                  divisions: 10,
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      _selectedPriceRange = values;
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '\$${_selectedPriceRange.start.toStringAsFixed(2)}'),
                                    Text(
                                        '\$${_selectedPriceRange.end.toStringAsFixed(2)}'),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Appliquer le filtre de prix
                                    // filterByPrice(_selectedPriceRange.start, _selectedPriceRange.end);
                                  },
                                  child: Text('Appliquer'),
                                ),
                              ],
                            )
                            //end
                          ],
                        ),

                        /*   RadioListTile(
                            title: Text('Option 1'),
                            value: 1,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          RadioListTile(
                            title: Text('Option 2'),
                            value: 2,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          RadioListTile(
                            title: Text('Option 3'),
                            value: 3,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ), */
                      ],
                    ),
                  )),
            ), */
              //   SizedBox(width: Responsive.isDesktop(context) ? 10 : 2),
              if (!Responsive.isMobile(context)) HeaderContainer(),
              // if (!Rating && !name)
              if (view)
                Expanded(
                  // flex:
                  child:

                      //             Container(
                      //               height: double.maxFinite,

                      PagedListView<int, Hotels>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Hotels>(
                      itemBuilder: (context, item, index) {
                        double ratingValue = double.parse(item.hotel.category);

                        // print('$index ,$response');

                        return Column(
                          children: [
                            if (index == 0)
                              /*  Container(
                          height: 300,
                         width: 2000,
                        margin: EdgeInsets.all(20),
              
                child:search2(), ), */

                              Container(
                                height: Responsive.isDesktop(context)
                                    ? 500.h
                                    : Responsive.isTablet(context)
                                        ? 420.h
                                        : null,
                                width: double.infinity,
                                child: Stack(

                                    // width: 2000,
                                    children: [
                                      // Container(height: 500,width: double.infinity,child: Carousel(),),

                                      Container(
                                        width: double.infinity,
                                        //height: Responsive.isDesktop(context) ? 700 : 400,
                                        height: Responsive.isMobile(context)
                                            ? null
                                            : 400.h,
                                        child: //SizedBox(width: 555,height: 500,)
                                            Responsive.isDesktop(context)
                                                ? Carousel()
                                                : null,
                                      ),
                                      Positioned(
                                        // top: 250,
                                        top: Responsive.isDesktop(context)
                                            ? 300.h
                                            : 5.h,
                                        bottom: 0.h,
                                        left: !Responsive.isDesktop(context)
                                            ? 1.h
                                            : 5.h,
                                        right: !Responsive.isDesktop(context)
                                            ? 1.h
                                            : 5.h,
                                        //left: ,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              width: 1200,
                                              //  height: 1000,
                                              height: !Responsive.isDesktop(
                                                      context)
                                                  ? 550.h
                                                  : Responsive.isTablet(context)
                                                      ? 400
                                                      : null,
                                              // margin: EdgeInsets.only(
                                              //     left: Responsive.isDesktop(context) ? 40 : 20),
                                              // Opacité de 50%// Couleur transparente avec une opacité de 50%

                                              //ajouter responsive moteur Recherche
                                              child: Responsive.isDesktop(
                                                      context)
                                                  ? MoteurWeb(
                                                      showContainer:
                                                          showContainer,
                                                      counter: counter,
                                                    )
                                                  : Responsive.isTablet(context)
                                                      ? MoteurMobile()
                                                      // : MoteurMobile(),
                                                      : null
                                              //child:search2(),
                                              ),
                                        ),
                                      ),
                                    ]),
                              ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index == 0 &&
                                      Responsive.isDesktop(context))
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          width: 20.w,
                                          height: 400.h,
                                          margin: EdgeInsets.only(
                                              top: 30,
                                              bottom: 20,
                                              left: MediaQuery.of(context)
                                                              .size
                                                              .width >=
                                                          900 &&
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width <
                                                          1000
                                                  ? 20
                                                  : MediaQuery.of(context)
                                                                  .size
                                                                  .width >=
                                                              1000 &&
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width <
                                                              1300
                                                      ? 30
                                                      : MediaQuery.of(context)
                                                                      .size
                                                                      .width >=
                                                                  1400 &&
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width <
                                                                  2000
                                                          ? 130
                                                          : 70),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Filter By HotelName:',
                                                  style: GoogleFonts.roboto(
                                                    textStyle: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ),
                                                /* Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon:
                                                            Icon(Icons.search),
                                                        onPressed: () {
                                                          filtreByName(
                                                              inputValue);
                                                          print(inputValue);
                                                        },
                                                      ),
                                                      Expanded(
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            print('hhhh');
                                                            setState(() {
                                                              inputValue =
                                                                  value;
                                                            });
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                'Write the Name of hotel',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ), */
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      /* Container(
        height: 20.h,
        decoration: BoxDecoration(
        border: Border.all(
      color: Color.fromARGB(255, 126, 126, 126),
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(25),),
       // color: Color.fromARGB(255, 191, 191, 191),
        child:IconButton(
        icon: Icon(Icons.search,color: Colors.black,),
        onPressed: () {
          filtreByName(inputValue);
          print(inputValue);
        },
      ),)
      , */
                                                      Expanded(
                                                        child: TextField(
                                                          onChanged: (value) {
                                                            print('hhhh');
                                                            setState(() {
                                                              inputValue =
                                                                  value;
                                                            });
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Write the Name of hotel',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60.0), // Arrondir les coins
                                                            ),
                                                            prefixIcon:
                                                                IconButton(
                                                              icon: Icon(
                                                                Icons.search,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              onPressed: () {
                                                                filtreByName(
                                                                    inputValue);
                                                                print(
                                                                    inputValue);
                                                              },
                                                            ), // Ajouter l'icône de recherche
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 8.0),
                                                // Text(
                                                //   'Valeur saisie : $inputValue',
                                                //   style: TextStyle(fontSize: 16.0),
                                                // ),
                                                /*  Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Column(
                                                  children: List.generate(
                                                    extraFilter.length,
                                                    (index) => Row(
                                                      children: [
                                                        Checkbox(
                                                          value: extraFilter[
                                                                  index]
                                                              ['is_selected'],
                                                          onChanged: (e) {
                                                            extraFilter[index][
                                                                    'is_selected'] =
                                                                !extraFilter[
                                                                        index][
                                                                    'is_selected'];
                                                            setState(() {});
                                                          },
                                                          activeColor:
                                                              Colors.blue,
                                                        ),
                                                        Text(
                                                          extraFilter[index]
                                                              ['title'],
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ), */

                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Rating',
                                                      style: GoogleFonts.roboto(
                                                        textStyle: TextStyle(
                                                          fontSize: 25.sp,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        filtreByRating(1);
                                                      },
                                                      child: RatingBar.builder(
                                                        initialRating: 1,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 30.0,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Color.fromARGB(
                                                              255, 255, 183, 2),
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          //print(rating);
                                                          // filtreByRating(rating);
                                                        },
                                                        ignoreGestures: true,
                                                      ),
                                                      // SizedBox(width: 10),
                                                      /*   Text(
                                ' 1.0',
                                style: TextStyle(
                                  color: Color.fromARGB(145, 77, 55, 42),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ), */
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        filtreByRating(2);
                                                      },
                                                      child: RatingBar.builder(
                                                        initialRating: 2,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 30.0,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Color.fromARGB(
                                                              255, 255, 183, 2),
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          print(rating);
                                                          //  filtreByRating(rating);
                                                        },
                                                        ignoreGestures: true,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        filtreByRating(3);
                                                      },
                                                      child: RatingBar.builder(
                                                        initialRating: 3,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 30.0,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Color.fromARGB(
                                                              255, 255, 183, 2),
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          print(rating);
                                                          //   filtreByRating(rating);
                                                        },
                                                        ignoreGestures: true,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        filtreByRating(4);
                                                      },
                                                      child: RatingBar.builder(
                                                        initialRating: 4,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 30.0,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Color.fromARGB(
                                                              255, 255, 183, 2),
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          print(rating);
                                                          //   filtreByRating(rating);
                                                        },
                                                        ignoreGestures: true,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        filtreByRating(5);
                                                      },
                                                      child: RatingBar.builder(
                                                        initialRating: 5,
                                                        minRating: 1,
                                                        direction:
                                                            Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 30.0,
                                                        itemBuilder:
                                                            (context, _) =>
                                                                Icon(
                                                          Icons.star,
                                                          color: Color.fromARGB(
                                                              255, 255, 183, 2),
                                                        ),
                                                        onRatingUpdate:
                                                            (rating) {
                                                          print(rating);
                                                        },
                                                        ignoreGestures: true,
                                                      ),
                                                    ),
                                                    //add some details

                                                    Column(
                                                      children: [
                                                        Center(
                                                            child: Text(
                                                          'Filter By Price:',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )),
                                                        RangeSlider(
                                                          values:
                                                              _selectedPriceRange,
                                                          min: 0,
                                                          max: 1000,
                                                          divisions: 10,
                                                          activeColor:
                                                              Colors.black,
                                                          inactiveColor:
                                                              Colors.black,
                                                          onChanged:
                                                              (RangeValues
                                                                  values) {
                                                            setState(() {
                                                              _selectedPriceRange =
                                                                  values;
                                                            });
                                                          },
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'TND+'
                                                              '${_selectedPriceRange.start.toStringAsFixed(2)}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Text(
                                                                'TND+'
                                                                '${_selectedPriceRange.end.toStringAsFixed(2)}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                          ],
                                                        ),
                                                        /*  Container(
                                                          //color: Colors.black,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              int startPrice =
                                                                  _selectedPriceRange
                                                                      .start
                                                                      .toInt();
                                                              print(
                                                                  'startPrice$startPrice');
                                                              int endPrice =
                                                                  _selectedPriceRange
                                                                      .end
                                                                      .toInt();
                                                              print(
                                                                  'endPrice$endPrice');
                                                              filtreByPrix(
                                                                  startPrice,
                                                                  endPrice);
                                                              // Appliquer le filtre de prix
                                                              // filterByPrice(_selectedPriceRange.start, _selectedPriceRange.end);
                                                            },
                                                            child: Text(
                                                              'Appliquer',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ) */
                                                        Container(
                                                          //color: Colors.black,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              int startPrice =
                                                                  _selectedPriceRange
                                                                      .start
                                                                      .toInt();
                                                              print(
                                                                  'startPrice$startPrice');
                                                              int endPrice =
                                                                  _selectedPriceRange
                                                                      .end
                                                                      .toInt();
                                                              print(
                                                                  'endPrice$endPrice');
                                                              filtreByPrix(
                                                                  startPrice,
                                                                  endPrice);
                                                              // Appliquer le filtre de prix
                                                              // filterByPrice(_selectedPriceRange.start, _selectedPriceRange.end);
                                                            },
                                                            child: Text(
                                                              'Appliquer',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary: Colors
                                                                  .black, // Modifier la couleur du bouton en noir
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                    //end
                                                  ],
                                                ),

                                                /*   RadioListTile(
                            title: Text('Option 1'),
                            value: 1,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          RadioListTile(
                            title: Text('Option 2'),
                            value: 2,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          RadioListTile(
                            title: Text('Option 3'),
                            value: 3,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ), */
                                              ],
                                            ),
                                          )),
                                    ),
                                  SizedBox(
                                    width:
                                        Responsive.isMobile(context) ? 0 : 5.w,
                                  ),

                                  //   Text('$lenghtList Hôtel(s) trouvé(s)'),
                                  Expanded(
                                      flex: index != 0 &&
                                              Responsive.isDesktop(context)
                                          ? 2
                                          : 0,
                                      child: Container()),
                                  //  if(Responsive.isDesktop(context) || !Responsive.isDesktop(context))

                                  Expanded(
                                      flex: Responsive.isDesktop(context)
                                          ? 4
                                          : 10,
                                      child: Container(
                                          //  height: 450.h,
                                          height: Responsive.isDesktop(context)
                                              ? 400.h
                                              : MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      360
                                                  ? 350.h
                                                  : 400.h,
                                          margin: EdgeInsets.only(
                                              bottom:
                                                  Responsive.isDesktop(context)
                                                      ? 5
                                                      : 7,
                                              top: 30,
                                              right:
                                                  Responsive.isMobile(context)
                                                      ? 3
                                                      : 0,
                                              left: Responsive.isMobile(context)
                                                  ? 3
                                                  : 0),
                                          padding: EdgeInsets.all(
                                              Responsive.isDesktop(context)
                                                  ? 8
                                                  : 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(9),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                        255, 66, 64, 64)
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              //affichage de Mobile
                                              if (!Responsive.isDesktop(
                                                  context))
                                                Expanded(
                                                  flex: 10,
                                                  child: Stack(
                                                    children: [
                                                      // L'image à afficher

                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.network(
                                                          item.hotel.picture,
                                                          fit: BoxFit.cover,
                                                          height:
                                                              double.maxFinite,
                                                          width:
                                                              double.maxFinite,
                                                        ),
                                                      ),
                                                      if (ratingValue > 2)
                                                        Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      238,
                                                                      16,
                                                                      0),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .whatshot,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 16,
                                                                ),
                                                                SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  'Hot Rate',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
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
                                                          onTap: () async {
                                                            final prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            List<String>?
                                                                existingFavourites =
                                                                prefs.getStringList(
                                                                        'Favouris') ??
                                                                    [];
                                                            String
                                                                itemHotelJson =
                                                                json.encode(item
                                                                    .toJson());

                                                            if (existingFavourites
                                                                .contains(
                                                                    itemHotelJson)) {
                                                              /*  await verifier(
                                                                    item); */
                                                              //isEXist = true;
                                                              // L'élément existe déjà dans la liste, le supprimer du local storage
                                                              existingFavourites
                                                                  .remove(
                                                                      itemHotelJson);
                                                              prefs.setStringList(
                                                                  'Favouris',
                                                                  existingFavourites);
                                                              print(
                                                                  'Élément supprimé du local storage');
                                                            } else {
                                                              // L'élément n'existe pas dans la liste, l'ajouter au local storage
                                                              existingFavourites
                                                                  .add(
                                                                      itemHotelJson);
                                                              prefs.setStringList(
                                                                  'Favouris',
                                                                  existingFavourites);
                                                              print(
                                                                  'Élément ajouté au local storage');
                                                            }

                                                            setState(() {
                                                              isFavorite =
                                                                  !isFavorite;
                                                              selectedFavoriteIndex =
                                                                  index;
                                                              favoriteStatusList[
                                                                      index] =
                                                                  !favoriteStatusList[
                                                                      index];
                                                            });
                                                          },
                                                          child: Icon(
                                                            favoriteStatusList[
                                                                    index]
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            size: 30,
                                                            color:
                                                                favoriteStatusList[
                                                                        index]
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              SizedBox(
                                                height: 2.h,
                                              ),
                                              if (!Responsive.isDesktop(
                                                  context))
                                                Expanded(
                                                  flex: 11,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? 15.sp
                                                            : 1.sp),
                                                    child: Column(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          ' ${item.hotel.hotelName}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 18.sp,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    128,
                                                                    128,
                                                                    128),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 6.h
                                                                : 1.h),
                                                        if (!Responsive
                                                            .isDesktop(context))
                                                          Row(
                                                            children: [
                                                              RatingBar.builder(
                                                                initialRating:
                                                                    ratingValue,
                                                                minRating: 1,
                                                                direction: Axis
                                                                    .horizontal,
                                                                allowHalfRating:
                                                                    true,
                                                                itemCount: 5,
                                                                itemSize:
                                                                    20.0.sp,
                                                                itemBuilder:
                                                                    (context,
                                                                            _) =>
                                                                        Icon(
                                                                  Icons.star,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          183,
                                                                          2),
                                                                ),
                                                                onRatingUpdate:
                                                                    (rating) {
                                                                  print(rating);
                                                                },
                                                                ignoreGestures:
                                                                    true,
                                                              ),
                                                              SizedBox(
                                                                width: 10.w,
                                                              ),
                                                              Container(
                                                                height: 30
                                                                    .h, // Adjust the height as needed
                                                                width:
                                                                    2, // Set the width to define the separator line thickness
                                                                color: Colors
                                                                    .grey, // Set the color of the separator line
                                                              ),
                                                              SizedBox(
                                                                width: 10.w,
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .location_on,
                                                                        size: 20
                                                                            .sp,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            6,
                                                                            6,
                                                                            6),
                                                                      ),
                                                                      Text(
                                                                        '${item.hotel.location.toString()}',
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          textStyle:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17.sp,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              )
                                                            ],
                                                          ),
                                                        //add here
                                                        Text(
                                                          '$ratingValue-starHotel',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),

                                                        if (!Responsive
                                                            .isDesktop(context))
                                                          Text(
                                                            'For $Nbchambres room(s) x $numberOfDays night(s)',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Free ',
                                                              style: TextStyle(
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        95,
                                                                        95,
                                                                        95),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 5.w),
                                                            Icon(
                                                              Icons.wifi,
                                                              size: 18.sp,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      95,
                                                                      95,
                                                                      95),
                                                            ),
                                                          ],
                                                        ),
                                                        if (!Responsive
                                                            .isDesktop(context))
                                                          Container(
                                                            height: 50.h,
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Row(
                                                                children: item
                                                                    .sellers
                                                                    .map((seller) =>
                                                                        Container(
                                                                          width: Responsive.isMobile(context)
                                                                              ? 300
                                                                              : 350, // Largeur fixe pour chaque élément
                                                                          margin:
                                                                              EdgeInsets.only(right: 5.w),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              ClipOval(
                                                                                child: Image.network(
                                                                                  'http://user3-market.3t.tn/getImages?filename=${seller.sellerData.brochureFilename}',
                                                                                  fit: BoxFit.cover,
                                                                                  width: 50,
                                                                                  height: 50,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: Responsive.isDesktop(context) ? 35 : 5.w),
                                                                              RichText(
                                                                                text: TextSpan(
                                                                                  text: 'From  ',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                    fontSize: 15.sp,
                                                                                  ),
                                                                                  children: <TextSpan>[
                                                                                    TextSpan(
                                                                                      text: seller.prixSeller + ' TND',
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 18.sp,
                                                                                        foreground: Paint()
                                                                                          ..shader = LinearGradient(
                                                                                            colors: [
                                                                                              Color.fromARGB(255, 7, 7, 7),
                                                                                              Color.fromARGB(255, 243, 22, 22)
                                                                                            ],
                                                                                            begin: Alignment.topLeft,
                                                                                            end: Alignment.bottomRight,
                                                                                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Spacer(),
                                                                              Align(
                                                                                alignment: Alignment.centerRight,
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    elevation: 2,
                                                                                    backgroundColor: Color.fromARGB(255, 252, 252, 252),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                                    ),
                                                                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    HotelName = item.hotel.hotelName;
                                                                                    apiCode = seller.sellerData.api.id;
                                                                                    HotelId = item.hotel.hotelId;
                                                                                    print('hotelnameclicked${item.hotel.hotelName}');
                                                                                    await getCurrentLocation();
                                                                                    await createApiProduct();
                                                                                    var url = seller.detailsLink;
                                                                                    if (await canLaunch(url)) {
                                                                                      await launch(url);
                                                                                    } else {
                                                                                      throw 'Impossible d\'ouvrir $url';
                                                                                    }
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.visibility,
                                                                                    size: 24.sp,
                                                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                              //                                               AnimatedSize(
                                              //                                                 duration: const Duration(
                                              //                                                     milliseconds: 600),
                                              //                                                 curve: Curves.ease,
                                              //                                                 child: Container(
                                              //                                                   height: isExtraFeatures
                                              //                                                       ? null
                                              //                                                       : 45,

                                              //                                                   /*   padding: const EdgeInsets
                                              //                                                         .symmetric(
                                              //                                                     horizontal: 10), */
                                              //                                                   decoration: BoxDecoration(
                                              //                                                     boxShadow: [
                                              //                                                       BoxShadow(
                                              //                                                         color: Color.fromARGB(
                                              //                                                             255,
                                              //                                                             156,
                                              //                                                             156,
                                              //                                                             156),
                                              //                                                         offset: Offset(0,
                                              //                                                             2), // Décalage vertical de l'ombre
                                              //                                                         blurRadius:
                                              //                                                             2, // Rayon de flou de l'ombre
                                              //                                                       ),
                                              //                                                     ],
                                              //                                                     color: Color(0xFFF7F7FA),
                                              //                                                     borderRadius:
                                              //                                                         BorderRadius.all(
                                              //                                                       Radius.circular(15),
                                              //                                                     ),
                                              //                                                   ),
                                              //                                                   child: Column(
                                              //                                                     mainAxisAlignment:
                                              //                                                         MainAxisAlignment
                                              //                                                             .start,
                                              //                                                     crossAxisAlignment:
                                              //                                                         CrossAxisAlignment
                                              //                                                             .start,
                                              //                                                     children: [
                                              //                                                       GestureDetector(
                                              //                                                         onTap: () {
                                              //                                                           isExtraFeatures =
                                              //                                                               !isExtraFeatures;
                                              //                                                           /*  isExtraFeaturesList[
                                              //                                                                 index] =
                                              //                                                             !isExtraFeaturesList[
                                              //                                                                 index]; */

                                              //                                                           setState(() {});
                                              //                                                         },
                                              //                                                         child: Container(
                                              //                                                           // height: double.maxFinite,

                                              //                                                           color: Colors
                                              //                                                               .transparent,
                                              //                                                           padding:
                                              //                                                               EdgeInsets.only(
                                              //                                                             top: 15,
                                              //                                                             left: 10,
                                              //                                                             right: 10,
                                              //                                                           ),
                                              //                                                           child: Row(
                                              //                                                             mainAxisAlignment:
                                              //                                                                 MainAxisAlignment
                                              //                                                                     .spaceBetween,
                                              //                                                             children: [
                                              //                                                               Text(
                                              //                                                                 'View All Sellers ',
                                              //                                                                 style:
                                              //                                                                     GoogleFonts
                                              //                                                                         .roboto(
                                              //                                                                   textStyle:
                                              //                                                                       TextStyle(
                                              //                                                                     fontSize:
                                              //                                                                         20.sp,
                                              //                                                                     fontWeight:
                                              //                                                                         FontWeight
                                              //                                                                             .bold,
                                              //                                                                     color: Colors
                                              //                                                                         .black,
                                              //                                                                     fontStyle:
                                              //                                                                         FontStyle
                                              //                                                                             .italic,
                                              //                                                                   ),
                                              //                                                                 ),
                                              //                                                               ),
                                              //                                                               RotatedBox(
                                              //                                                                 quarterTurns:
                                              //                                                                     isExtraFeatures
                                              //                                                                         ? 25
                                              //                                                                         : 0,
                                              //                                                                 child: Icon(
                                              //                                                                   Icons
                                              //                                                                       .arrow_forward_ios,
                                              //                                                                   size: 15.sp,
                                              //                                                                 ),
                                              //                                                               ),
                                              //                                                             ],
                                              //                                                           ),
                                              //                                                         ),
                                              //                                                       ),
                                              //                                                       if (isExtraFeatures)
                                              //                                                         Container(
                                              //                                                           //  height: 200.h,
                                              //                                                           height: 200.h,

                                              //                                                           width: double
                                              //                                                               .maxFinite, // Set a fixed height for the SingleChildScrollView
                                              //                                                           child:
                                              //                                                               SingleChildScrollView(

                                              //                                                             child: Column(
                                              //                                                               children: item
                                              //                                                                   .sellers
                                              //                                                                   .map(
                                              //                                                                       (seller) =>
                                              //                                                                           Row(
                                              //                                                                             children: [
                                              //                                                                               ClipOval(
                                              //                                                                                 child: Image.network(
                                              //                                                                                   'http://user3-market.3t.tn/getImages?filename=${seller.sellerData.brochureFilename}',
                                              //                                                                                   fit: BoxFit.cover,
                                              //                                                                                   width: 50,
                                              //                                                                                   height: 50,
                                              //                                                                                 ),
                                              //                                                                               ),
                                              //                                                                               SizedBox(width: Responsive.isDesktop(context) ? 35 : 5.w),
                                              //                                                                               /*  Text(
                                              //                                                                               'À partir de ' + seller.prixSeller +'TND',
                                              //                                                                               style:  TextStyle(
                                              //                                                                                 fontWeight: FontWeight.w300,
                                              //                                                                                 color: Colors.black,
                                              //                                                                                 fontSize: 18.sp,
                                              //                                                                               ),
                                              //                                                                             ), */
                                              //                                                                               RichText(
                                              //                                                                                 text: TextSpan(
                                              //                                                                                   text: 'À partir de ',
                                              //                                                                                   style: TextStyle(
                                              //                                                                                     fontWeight: FontWeight.bold,
                                              //                                                                                     color: Colors.black,
                                              //                                                                                     fontSize: 15.sp,
                                              //                                                                                   ),
                                              //                                                                                   children: <TextSpan>[
                                              //                                                                                     TextSpan(
                                              //                                                                                       text: seller.prixSeller + ' TND',
                                              //                                                                                       style: TextStyle(
                                              //                                                                                         fontWeight: FontWeight.bold,
                                              //                                                                                         fontSize: 18.sp,
                                              //                                                                                         // color: Colors.red,
                                              //                                                                                         foreground: Paint()
                                              //                                                                                           ..shader = LinearGradient(
                                              //                                                                                             colors: [
                                              //                                                                                               Color.fromARGB(255, 7, 7, 7),
                                              //                                                                                               Color.fromARGB(255, 243, 22, 22)
                                              //                                                                                             ], // Remplacez les couleurs par celles de votre choix
                                              //                                                                                             begin: Alignment.topLeft,
                                              //                                                                                             end: Alignment.bottomRight,
                                              //                                                                                           ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                              //                                                                                       ),
                                              //                                                                                     ),
                                              //                                                                                   ],
                                              //                                                                                 ),
                                              //                                                                               ),
                                              //                                                                               Spacer(),
                                              //                                                                               Align(
                                              //                                                                                 alignment: Alignment.centerRight,
                                              //                                                                                 child: ElevatedButton(
                                              //                                                                                   style: ElevatedButton.styleFrom(
                                              //                                                                                     elevation: 2,
                                              //                                                                                     backgroundColor: Color.fromARGB(255, 252, 252, 252),
                                              //                                                                                     shape: RoundedRectangleBorder(
                                              //                                                                                       borderRadius: BorderRadius.circular(10.0),
                                              //                                                                                     ),
                                              //                                                                                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                              //                                                                                   ),
                                              //                                                                                   onPressed: () async {
                                              //                                                                                     HotelName = item.hotel.hotelName;
                                              //                                                                                     apiCode = seller.sellerData.api.id;
                                              //                                                                                     HotelId = item.hotel.hotelId;
                                              //                                                                                     print('hotelnameclicked${item.hotel.hotelName}');
                                              //                                                                                     await getCurrentLocation();
                                              //                                                                                     await createApiProduct();
                                              //                                                                                     var url = seller.detailsLink;
                                              //                                                                                     if (await canLaunch(url)) {
                                              //                                                                                       await launch(url);
                                              //                                                                                     } else {
                                              //                                                                                       throw 'Impossible d\'ouvrir $url';
                                              //                                                                                     }
                                              //                                                                                     /*  Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => WebViewPage(url: seller.detailsLink),
                                              //   ),
                                              // ); */
                                              //                                                                                   },
                                              //                                                                                   child: Icon(
                                              //                                                                                     Icons.visibility,
                                              //                                                                                     size: 24.sp,
                                              //                                                                                     color: Color.fromARGB(255, 0, 0, 0),
                                              //                                                                                   ),
                                              //                                                                                   /* Text(
                                              //                                                                                   'Voir Offer',
                                              //                                                                                   style: GoogleFonts.roboto(
                                              //                                                                                     textStyle: TextStyle(
                                              //                                                                                       fontSize: 12,
                                              //                                                                                       fontWeight: FontWeight.bold,
                                              //                                                                                       color: Colors.black,
                                              //                                                                                       fontStyle: FontStyle.normal,
                                              //                                                                                     ),
                                              //                                                                                   ),
                                              //                                                                                 ), */
                                              //                                                                                 ),
                                              //                                                                               ),
                                              //                                                                               SizedBox(width: 5.w),
                                              //                                                                             ],
                                              //                                                                           ))
                                              //                                                                   .toList(),
                                              //                                                             ),
                                              //                                                           ),
                                              //                                                         ),
                                              //                                                     ],
                                              //                                                   ),
                                              //                                                 ),
                                              //                                               ),
                                              /*                   Container(
 height: 200.h,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: item.sellers.length,
    itemBuilder: (context, index) {
      final seller = item.sellers[index];
      return Row(
        children: [
          ClipOval(
            child: Image.network(
              'http://user3-market.3t.tn/getImages?filename=${seller.sellerData.brochureFilename}',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
          SizedBox(width: Responsive.isDesktop(context) ? 35 : 5.w),
          RichText(
            text: TextSpan(
              text: 'À partir de ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 15.sp,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: seller.prixSeller + ' TND',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Color.fromARGB(255, 7, 7, 7),
                          Color.fromARGB(255, 243, 22, 22)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 2,
                backgroundColor: Color.fromARGB(255, 252, 252, 252),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onPressed: () async {
                HotelName = item.hotel.hotelName;
                apiCode = seller.sellerData.api.id;
                HotelId = item.hotel.hotelId;
                print('hotelnameclicked${item.hotel.hotelName}');
                await getCurrentLocation();
                await createApiProduct();
                var url = seller.detailsLink;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Impossible d\'ouvrir $url';
                }
              },
              child: Icon(
                Icons.visibility,
                size: 24.sp,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          SizedBox(width: 5.w),
       ],
      );
    },
  ),
),
      */ //end affichage de Mobile

                                              //affichage desktop
                                              if (Responsive.isDesktop(context))
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex:
                                                          Responsive.isDesktop(
                                                                  context)
                                                              ? 2
                                                              : 10,
                                                      child: Stack(
                                                        children: [
                                                          // L'image à afficher

                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child:
                                                                Image.network(
                                                              item.hotel
                                                                  .picture,
                                                              fit: BoxFit.cover,
                                                              height: 300,
                                                              width: 500,
                                                            ),
                                                          ),
                                                          // ),
                                                          // Le bouton "favori"
                                                          if (ratingValue > 2)
                                                            Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              child: Container(
                                                                width: 30.w,
                                                                height: 40.h,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          238,
                                                                          16,
                                                                          0),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .whatshot,
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          20.sp,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      'Hot Rate',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20.sp,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                          Positioned(
                                                            top:
                                                                10, // Ajuster la position verticale selon vos besoins
                                                            right:
                                                                10, // Ajuster la position horizontale selon vos besoins
                                                            child: InkWell(
                                                              onTap: () async {
                                                                final prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                List<String>?
                                                                    existingFavourites =
                                                                    prefs.getStringList(
                                                                            'Favouris') ??
                                                                        [];
                                                                String
                                                                    itemHotelJson =
                                                                    json.encode(
                                                                        item.toJson());

                                                                if (existingFavourites
                                                                    .contains(
                                                                        itemHotelJson)) {
                                                                  /*  await verifier(
                                                                    item); */
                                                                  //isEXist = true;
                                                                  // L'élément existe déjà dans la liste, le supprimer du local storage
                                                                  existingFavourites
                                                                      .remove(
                                                                          itemHotelJson);
                                                                  prefs.setStringList(
                                                                      'Favouris',
                                                                      existingFavourites);
                                                                  print(
                                                                      'Élément supprimé du local storage');
                                                                } else {
                                                                  // L'élément n'existe pas dans la liste, l'ajouter au local storage
                                                                  existingFavourites
                                                                      .add(
                                                                          itemHotelJson);
                                                                  prefs.setStringList(
                                                                      'Favouris',
                                                                      existingFavourites);
                                                                  print(
                                                                      'Élément ajouté au local storage');
                                                                }

                                                                setState(() {
                                                                  isFavorite =
                                                                      !isFavorite;
                                                                  selectedFavoriteIndex =
                                                                      index;
                                                                  favoriteStatusList[
                                                                          index] =
                                                                      !favoriteStatusList[
                                                                          index];
                                                                });
                                                              },

                                                              /*    onTap: () async {
                                                              final prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                        

                                                              if (Fvouris !=
                                                                      null &&
                                                                      
                                                                  Fvouris.contains(
                                                                     json
                                                                    .decode( item.hotel.toJson())) ) {
                                                                print(
                                                                    'isExist');
                                                                    Fvouris.remove(item.hotel);
                                                               prefs.setStringList('Favouris', Fvouris);
                                                               print('Element supprimé du local storage');
                                                                // L'élément existe déjà dans la liste, ne pas ajouter
                                                              } else {
                                                                

                                                                prefs.setStringList(
                                                                    'Favouris',
                                                                    Fvouris);

                                                                Fvouris.add(json
                                                                    .encode(item
                                                                        .hotel
                                                                        .toJson()));
                                                                prefs.setStringList(
                                                                    'Favouris',
                                                                    Fvouris);
                                                              }

                                                              setState(() {
                                                                isFavorite =
                                                                    !isFavorite;
                                                                selectedFavoriteIndex =
                                                                    index;
                                                                if (selectedFavoriteIndex ==
                                                                    index) {
                                                                  print(item);
                                                                }
                                                                favoriteStatusList[
                                                                        index] =
                                                                    !favoriteStatusList[
                                                                        index];
                                                              });
                                                            },  */
                                                              /* onTap: () async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingFavourites = prefs.getStringList('Favouris');

  if (existingFavourites != null && existingFavourites.contains(item.hotel)) {
    // Element exists in the list, remove it from local storage
    existingFavourites.remove(item.hotel);
    prefs.setStringList('Favouris', existingFavourites);
    print('Element removed from local storage');
  } else {
    // Element doesn't exist in the list, add it to local storage
    existingFavourites ??= [];
    existingFavourites.add(json
                                                                    .encode(item.hotel.toJson()));
    prefs.setStringList('Favouris', existingFavourites);
    print('Element added to local storage');
  }

  setState(() {
    isFavorite = !isFavorite;
    selectedFavoriteIndex = index;
    favoriteStatusList[index] = !favoriteStatusList[index];
  });
},
 */
                                                              child: Icon(
                                                                favoriteStatusList[
                                                                        index]
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border,
                                                                size: 30,
                                                                color: favoriteStatusList[
                                                                        index]
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (Responsive.isDesktop(
                                                        context))
                                                      Expanded(
                                                        flex: Responsive
                                                                .isDesktop(
                                                                    context)
                                                            ? 3
                                                            : 10,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15.h),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                ' ${item.hotel.hotelName}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 5.h),
                                                              if (Responsive
                                                                  .isDesktop(
                                                                      context))
                                                                Row(
                                                                  children: [
                                                                    RatingBar
                                                                        .builder(
                                                                      initialRating:
                                                                          ratingValue,
                                                                      minRating:
                                                                          1,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          true,
                                                                      itemCount:
                                                                          5,
                                                                      itemSize:
                                                                          30.0,
                                                                      itemBuilder:
                                                                          (context, _) =>
                                                                              Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            183,
                                                                            2),
                                                                      ),
                                                                      onRatingUpdate:
                                                                          (rating) {
                                                                        print(
                                                                            rating);
                                                                      },
                                                                      ignoreGestures:
                                                                          true,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          50, // Adjust the height as needed
                                                                      width:
                                                                          1, // Set the width to define the separator line thickness
                                                                      color: Colors
                                                                          .grey, // Set the color of the separator line
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Container(
                                                                      child: Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.location_on,
                                                                              size: 30,
                                                                            ),
                                                                            Text(
                                                                              '${item.hotel.location.toString()}',
                                                                              style: GoogleFonts.roboto(
                                                                                textStyle: TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                                                  fontStyle: FontStyle.italic,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    )
                                                                  ],
                                                                ),
                                                              SizedBox(
                                                                  height: 10.h),
                                                              if (Responsive
                                                                  .isDesktop(
                                                                      context))
                                                                Text(
                                                                  'For $Nbchambres room(s) x $numberOfDays night(s)',
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    textStyle: TextStyle(
                                                                        fontSize: 20
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .normal,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              SizedBox(
                                                                  height: 5.h),
                                                              AnimatedSize(
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            600),
                                                                curve:
                                                                    Curves.ease,
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      isExtraFeatures
                                                                          ? null
                                                                          : 45,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            156,
                                                                            156,
                                                                            156),
                                                                        offset: Offset(
                                                                            0,
                                                                            2), // Décalage vertical de l'ombre
                                                                        blurRadius:
                                                                            2, // Rayon de flou de l'ombre
                                                                      ),
                                                                    ],
                                                                    color: Color(
                                                                        0xFFF7F7FA),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          15),
                                                                    ),
                                                                  ),

                                                                  /*  margin: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          30), */
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  /*   decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF7F7FA),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          15),
                                                                    ),
                                                                  ), */
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          isExtraFeatures =
                                                                              !isExtraFeatures;
                                                                          //  isExtraFeaturesList[index] = !isExtraFeaturesList[index];
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.transparent,
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            top:
                                                                                15,
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10,
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                'View All Sellers ',
                                                                                style: GoogleFonts.roboto(
                                                                                  textStyle: TextStyle(
                                                                                    fontSize: 20.sp,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                    fontStyle: FontStyle.italic,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              RotatedBox(
                                                                                quarterTurns: isExtraFeatures ? 25 : 0,
                                                                                child: Icon(
                                                                                  Icons.arrow_forward_ios,
                                                                                  size: 15.sp,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      if (isExtraFeatures)
                                                                        Container(
                                                                          height:
                                                                              200.h,
                                                                          width:
                                                                              double.maxFinite, // Set a fixed height for the SingleChildScrollView
                                                                          // Set a fixed height for the SingleChildScrollView
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              children: item.sellers
                                                                                  .map((seller) => Row(
                                                                                        children: [
                                                                                          ClipOval(
                                                                                            child: Image.network(
                                                                                              'http://user3-market.3t.tn/getImages?filename=${seller.sellerData.brochureFilename}',
                                                                                              fit: BoxFit.cover,
                                                                                              width: 50,
                                                                                              height: 50,
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(width: 2.w),
                                                                                          /*  Text(
                                                                                            'À partir de ' + seller.prixSeller + 'TND',
                                                                                            style: const TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.black,
                                                                                              fontSize: 18,
                                                                                            ),
                                                                                          ), */
                                                                                          RichText(
                                                                                            text: TextSpan(
                                                                                              text: 'From  ',
                                                                                              style: TextStyle(
                                                                                                fontWeight: FontWeight.bold,
                                                                                                color: Colors.black,
                                                                                                fontSize: 15.sp,
                                                                                              ),
                                                                                              children: <TextSpan>[
                                                                                                TextSpan(
                                                                                                  text: seller.prixSeller + ' TND',
                                                                                                  style: TextStyle(
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontSize: 18.sp,
                                                                                                    // color: Colors.red,
                                                                                                    foreground: Paint()
                                                                                                      ..shader = LinearGradient(
                                                                                                        colors: [
                                                                                                          Color.fromARGB(255, 7, 7, 7),
                                                                                                          Color.fromARGB(255, 243, 22, 22)
                                                                                                        ], // Remplacez les couleurs par celles de votre choix
                                                                                                        begin: Alignment.topLeft,
                                                                                                        end: Alignment.bottomRight,
                                                                                                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Spacer(),
                                                                                          Align(
                                                                                            alignment: Alignment.centerRight,
                                                                                            child: ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                elevation: 2,
                                                                                                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                                ),
                                                                                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                                                                                              ),
                                                                                              onPressed: () async {
                                                                                                HotelName = item.hotel.hotelName;
                                                                                                apiCode = seller.sellerData.api.id;
                                                                                                HotelId = item.hotel.hotelId;

                                                                                                print('hotelnameclicked${item.hotel.hotelName}');
                                                                                                  await getCurrentLocationForweb();
                                                                                                await createApiProduct();
                                                                                                var url = seller.detailsLink;
                                                                                                if (await canLaunch(url)) {
                                                                                                  await launch(url);
                                                                                                } else {
                                                                                                  throw 'Impossible d\'ouvrir $url';
                                                                                                }
                                                                                                /* Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebViewPage(url: seller.detailsLink),
    ),
  ); */
                                                                                              },
                                                                                              /*  child: Text(
                                                                                                'Voir Offer',
                                                                                                style: GoogleFonts.roboto(
                                                                                                  textStyle: TextStyle(
                                                                                                    fontSize: 12,
                                                                                                    color: Colors.black,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontStyle: FontStyle.normal,
                                                                                                  ),
                                                                                                ),
                                                                                              ), */
                                                                                              child: Icon(
                                                                                                Icons.visibility,
                                                                                                size: 24.sp,
                                                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(width: 3.w),
                                                                                        ],
                                                                                      ))
                                                                                  .toList(),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

// Assuming you have a list of products called 'products'

                                                              /*  Text(
  'Price: ${hotel.hotel.lowPrice.toString()}  ${hotel.hotel.currency.toString()}',
  presetFontSizes: [20, 16, 12], // Liste des tailles de police pour différentes tailles d'écran
  style: GoogleFonts.roboto(
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    ),
  ),
), */

                                                              /*  Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    'http://user3-market.3t.tn/getImages?filename=${hotel.hotelData.category}',
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                Text(
                                                  'hotel.seller!.name.toString()',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ), */

                                                              SizedBox(
                                                                  height: 10.h),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              /*  Expanded(
                                  child: Row(
                                    children: hotel.seller
                                        .map((seller) => Column(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    'http://user3-market.3t.tn/getImages?filename=${seller.brochureFilename}',
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                ),
                                                SizedBox(width: 35),
                                                Text(
                                                  seller.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation:
                                                        5, // hauteur de l'élévation
                                                    backgroundColor: Color.fromARGB(
                                                        255,
                                                        18,
                                                        111,
                                                        249), // couleur de fond
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1.0),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            horizontal:
                                                                16), // padding
                                                  ),
                                                  onPressed: () async {
                                                    var url =
                                                        hotel.hotel.detailsLink;

                                                    // ignore: deprecated_member_use
                                                    if (await canLaunch(url)) {
                                                      await launch(url);
                                                    } else {
                                                      throw 'Impossible d\'ouvrir $url';
                                                    }
                                                  },
                                                  child: Text(
                                                    'Voir Offer',
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ), */
                                              SizedBox(
                                                width: 35,
                                              ),
                                            ],
                                          ))),
                                  SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width >=
                                                      900 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1200
                                              ? 2.w
                                              : (!Responsive.isDesktop(context))
                                                  ? 0
                                                  : 40.w),
                                  //   if (Responsive.isDesktop(context))
                                  // if (MediaQuery.of(context).size.width > 1500)

                                  /*  Expanded(
              flex: Responsive.isDesktop(context) ? 1 : 0,
              child: Container(
              
               // margin: EdgeInsets.only(top: 50, bottom: 50, left: 170),
               // padding: const EdgeInsets.all(10),
              ),
            ), */
                                ])
                          ],
                        );
                      },
                    ),
                  ),
                ),
              //ajouter footer
              if (!Responsive.isDesktop(context) && view)
                Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              // Action à effectuer lorsqu'on appuie sur l'icône
                              Navigator.pushNamed(context, '/home');
                            },
                            color: Color.fromARGB(255, 0, 0, 0),
                            iconSize: 30,
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Color.fromARGB(255, 1, 1, 1),
                              //color: Color.fromARGB(255, 253, 253, 253),
                            ),
                            onPressed: () {
                              // Action à effectuer lorsqu'on appuie sur l'icône
                              Navigator.pushNamed(context, '/Favoris');
                            },
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                          icon: Icon(Icons.store),
                          onPressed: () {
                            // Action à effectuer lorsqu'on appuie sur l'icône
                            Navigator.pushNamed(context, '/Boutiques');
                          },
                        )),
                        Expanded(
                            child: IconButton(
                          icon: Icon(Icons.person_add),
                          onPressed: () async {
                            // Action à effectuer lorsqu'on appuie sur l'icône
                            var url =
                                "http://user3-market.3t.tn/admin/market/subscription/request/new";

                            // ignore: deprecated_member_use
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Impossible d\'ouvrir $url';
                            }
                          },
                        )),
                      ],
                    )),

              //end footer
              if (name || Rating || prix)
                Expanded(
                  // flex:
                  child:

                      //             Container(
                      //               height: double.maxFinite,
                      ListView.builder(
                    itemCount: filteredHotels.length,
                    itemBuilder: (context, index) {
                      Hotels item = filteredHotels[index];
                      double ratingValue = double.parse(item.hotel.category);

                      return Column(
                        children: [
                          if (index == 0)
                            /*  Container(
                          height: 300,
                         width: 2000,
                        margin: EdgeInsets.all(20),
              
                child:search2(), ), */
                            Container(
                              height: Responsive.isDesktop(context)
                                  ? 500.h
                                  : Responsive.isTablet(context)
                                      ? 420.h
                                      : null,
                              width: double.infinity,
                              child: Stack(

                                  // width: 2000,
                                  children: [
                                    Container(
                                      width: 2000,
                                      //height: Responsive.isDesktop(context) ? 700 : 400,
                                      height: Responsive.isMobile(context)
                                          ? null
                                          : 400.h,
                                      child: Responsive.isDesktop(context)
                                          ? Carousel()
                                          : null,
                                    ),
                                    Positioned(
                                      // top: 250,
                                      top: Responsive.isDesktop(context)
                                          ? 300.h
                                          : 5.h,
                                      bottom: 0.h,
                                      left: !Responsive.isDesktop(context)
                                          ? 1.h
                                          : 5.h,
                                      right: !Responsive.isDesktop(context)
                                          ? 1.h
                                          : 5.h,
                                      //left: ,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            width: 1200,
                                            //  height: 1000,
                                            height:
                                                !Responsive.isDesktop(context)
                                                    ? 550.h
                                                    : 400,
                                            // margin: EdgeInsets.only(
                                            //     left: Responsive.isDesktop(context) ? 40 : 20),
                                            // Opacité de 50%// Couleur transparente avec une opacité de 50%

                                            //ajouter responsive moteur Recherche
                                            child: Responsive.isDesktop(context)
                                                ? MoteurWeb(
                                                    showContainer:
                                                        showContainer,
                                                    counter: counter,
                                                  )
                                                : Responsive.isTablet(context)
                                                    ? MoteurMobile()
                                                    // : MoteurMobile(),
                                                    : null
                                            //child:search2(),
                                            ),
                                      ),
                                    ),
                                  ]),
                            ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0 && Responsive.isDesktop(context))
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        width: 20.w,
                                        height: 400.h,
                                        margin: EdgeInsets.only(
                                            top: 30,
                                            bottom: 20,
                                            left: MediaQuery.of(context)
                                                            .size
                                                            .width >=
                                                        900 &&
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width <
                                                        1000
                                                ? 20
                                                : MediaQuery.of(context)
                                                                .size
                                                                .width >=
                                                            1000 &&
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width <
                                                            1300
                                                    ? 30
                                                    : MediaQuery.of(context)
                                                                    .size
                                                                    .width >=
                                                                1400 &&
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width <
                                                                2000
                                                        ? 130
                                                        : 70),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Filter By HotelName:',
                                                style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.search),
                                                      onPressed: () {
                                                        filtreByName(
                                                            inputValue);
                                                        print(inputValue);
                                                      },
                                                    ),
                                                    Expanded(
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          print('hhhh');
                                                          setState(() {
                                                            inputValue = value;
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              'Entrez le nom de l\'hotel',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              // Text(
                                              //   'Valeur saisie : $inputValue',
                                              //   style: TextStyle(fontSize: 16.0),
                                              // ),
                                              /*  Padding(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                child: Column(
                                                  children: List.generate(
                                                    extraFilter.length,
                                                    (index) => Row(
                                                      children: [
                                                        Checkbox(
                                                          value: extraFilter[
                                                                  index]
                                                              ['is_selected'],
                                                          onChanged: (e) {
                                                            extraFilter[index][
                                                                    'is_selected'] =
                                                                !extraFilter[
                                                                        index][
                                                                    'is_selected'];
                                                            setState(() {});
                                                          },
                                                          activeColor:
                                                              Colors.blue,
                                                        ),
                                                        Text(
                                                          extraFilter[index]
                                                              ['title'],
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ), */

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Rating',
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontSize: 25.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      filtreByRating(1);
                                                    },
                                                    child: RatingBar.builder(
                                                      initialRating: 1,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Color.fromARGB(
                                                            255, 255, 183, 2),
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        //print(rating);
                                                        // filtreByRating(rating);
                                                      },
                                                      ignoreGestures: true,
                                                    ),
                                                    // SizedBox(width: 10),
                                                    /*   Text(
                                ' 1.0',
                                style: TextStyle(
                                  color: Color.fromARGB(145, 77, 55, 42),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ), */
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      filtreByRating(2);
                                                    },
                                                    child: RatingBar.builder(
                                                      initialRating: 2,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Color.fromARGB(
                                                            255, 255, 183, 2),
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                        //  filtreByRating(rating);
                                                      },
                                                      ignoreGestures: true,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      filtreByRating(3);
                                                    },
                                                    child: RatingBar.builder(
                                                      initialRating: 3,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Color.fromARGB(
                                                            255, 255, 183, 2),
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                        //   filtreByRating(rating);
                                                      },
                                                      ignoreGestures: true,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      filtreByRating(4);
                                                    },
                                                    child: RatingBar.builder(
                                                      initialRating: 4,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Color.fromARGB(
                                                            255, 255, 183, 2),
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                        //   filtreByRating(rating);
                                                      },
                                                      ignoreGestures: true,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      filtreByRating(5);
                                                    },
                                                    child: RatingBar.builder(
                                                      initialRating: 5,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 30.0,
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Color.fromARGB(
                                                            255, 255, 183, 2),
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                      },
                                                      ignoreGestures: true,
                                                    ),
                                                  ),
                                                  //add some details

                                                  Column(
                                                    children: [
                                                      Center(
                                                          child: Text(
                                                        'Filter By Price:',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                      RangeSlider(
                                                        values:
                                                            _selectedPriceRange,
                                                        min: 0,
                                                        max: 1000,
                                                        divisions: 10,
                                                        activeColor:
                                                            Colors.black,
                                                        inactiveColor:
                                                            Colors.black,
                                                        onChanged: (RangeValues
                                                            values) {
                                                          setState(() {
                                                            _selectedPriceRange =
                                                                values;
                                                          });
                                                        },
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('TND+'
                                                              '${_selectedPriceRange.start.toStringAsFixed(2)}'),
                                                          Text('TND+'
                                                              '${_selectedPriceRange.end.toStringAsFixed(2)}'),
                                                        ],
                                                      ),
                                                      Container(
                                                        //color: Colors.black,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            int startPrice =
                                                                _selectedPriceRange
                                                                    .start
                                                                    .toInt();
                                                            int endPrice =
                                                                _selectedPriceRange
                                                                    .end
                                                                    .toInt();
                                                            filtreByPrix(
                                                                startPrice,
                                                                endPrice);
                                                          },
                                                          child: Text(
                                                            'Appliquer',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                  //end
                                                ],
                                              ),

                                              /*   RadioListTile(
                            title: Text('Option 1'),
                            value: 1,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          RadioListTile(
                            title: Text('Option 2'),
                            value: 2,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          RadioListTile(
                            title: Text('Option 3'),
                            value: 3,
                            groupValue: _selectedRadioValue,
                            onChanged: _handleRadioValueChange,
                          ), */
                                            ],
                                          ),
                                        )),
                                  ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                //   Text('$lenghtList Hôtel(s) trouvé(s)'),
                                Expanded(
                                    flex: index != 0 &&
                                            Responsive.isDesktop(context)
                                        ? 2
                                        : 0,
                                    child: Container()),
                                //  if(Responsive.isDesktop(context) || !Responsive.isDesktop(context))

                                Expanded(
                                    flex:
                                        Responsive.isDesktop(context) ? 4 : 11,
                                    child: Container(
                                        //  height: 450.h,
                                        height: Responsive.isDesktop(context)
                                            ? 400.h
                                            : MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    360
                                                ? 350.h
                                                : 400.h,
                                        margin: EdgeInsets.only(
                                            bottom:
                                                Responsive.isDesktop(context)
                                                    ? 5
                                                    : 7,
                                            top: 30),
                                        padding: EdgeInsets.all(
                                            Responsive.isDesktop(context)
                                                ? 8
                                                : 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(9),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                      255, 66, 64, 64)
                                                  .withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            //affichage de Mobile
                                            if (!Responsive.isDesktop(context))
                                              Expanded(
                                                flex: 11,
                                                child: Stack(
                                                  children: [
                                                    // L'image à afficher

                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.network(
                                                        item.hotel.picture,
                                                        fit: BoxFit.cover,
                                                        height:
                                                            double.maxFinite,
                                                        width: double.maxFinite,
                                                      ),
                                                    ),
                                                    if (ratingValue > 2)
                                                      Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    238,
                                                                    16,
                                                                    0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.whatshot,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                'Hot Rate',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                                        onTap: () async {
                                                          final prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          List<String>?
                                                              existingFavourites =
                                                              prefs.getStringList(
                                                                      'Favouris') ??
                                                                  [];
                                                          String itemHotelJson =
                                                              json.encode(item
                                                                  .toJson());

                                                          if (existingFavourites
                                                              .contains(
                                                                  itemHotelJson)) {
                                                            /*  await verifier(
                                                                    item); */
                                                            //isEXist = true;
                                                            // L'élément existe déjà dans la liste, le supprimer du local storage
                                                            existingFavourites
                                                                .remove(
                                                                    itemHotelJson);
                                                            prefs.setStringList(
                                                                'Favouris',
                                                                existingFavourites);
                                                            print(
                                                                'Élément supprimé du local storage');
                                                          } else {
                                                            // L'élément n'existe pas dans la liste, l'ajouter au local storage
                                                            existingFavourites.add(
                                                                itemHotelJson);
                                                            prefs.setStringList(
                                                                'Favouris',
                                                                existingFavourites);
                                                            print(
                                                                'Élément ajouté au local storage');
                                                          }

                                                          setState(() {
                                                            isFavorite =
                                                                !isFavorite;
                                                            selectedFavoriteIndex =
                                                                index;
                                                            favoriteStatusList[
                                                                    index] =
                                                                !favoriteStatusList[
                                                                    index];
                                                          });
                                                        },
                                                        child: Icon(
                                                          favoriteStatusList[
                                                                  index]
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          size: 30,
                                                          color:
                                                              favoriteStatusList[
                                                                      index]
                                                                  ? Colors.red
                                                                  : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            if (!Responsive.isDesktop(context))
                                              Expanded(
                                                flex: 11,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          Responsive.isDesktop(
                                                                  context)
                                                              ? 15.sp
                                                              : 1.sp),
                                                  child: Column(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        ' ${item.hotel.hotelName}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                          color: Color.fromARGB(
                                                              255,
                                                              128,
                                                              128,
                                                              128),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: Responsive
                                                                  .isDesktop(
                                                                      context)
                                                              ? 6.h
                                                              : 1.h),
                                                      if (!Responsive.isDesktop(
                                                          context))
                                                        Row(
                                                          children: [
                                                            RatingBar.builder(
                                                              initialRating:
                                                                  ratingValue,
                                                              minRating: 1,
                                                              direction: Axis
                                                                  .horizontal,
                                                              allowHalfRating:
                                                                  true,
                                                              itemCount: 5,
                                                              itemSize: 20.0.sp,
                                                              itemBuilder:
                                                                  (context,
                                                                          _) =>
                                                                      Icon(
                                                                Icons.star,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        183,
                                                                        2),
                                                              ),
                                                              onRatingUpdate:
                                                                  (rating) {
                                                                print(rating);
                                                              },
                                                              ignoreGestures:
                                                                  true,
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Container(
                                                              height: 30
                                                                  .h, // Adjust the height as needed
                                                              width:
                                                                  2, // Set the width to define the separator line thickness
                                                              color: Colors
                                                                  .grey, // Set the color of the separator line
                                                            ),
                                                            SizedBox(
                                                              width: 10.w,
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      size:
                                                                          20.sp,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              6,
                                                                              6,
                                                                              6),
                                                                    ),
                                                                    Text(
                                                                      '${item.hotel.location.toString()}',
                                                                      style: GoogleFonts
                                                                          .roboto(
                                                                        textStyle:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17.sp,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          fontStyle:
                                                                              FontStyle.italic,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            )
                                                          ],
                                                        ),
                                                      //add here
                                                      Text(
                                                        '$ratingValue-starHotel',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),

                                                      if (!Responsive.isDesktop(
                                                          context))
                                                        Text(
                                                          'For $Nbchambres room(s) x $numberOfDays night(s)',
                                                          style: GoogleFonts
                                                              .roboto(
                                                            textStyle: TextStyle(
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Free ',
                                                            style: TextStyle(
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      95,
                                                                      95,
                                                                      95),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5.w),
                                                          Icon(
                                                            Icons.wifi,
                                                            size: 18.sp,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    95,
                                                                    95,
                                                                    95),
                                                          ),
                                                        ],
                                                      ),
                                                      if (!Responsive.isDesktop(
                                                          context))
                                                        Container(
                                                          height: 50.h,
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              children: item
                                                                  .sellers
                                                                  .map((seller) =>
                                                                      Container(
                                                                        width: Responsive.isMobile(context)
                                                                            ? 300
                                                                            : 350, // Largeur fixe pour chaque élément
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                5.w),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            ClipOval(
                                                                              child: Image.network(
                                                                                'http://user3-market.3t.tn/getImages?filename=${seller.sellerData.brochureFilename}',
                                                                                fit: BoxFit.cover,
                                                                                width: 50,
                                                                                height: 50,
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: Responsive.isDesktop(context) ? 35 : 5.w),
                                                                            RichText(
                                                                              text: TextSpan(
                                                                                text: 'From  ',
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15.sp,
                                                                                ),
                                                                                children: <TextSpan>[
                                                                                  TextSpan(
                                                                                    text: seller.prixSeller + ' TND',
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 18.sp,
                                                                                      foreground: Paint()
                                                                                        ..shader = LinearGradient(
                                                                                          colors: [
                                                                                            Color.fromARGB(255, 7, 7, 7),
                                                                                            Color.fromARGB(255, 243, 22, 22)
                                                                                          ],
                                                                                          begin: Alignment.topLeft,
                                                                                          end: Alignment.bottomRight,
                                                                                        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  elevation: 2,
                                                                                  backgroundColor: Color.fromARGB(255, 252, 252, 252),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                ),
                                                                                onPressed: () async {
                                                                                  HotelName = item.hotel.hotelName;
                                                                                  apiCode = seller.sellerData.api.id;
                                                                                  HotelId = item.hotel.hotelId;
                                                                                  print('hotelnameclicked${item.hotel.hotelName}');
                                                                                  await getCurrentLocation();
                                                                                  await createApiProduct();
                                                                                  var url = seller.detailsLink;
                                                                                  if (await canLaunch(url)) {
                                                                                    await launch(url);
                                                                                  } else {
                                                                                    throw 'Impossible d\'ouvrir $url';
                                                                                  }
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.visibility,
                                                                                  size: 24.sp,
                                                                                  color: Color.fromARGB(255, 0, 0, 0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            //end affichage de Mobile

                                            //affichage desktop
                                            if (Responsive.isDesktop(context))
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: Responsive.isDesktop(
                                                            context)
                                                        ? 2
                                                        : 10,
                                                    child: Stack(
                                                      children: [
                                                        // L'image à afficher

                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image.network(
                                                            item.hotel.picture,
                                                            fit: BoxFit.cover,
                                                            height: 300,
                                                            width: 500,
                                                          ),
                                                        ),
                                                        // ),
                                                        // Le bouton "favori"
                                                        if (ratingValue > 2)
                                                          Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            child: Container(
                                                              width: 30.w,
                                                              height: 40.h,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        238,
                                                                        16,
                                                                        0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .whatshot,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20.sp,
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Text(
                                                                    'Hot Rate',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                        Positioned(
                                                          top:
                                                              10, // Ajuster la position verticale selon vos besoins
                                                          right:
                                                              10, // Ajuster la position horizontale selon vos besoins
                                                          child: InkWell(
                                                            onTap: () async {
                                                              final prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              List<String>?
                                                                  existingFavourites =
                                                                  prefs.getStringList(
                                                                          'Favouris') ??
                                                                      [];
                                                              String
                                                                  itemHotelJson =
                                                                  json.encode(item
                                                                      .toJson());

                                                              if (existingFavourites
                                                                  .contains(
                                                                      itemHotelJson)) {
                                                                /*  await verifier(
                                                                    item); */
                                                                //isEXist = true;
                                                                // L'élément existe déjà dans la liste, le supprimer du local storage
                                                                existingFavourites
                                                                    .remove(
                                                                        itemHotelJson);
                                                                prefs.setStringList(
                                                                    'Favouris',
                                                                    existingFavourites);
                                                                print(
                                                                    'Élément supprimé du local storage');
                                                              } else {
                                                                // L'élément n'existe pas dans la liste, l'ajouter au local storage
                                                                existingFavourites
                                                                    .add(
                                                                        itemHotelJson);
                                                                prefs.setStringList(
                                                                    'Favouris',
                                                                    existingFavourites);
                                                                print(
                                                                    'Élément ajouté au local storage');
                                                              }

                                                              setState(() {
                                                                isFavorite =
                                                                    !isFavorite;
                                                                selectedFavoriteIndex =
                                                                    index;
                                                                favoriteStatusList[
                                                                        index] =
                                                                    !favoriteStatusList[
                                                                        index];
                                                              });
                                                            },

                                                            /*    onTap: () async {
                                                              final prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                        

                                                              if (Fvouris !=
                                                                      null &&
                                                                      
                                                                  Fvouris.contains(
                                                                     json
                                                                    .decode( item.hotel.toJson())) ) {
                                                                print(
                                                                    'isExist');
                                                                    Fvouris.remove(item.hotel);
                                                               prefs.setStringList('Favouris', Fvouris);
                                                               print('Element supprimé du local storage');
                                                                // L'élément existe déjà dans la liste, ne pas ajouter
                                                              } else {
                                                                

                                                                prefs.setStringList(
                                                                    'Favouris',
                                                                    Fvouris);

                                                                Fvouris.add(json
                                                                    .encode(item
                                                                        .hotel
                                                                        .toJson()));
                                                                prefs.setStringList(
                                                                    'Favouris',
                                                                    Fvouris);
                                                              }

                                                              setState(() {
                                                                isFavorite =
                                                                    !isFavorite;
                                                                selectedFavoriteIndex =
                                                                    index;
                                                                if (selectedFavoriteIndex ==
                                                                    index) {
                                                                  print(item);
                                                                }
                                                                favoriteStatusList[
                                                                        index] =
                                                                    !favoriteStatusList[
                                                                        index];
                                                              });
                                                            },  */
                                                            /* onTap: () async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? existingFavourites = prefs.getStringList('Favouris');

  if (existingFavourites != null && existingFavourites.contains(item.hotel)) {
    // Element exists in the list, remove it from local storage
    existingFavourites.remove(item.hotel);
    prefs.setStringList('Favouris', existingFavourites);
    print('Element removed from local storage');
  } else {
    // Element doesn't exist in the list, add it to local storage
    existingFavourites ??= [];
    existingFavourites.add(json
                                                                    .encode(item.hotel.toJson()));
    prefs.setStringList('Favouris', existingFavourites);
    print('Element added to local storage');
  }

  setState(() {
    isFavorite = !isFavorite;
    selectedFavoriteIndex = index;
    favoriteStatusList[index] = !favoriteStatusList[index];
  });
},
 */
                                                            child: Icon(
                                                              favoriteStatusList[
                                                                      index]
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              size: 30,
                                                              color:
                                                                  favoriteStatusList[
                                                                          index]
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (Responsive.isDesktop(
                                                      context))
                                                    Expanded(
                                                      flex:
                                                          Responsive.isDesktop(
                                                                  context)
                                                              ? 3
                                                              : 10,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15.h),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              ' ${item.hotel.hotelName}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 5.h),
                                                            if (Responsive
                                                                .isDesktop(
                                                                    context))
                                                              Row(
                                                                children: [
                                                                  RatingBar
                                                                      .builder(
                                                                    initialRating:
                                                                        ratingValue,
                                                                    minRating:
                                                                        1,
                                                                    direction: Axis
                                                                        .horizontal,
                                                                    allowHalfRating:
                                                                        true,
                                                                    itemCount:
                                                                        5,
                                                                    itemSize:
                                                                        30.0,
                                                                    itemBuilder:
                                                                        (context,
                                                                                _) =>
                                                                            Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          183,
                                                                          2),
                                                                    ),
                                                                    onRatingUpdate:
                                                                        (rating) {
                                                                      print(
                                                                          rating);
                                                                    },
                                                                    ignoreGestures:
                                                                        true,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    height:
                                                                        50, // Adjust the height as needed
                                                                    width:
                                                                        1, // Set the width to define the separator line thickness
                                                                    color: Colors
                                                                        .grey, // Set the color of the separator line
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    child: Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.location_on,
                                                                            size:
                                                                                30,
                                                                          ),
                                                                          Text(
                                                                            '${item.hotel.location.toString()}',
                                                                            style:
                                                                                GoogleFonts.roboto(
                                                                              textStyle: TextStyle(
                                                                                fontSize: 20.sp,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color.fromARGB(255, 0, 0, 0),
                                                                                fontStyle: FontStyle.italic,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  )
                                                                ],
                                                              ),
                                                            SizedBox(
                                                                height: 10.h),
                                                            if (Responsive
                                                                .isDesktop(
                                                                    context))
                                                              Text(
                                                                ' For $Nbchambres room(s) x $numberOfDays night(s)',
                                                                style:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                          20.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .normal,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            SizedBox(
                                                                height: 5.h),
                                                            AnimatedSize(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          600),
                                                              curve:
                                                                  Curves.ease,
                                                              child: Container(
                                                                height:
                                                                    isExtraFeatures
                                                                        ? null
                                                                        : 45,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          156,
                                                                          156,
                                                                          156),
                                                                      offset: Offset(
                                                                          0,
                                                                          2), // Décalage vertical de l'ombre
                                                                      blurRadius:
                                                                          2, // Rayon de flou de l'ombre
                                                                    ),
                                                                  ],
                                                                  color: Color(
                                                                      0xFFF7F7FA),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                                  ),
                                                                ),

                                                                /*  margin: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          30), */
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                /*   decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFF7F7FA),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          15),
                                                                    ),
                                                                  ), */
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        isExtraFeatures =
                                                                            !isExtraFeatures;
                                                                        //  isExtraFeaturesList[index] = !isExtraFeaturesList[index];
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .transparent,
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              15,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              'View All Sellers ',
                                                                              style: GoogleFonts.roboto(
                                                                                textStyle: TextStyle(
                                                                                  fontSize: 20.sp,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontStyle: FontStyle.italic,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            RotatedBox(
                                                                              quarterTurns: isExtraFeatures ? 25 : 0,
                                                                              child: Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 15.sp,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    if (isExtraFeatures)
                                                                      Container(
                                                                        height:
                                                                            200.h,
                                                                        width: double
                                                                            .maxFinite, // Set a fixed height for the SingleChildScrollView
                                                                        // Set a fixed height for the SingleChildScrollView
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            children: item.sellers
                                                                                .map((seller) => Row(
                                                                                      children: [
                                                                                        ClipOval(
                                                                                          child: Image.network(
                                                                                            'http://user3-market.3t.tn/getImages?filename=${seller.sellerData.brochureFilename}',
                                                                                            fit: BoxFit.cover,
                                                                                            width: 50,
                                                                                            height: 50,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 2.w),
                                                                                        /*  Text(
                                                                                            'À partir de ' + seller.prixSeller + 'TND',
                                                                                            style: const TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.black,
                                                                                              fontSize: 18,
                                                                                            ),
                                                                                          ), */
                                                                                        RichText(
                                                                                          text: TextSpan(
                                                                                            text: 'From  ',
                                                                                            style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.black,
                                                                                              fontSize: 15.sp,
                                                                                            ),
                                                                                            children: <TextSpan>[
                                                                                              TextSpan(
                                                                                                text: seller.prixSeller + ' TND',
                                                                                                style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: 18.sp,
                                                                                                  // color: Colors.red,
                                                                                                  foreground: Paint()
                                                                                                    ..shader = LinearGradient(
                                                                                                      colors: [
                                                                                                        Color.fromARGB(255, 7, 7, 7),
                                                                                                        Color.fromARGB(255, 243, 22, 22)
                                                                                                      ], // Remplacez les couleurs par celles de votre choix
                                                                                                      begin: Alignment.topLeft,
                                                                                                      end: Alignment.bottomRight,
                                                                                                    ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Spacer(),
                                                                                        Align(
                                                                                          alignment: Alignment.centerRight,
                                                                                          child: ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              elevation: 2,
                                                                                              backgroundColor: Color.fromARGB(255, 255, 255, 255),
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                              ),
                                                                                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                                                                                            ),
                                                                                            onPressed: () async {
                                                                                              HotelName = item.hotel.hotelName;
                                                                                              apiCode = seller.sellerData.api.id;
                                                                                              HotelId = item.hotel.hotelId;

                                                                                              print('hotelnameclicked${item.hotel.hotelName}');
                                                                                                  await getCurrentLocationForweb();
                                                                                              await createApiProduct();
                                                                                              var url = seller.detailsLink;
                                                                                              if (await canLaunch(url)) {
                                                                                                await launch(url);
                                                                                              } else {
                                                                                                throw 'Impossible d\'ouvrir $url';
                                                                                              }
                                                                                              /* Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebViewPage(url: seller.detailsLink),
    ),
  ); */
                                                                                            },
                                                                                            /*  child: Text(
                                                                                                'Voir Offer',
                                                                                                style: GoogleFonts.roboto(
                                                                                                  textStyle: TextStyle(
                                                                                                    fontSize: 12,
                                                                                                    color: Colors.black,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontStyle: FontStyle.normal,
                                                                                                  ),
                                                                                                ),
                                                                                              ), */
                                                                                            child: Icon(
                                                                                              Icons.visibility,
                                                                                              size: 24.sp,
                                                                                              color: Color.fromARGB(255, 0, 0, 0),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 3.w),
                                                                                      ],
                                                                                    ))
                                                                                .toList(),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

// Assuming you have a list of products called 'products'

                                                            /*  Text(
  'Price: ${hotel.hotel.lowPrice.toString()}  ${hotel.hotel.currency.toString()}',
  presetFontSizes: [20, 16, 12], // Liste des tailles de police pour différentes tailles d'écran
  style: GoogleFonts.roboto(
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    ),
  ),
), */

                                                            /*  Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    'http://user3-market.3t.tn/getImages?filename=${hotel.hotelData.category}',
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                Text(
                                                  'hotel.seller!.name.toString()',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ), */

                                                            SizedBox(
                                                                height: 10.h),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            /*  Expanded(
                                  child: Row(
                                    children: hotel.seller
                                        .map((seller) => Column(
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    'http://user3-market.3t.tn/getImages?filename=${seller.brochureFilename}',
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                ),
                                                SizedBox(width: 35),
                                                Text(
                                                  seller.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation:
                                                        5, // hauteur de l'élévation
                                                    backgroundColor: Color.fromARGB(
                                                        255,
                                                        18,
                                                        111,
                                                        249), // couleur de fond
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1.0),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12,
                                                            horizontal:
                                                                16), // padding
                                                  ),
                                                  onPressed: () async {
                                                    var url =
                                                        hotel.hotel.detailsLink;

                                                    // ignore: deprecated_member_use
                                                    if (await canLaunch(url)) {
                                                      await launch(url);
                                                    } else {
                                                      throw 'Impossible d\'ouvrir $url';
                                                    }
                                                  },
                                                  child: Text(
                                                    'Voir Offer',
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ), */
                                            SizedBox(
                                              width: 35,
                                            ),
                                          ],
                                        ))),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width >=
                                                900 &&
                                            MediaQuery.of(context).size.width <
                                                1200
                                        ? 2.w
                                        : (!Responsive.isDesktop(context))
                                            ? 0
                                            : 40.w),
                                //   if (Responsive.isDesktop(context))
                                // if (MediaQuery.of(context).size.width > 1500)

                                /*  Expanded(
              flex: Responsive.isDesktop(context) ? 1 : 0,
              child: Container(
              
               // margin: EdgeInsets.only(top: 50, bottom: 50, left: 170),
               // padding: const EdgeInsets.all(10),
              ),
            ), */
                              ])
                        ],
                      );
                    },
                  ),
                ),
              if (!Responsive.isDesktop(context) && (prix || Rating))
                Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              // Action à effectuer lorsqu'on appuie sur l'icône
                              Navigator.pushNamed(context, '/home');
                            },
                            color: Color.fromARGB(255, 0, 0, 0),
                            iconSize: 30,
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Color.fromARGB(255, 1, 1, 1),
                              //color: Color.fromARGB(255, 253, 253, 253),
                            ),
                            onPressed: () {
                              // Action à effectuer lorsqu'on appuie sur l'icône
                              Navigator.pushNamed(context, '/Favoris');
                            },
                          ),
                        ),
                        Expanded(
                            child: IconButton(
                          icon: Icon(Icons.store),
                          onPressed: () {
                            // Action à effectuer lorsqu'on appuie sur l'icône
                            Navigator.pushNamed(context, '/Boutiques');
                          },
                        )),
                        Expanded(
                            child: IconButton(
                          icon: Icon(Icons.person_add),
                          onPressed: () async {
                            // Action à effectuer lorsqu'on appuie sur l'icône
                            var url =
                                "http://user3-market.3t.tn/admin/market/subscription/request/new";

                            // ignore: deprecated_member_use
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Impossible d\'ouvrir $url';
                            }
                          },
                        )),
                      ],
                    )),
            ]));
  }
}

//code of scroll
/* class FilterContainer extends StatelessWidget {
  final String title;
  final IconData icon;
 // final VoidCallback onPressed;

  const FilterContainer({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
} */
