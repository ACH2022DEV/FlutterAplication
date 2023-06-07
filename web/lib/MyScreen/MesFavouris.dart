import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t3_market_place/MyScreen/responsive.dart';
//import 'dart:html' as html;

//import 'dart:html';
//import 'dart:js' as js; //commented for mobile
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geocoding/geocoding.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:web/MyScreen/recherche.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

//import 'package:web/models/Circuit_Models.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/link.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/ApiHotels&Sellers.dart';

class Favouris extends StatefulWidget {
  // const ProductsPage({Key? key}) : super(key: key);

  Favouris({
    Key? key,
    required this.Mesproducts,
  }) : super(key: key);

  List<Hotels> Mesproducts;

  @override
  // ignore: library_private_types_in_public_api
  _FavourisState createState() => _FavourisState();
}

class _FavourisState extends State<Favouris> {
  List<Hotels> products = [];
  List<Hotels> Mesproducts = [];

  String nom = "";
  RangeValues _currentRangeValues = const RangeValues(0, 100);

  bool _loading = true;
  bool isExtraFeatures = true;

  // Indique s'il reste encore des éléments à charger
  // Le contrôleur de défilement pour détecter la fin de la liste
  ScrollController _scrollController = ScrollController();
  //List<Hotels> displayedItems = [];
  int itemsPerPage = 3;
  int currentPage = 2;
  bool isLoading = false;
//end pagination
//  List<Api_Hotels> Allproducts = [];
  // ignore: non_constant_identifier_names
  // List<Api_Circuit> products_Circuit = [];
  // class variable
  Color favoriteColor = Color.fromARGB(255, 183, 183, 182);
  final PagingController<int, Hotels> _pagingController =
      PagingController(firstPageKey: 0);
  List<Hotels> _data = [];
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
  Future<void> saveCheckInOutDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String checkin = prefs.getString('checkin') ?? '';
    String checkout = prefs.getString('checkout') ?? '';
    DateTime checkInDate = DateTime.parse(checkin);
    DateTime checkOutDate = DateTime.parse(checkout);

    //  prefs.setString('checkout', '$checkOutDate');
    numberOfDays = checkOutDate.difference(checkInDate).inDays;
    print('numberOfDays$numberOfDays');
    Nbchambres = prefs.getString('chambre') ?? '';
  }

  List<bool> favoriteStatusList = [];
  List<bool> isExtraFeaturesList = [];
  bool isFavorite = false;
  List<String> Fvouris = [];

  late int selectedFavoriteIndex;
  Future<void> _fetchData(int pageKey) async {
    // Simulate data fetching from local storage
    final prefs = await SharedPreferences.getInstance();
    List<String> hotelsFavourisJsonList = prefs.getStringList('Favouris') ?? [];

    products = hotelsFavourisJsonList
        .map((hotelJson) => Hotels.fromJson(json.decode(hotelJson)))
        .toList();
    favoriteStatusList = List.generate(_data.length, (index) => false);
    isExtraFeaturesList = List.generate(products.length, (index) => false);

    final lenghtList = products.length;
    print(lenghtList);
    // Generate new data for the current page
    final startIndex = pageKey * 1;
    final endIndex = startIndex + 1;

    if (endIndex < products.length) {
      List<Hotels> newData = products.sublist(startIndex, endIndex);

      setState(() {
        _data.addAll(newData);
        print('added$startIndex');
      });

      final isLastPage = endIndex >= products.length;
      if (isLastPage) {
        _pagingController.appendLastPage(_data);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newData, nextPageKey);
      }
    }
  }

  String ipLocationForweb = '';

  /* Future<void> getCurrentLocationForweb() async {
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
  } */

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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // _loadMoreHotels();
    }
  }
  /*  void _loadItems() {
    final endIndex = currentPage * itemsPerPage;
    if (mesproducts.isNotEmpty) {
      final newItems = widget.Mesproducts.sublist(0, endIndex);

      setState(() {
        mesproducts.addAll(newItems);
        currentPage++;
        print(currentPage++);
      });
    }
  } */

  /* Future<void> getHotelData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJsonList = prefs.getStringList('products') ?? [];
    if (productsJsonList.isNotEmpty) {
      mesproducts = productsJsonList
          .map((productJson) => Hotels.fromJson(json.decode(productJson)))
          .toList();
      print('this is my data of hotels in session ${mesproducts}');
    }
  } */

  void filtreByRating(double rating) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJsonList = prefs.getStringList('products') ?? [];
    products = productsJsonList
        .map((productJson) => Hotels.fromJson(json.decode(productJson)))
        .toList();
    print('mmmmm1$products');

    /* List<Hotel> filterHotelsByRating(double rating) {
      return products.where((hotel) {
        // Vérifiez si le classement (rating) de l'hôtel est supérieur ou égal à la valeur spécifiée
        return hotel.hotel.category == rating;
      }).toList();
    } */

    /* List<Hotels> filteredHotels = filterHotelsByRating(rating);
    products2 = filteredHotels;
    print('mmmmm$products2');
 */
    /*  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductsPage(
                Mesproducts: products2,
              )),
      //  builder: (context) => ProductsPage2()),
    ); */
  }

// Mettre à jour la liste de produits

  //print(products2.map((e) => e.data.response.map((e) => e.category)));
  /*  for (var pro in products2) {
      print('${pro.seller.name}: ');
      for (var pro in pro.data.response) {
        print(pro.category.toString());
      }
    } */

  /*  Future<void> filtreByRating(double rating) async {
    loading2 = true;
    final prefs = await SharedPreferences.getInstance();
    List<String> productsJsonList = prefs.getStringList('products') ?? [];
    if (productsJsonList.isNotEmpty) {
      products2 = productsJsonList
          .map((productJson) => Hotels.fromJson(json.decode(productJson)))
          .toList();
      print('this is my data of hotels in session $products');
    }

    List<Hotels> fiveStarHotels =
        products2.first.filterHotelsByRating(products2, rating);

    //  List<Hotels> filteredHotels2 = filterHotelsByRating(products2, rating);

    print('filtrage1$fiveStarHotels');

    //  products2 = fiveStarHotels;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductsPage(
                Mesproducts: fiveStarHotels,
              )),
      //  builder: (context) => ProductsPage2()),
    );

// Mettre à jour la liste de produits

    //print(products2.map((e) => e.data.response.map((e) => e.category)));
    /*  for (var pro in products2) {
      print('${pro.seller.name}: ');
      for (var pro in pro.data.response) {
        print(pro.category.toString());
      }
    } */
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 255, 255, 255),
                      // Set the desired color for the back button
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Navigate back to the previous page
                    },
                  ),
                  
          title: 
         Center(child:Text('My Favorites',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.bold),), ) 
         
          ,backgroundColor: Color.fromARGB(255, 204, 35, 35)
         
          ),
      body:
      Column(  mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child:PagedListView<int, Hotels>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Hotels>(
          itemBuilder: (context, item, index) {
            double ratingValue = double.parse(item.hotel.category);

            // print('$index ,$response');

            return Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: MediaQuery.of(context).size.width >= 900 &&
                                MediaQuery.of(context).size.width < 1200
                            ? 1
                            : Responsive.isDesktop(context)
                                ? 2
                                : 0,
                        child: Container(),
                      ),

                      //   Text('$lenghtList Hôtel(s) trouvé(s)'),

                      Expanded(
                          flex: Responsive.isDesktop(context) ? 6 : 10,
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
                                  bottom: Responsive.isDesktop(context) ? 5 : 7,right:Responsive.isMobile(context) ? 3:0,left:Responsive.isMobile(context) ? 3:0,
                                  top: 30),
                              padding: EdgeInsets.all(
                                  Responsive.isDesktop(context) ? 8 : 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 66, 64, 64)
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
                                      flex: 10,
                                      child: Stack(
                                        children: [
                                          // L'image à afficher

                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              item.hotel.picture,
                                              fit: BoxFit.cover,
                                              height: double.maxFinite,
                                              width: double.maxFinite,
                                            ),
                                          ),
                                          // ),
                                          // Le bouton "favori"
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
                                                        Positioned(
                                            top:
                                                10, // Ajuster la position verticale selon vos besoins
                                            right:
                                                10, // Ajuster la position horizontale selon vos besoins
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isFavorite = !isFavorite;
                                                  selectedFavoriteIndex = index;
                                                  if (selectedFavoriteIndex ==
                                                      index) {
                                                    print(item.hotel.hotelName);
                                                  }
                                                  favoriteStatusList[index] =
                                                      !favoriteStatusList[
                                                          index];
                                                });
                                              },
                                              child: Icon(
                                                Icons.favorite,
                                                size: 30,
                                                color: Colors.red,
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
                                          flex: Responsive.isDesktop(context)
                                              ? 2
                                              : 10,
                                          child: Stack(
                                            children: [
                                              // L'image à afficher

                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image.network(
                                                  item.hotel.picture,
                                                  fit: BoxFit.cover,
                                                  height: 350,
                                                  width: 500,
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
                                                    String itemHotelJson = json
                                                        .encode(item.toJson());

                                                    if (existingFavourites
                                                        .contains(
                                                            itemHotelJson)) {
                                                      /*  await verifier(
                                                                    item); */
                                                      //isEXist = true;
                                                      // L'élément existe déjà dans la liste, le supprimer du local storage
                                                      existingFavourites.remove(
                                                          itemHotelJson);
                                                      prefs.setStringList(
                                                          'Favouris',
                                                          existingFavourites);
                                                      print(
                                                          'Élément supprimé du local storage');
                                                    } else {
                                                      // L'élément n'existe pas dans la liste, l'ajouter au local storage
                                                      existingFavourites
                                                          .add(itemHotelJson);
                                                      prefs.setStringList(
                                                          'Favouris',
                                                          existingFavourites);
                                                      print(
                                                          'Élément ajouté au local storage');
                                                    }

                                                    setState(() {
                                                      isFavorite = !isFavorite;
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
                                                    Icons.favorite,
                                                    size: 30,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (Responsive.isDesktop(context))
                                          Expanded(
                                            flex: Responsive.isDesktop(context)
                                                ? 3
                                                : 10,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15.h),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ' ${item.hotel.hotelName}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h),
                                                  if (Responsive.isDesktop(
                                                      context))
                                                    Row(
                                                      children: [
                                                        RatingBar.builder(
                                                          initialRating:
                                                              ratingValue,
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
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    183,
                                                                    2),
                                                          ),
                                                          onRatingUpdate:
                                                              (rating) {
                                                            print(rating);
                                                          },
                                                          ignoreGestures: true,
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
                                                          child: Row(children: [
                                                            Icon(
                                                              Icons.location_on,
                                                              size: 30,
                                                            ),
                                                            Text(
                                                              '${item.hotel.location.toString()}',
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                        )
                                                      ],
                                                    ),
                                                  SizedBox(height: 10.h),
                                                  if (Responsive.isDesktop(
                                                      context))
                                                    Text(
                                                      'For $Nbchambres room(s) x $numberOfDays night(s)',
                                                      style: GoogleFonts.roboto(
                                                        textStyle: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.normal,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  SizedBox(height: 5.h),
                                                  AnimatedSize(
                                                    duration: const Duration(
                                                        milliseconds: 600),
                                                    curve: Curves.ease,
                                                    child: Container(
                                                      height: isExtraFeatures
                                                          ? null
                                                          : 45,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 30),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xFFF7F7FA),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              isExtraFeatures =
                                                                  !isExtraFeatures;
                                                              //  isExtraFeaturesList[index] = !isExtraFeaturesList[index];
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                              color: Colors
                                                                  .transparent,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 15,
                                                                left: 10,
                                                                right: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    'View All Sellers ',
                                                                    style: GoogleFonts
                                                                        .roboto(
                                                                      textStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  RotatedBox(
                                                                    quarterTurns:
                                                                        isExtraFeatures
                                                                            ? 25
                                                                            : 0,
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          if (isExtraFeatures)
                                                            Container(
                                                              height: 200.h,
                                                              width: double
                                                                  .maxFinite, // Set a fixed height for the SingleChildScrollView
                                                              // Set a fixed height for the SingleChildScrollView
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: item
                                                                      .sellers
                                                                      .map((seller) =>
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
                                                                                   // await getCurrentLocationForweb();
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

                                                  SizedBox(height: 10),
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

                      Expanded(
                        flex: MediaQuery.of(context).size.width >= 900 &&
                                MediaQuery.of(context).size.width < 1200
                            ? 1
                            : Responsive.isDesktop(context)
                                ? 2
                                : 0,
                        child: Container(),
                      ),
                      //   if (Responsive.isDesktop(context))
                      // if (MediaQuery.of(context).size.width > 1500)

                      /*  Expanded(
              flex: Responsive.isDesktop(context) ? 1 : 0,
              child: Container(
              
               // margin: EdgeInsets.only(top: 50, bottom: 50, left: 170),
               // padding: const EdgeInsets.all(10),
              ),
            ), */
                    ]),
                     

              ],
            );
          },
        ),
      ),),
       if (!Responsive.isDesktop(context) )
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
      //here
      ])
             
    );
  }
}
