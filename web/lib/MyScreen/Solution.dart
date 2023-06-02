/* 
import 'package:flutter/material.dart';

class AgeSelectionPage extends StatefulWidget {
  @override
  _AgeSelectionPageState createState() => _AgeSelectionPageState();
}

class _AgeSelectionPageState extends State<AgeSelectionPage> {
  // Listes pour stocker les valeurs sélectionnées pour chaque chambre
  List<int> _selectedNbEnfants = [0, 0, 0];
  List<List<int>> _selectedAges = [[], [], []];

  // Options pour les dropdowns (de 1 à 17 ans)
  List<int> _optionsAges = List.generate(17, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sélection d\'âge'),
      ),
      body: ListView.builder(
        itemCount: _selectedNbEnfants.length,
        itemBuilder: (BuildContext context, int index) {
          // Crée une liste de champs d'âge en fonction du nombre d'enfants sélectionnés pour chaque chambre
          List<Widget> ageFields = List.generate(
            _selectedNbEnfants[index],
            (ageIndex) => Container(
              width: 90,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Âge ${ageIndex + 1}',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedAges[index][ageIndex],
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAges[index][ageIndex] = newValue!;
                    });
                  },
                  items: _optionsAges.map((int age) {
                    return DropdownMenuItem<int>(
                      value: age,
                      child: Text(age.toString()),
                    );
                  }).toList(),
                ),
              ),
            ),
          );

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chambre ${index + 1}'),
                SizedBox(height: 8.0),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Nombre d\'enfants',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedNbEnfants[index],
                  onChanged: (newValue) {
                    setState(() {
                      _selectedNbEnfants[index] = newValue!;
                      _selectedAges[index].length = newValue;
                    });
                  },
                  items: List.generate(4, (n) {
                    return DropdownMenuItem<int>(
                      value: n,
                      child: Text('$n'),
                    );
                  }),
                ),
                SizedBox(height: 16.0),
                // Affiche les champs d'âge pour chaque enfant
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ageFields,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:google_fonts/google_fonts.dart';
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

class SearchFiltrage extends StatefulWidget {
  SearchFiltrage({
    super.key,
    //required this.products,
    //  required this.counter,
  });
  List<Hotels> products = [];
  // bool showContainer;
  @override
  _SearchFiltrageState createState() => _SearchFiltrageState();
}

class _SearchFiltrageState extends State<SearchFiltrage> {
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
    //  verifier(item);
  }

  String inputValue = '';
  List<Hotels> filteredHotels = [];
  bool Rating = false;
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

      //print('filteredHotels$filteredHotels');
      //  _data = filteredHotels;
      //print('filteredHotels$_data');
      if (filteredHotels.isNotEmpty) {
        filteredHotels.addAll(filteredHotelsName);
        print('_data123$_data');

        // Réinitialiser le PagingController

        // Fetch new data

        setState(() {
          widget.products = filteredHotels;
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SearchFiltrage(
                      //products: widget.products
                      )),
          ); 
/* Navigator.pushNamed(context, '/search', arguments: widget.products); */
          //_data.clear();
          //_fetchData(0);
          //    Rating = true;

          /*  _data = filteredHotels;
          _data.addAll(filteredHotels);
          print('filteredHotels$_data'); */
          // print('_data$_data');
        });
        /*  setState(() {
       
    Rating = true;
  });
 */
        // _pagingController.refresh();
      }
    }
  }
  Future<void> filtreByPrix(int minprix,int  maxprix) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> hotelsJsonList = prefs.getStringList('products') ?? [];

    final hotelsList = hotelsJsonList
        .map((hotelJson) => Hotels.fromJson(json.decode(hotelJson)))
        .toList();
    //filteredHotels.clear();
    List<Hotels> filteredHotelsName = [];

    for (Hotels hotelSeller in hotelsList) {
      filteredHotels =
          hotelSeller.filterHotelsByPrix(hotelsList, minprix,maxprix).toList();

      //print('filteredHotels$filteredHotels');
      //  _data = filteredHotels;
      //print('filteredHotels$_data');
      if (filteredHotels.isNotEmpty) {
        filteredHotels.addAll(filteredHotelsName);
        print('_data123$_data');

        // Réinitialiser le PagingController

        // Fetch new data

        setState(() {
         widget.products = filteredHotels;
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SearchFiltrage(
                      //products:  widget.products
                      )),
          ); 
/* Navigator.pushNamed(context, '/search', arguments: widget.products); */
          //_data.clear();
          //_fetchData(0);
          //    Rating = true;

          /*  _data = filteredHotels;
          _data.addAll(filteredHotels);
          print('filteredHotels$_data'); */
          // print('_data$_data');
        });
        /*  setState(() {
       
    Rating = true;
  });
 */
        // _pagingController.refresh();
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

      //print('filteredHotels$filteredHotels');
      //  _data = filteredHotels;
      //print('filteredHotels$_data');
      if (filteredHotels.isNotEmpty) {
        filteredHotels.addAll(filteredHotelsSellers);
        print('_data123$_data');

        // Réinitialiser le PagingController

        // Fetch new data

        setState(() {
          widget.products = filteredHotels;
          Navigator.pushNamed(
                                              context, '/search');
          /* Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SearchFiltrage(
                      //products: widget.products
                    )),
          ); */

          //_data.clear();
          //_fetchData(0);
          Rating = true;

          /*  _data = filteredHotels;
          _data.addAll(filteredHotels);
          print('filteredHotels$_data'); */
          // print('_data$_data');
        });
        /*  setState(() {
       
    Rating = true;
  });
 */
        // _pagingController.refresh();
      }
    }
  }

//end

  List<bool> favoriteStatusList = [];
  List<bool> isExtraFeaturesList = [];
  bool isFavorite = false;
  List<String> Fvouris = [];

  late int selectedFavoriteIndex;

  Future<void> _fetchData(int pageKey) async {
    // Simulate data fetching from local storage

      final prefs = await SharedPreferences.getInstance();
    List<String> hotelsJsonList = prefs.getStringList('productsFiltrer') ?? [];

    final hotelsList = hotelsJsonList
        .map((hotelJson) => Hotels.fromJson(json.decode(hotelJson)))
        .toList(); 

    favoriteStatusList =
        List.generate(hotelsList.length, (index) => false);
    isExtraFeaturesList =
        List.generate(hotelsList.length, (index) => false);

    final lenghtList = hotelsList.length;
    /* if (Rating) {
      setState(() {
         _data.clear();
           hotelsList.clear();
    _data.addAll(filteredHotels);
      
        
        lenghtList == _data.length;
        hotelsList == _data;
     //    _pagingController.refresh();
     //  _data == filteredHotels;
      
      });
    }   */
    print(lenghtList);
    print('filteredHotels456$filteredHotels');
    // Generate new data for the current page
    final startIndex = pageKey * 1;
    final endIndex = startIndex + 1;

    if (endIndex < hotelsList.length) {
      List<Hotels> newData = hotelsList.sublist(startIndex, endIndex);

      /* setState(() {
        _data.addAll(newData);
        print('added$startIndex');
      }); */

      final isLastPage = endIndex >= hotelsList.length;
      if (isLastPage) {
        _pagingController.appendLastPage(_data);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newData, nextPageKey);
      }
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: !Responsive.isDesktop(context)
            ? Color.fromARGB(255, 255, 255, 255)
            : null,
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
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
              HeaderContainer(),
              //  if(!Rating)
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
                              height:
                                  Responsive.isDesktop(context) ? 500.h : 420.h,
                              width: 2000,
                              child: Stack(

                                  // width: 2000,
                                  children: [
                                    Container(
                                      width: 2000,
                                      //height: Responsive.isDesktop(context) ? 700 : 400,
                                      height: 400.h,
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
                                          height: !Responsive.isDesktop(context)
                                              ? 550.h
                                              : 400,
                                          // margin: EdgeInsets.only(
                                          //     left: Responsive.isDesktop(context) ? 40 : 20),
                                          // Opacité de 50%// Couleur transparente avec une opacité de 50%

                                          //ajouter responsive moteur Recherche
                                          child: Responsive.isDesktop(context)
                                              ? MoteurWeb(
                                                  showContainer: showContainer,
                                                  counter: counter,
                                                )
                                              : MoteurMobile(),
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
                                                'Filtrer By HotelName:',
                                                style: GoogleFonts.roboto(
                                                  textStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.normal,
                                                    fontStyle: FontStyle.italic,
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
                                                        print('ghhhhh');
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
                                              SizedBox(height: 10.0),
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
                                              SizedBox(
                                                height: 8.h,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Catégories',
                                                    style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                        fontSize: 25.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.italic,
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
                                                        'Filtrer By Price:',
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
                                                          Text(
                                                              '\$${_selectedPriceRange.start.toStringAsFixed(2)}'),
                                                          Text(
                                                              '\$${_selectedPriceRange.end.toStringAsFixed(2)}'),
                                                        ],
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                       /*   filtreByPrix(_selectedPriceRange.start.toInt(), _selectedPriceRange.end.toInt()); */
    // Appliquer le filtre de prix
    // filterByPrice(_selectedPriceRange.start, _selectedPriceRange.end);
     int startPrice = _selectedPriceRange.start.toInt();
    int endPrice = _selectedPriceRange.end.toInt();
    filtreByPrix(startPrice, endPrice);
                                                        },
                                                        child:
                                                            Text('Appliquer'),
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
                                        height: (isExtraFeatures &&
                                                Responsive.isDesktop(context))
                                            ? 400.h
                                            : (isExtraFeatures &&
                                                    !Responsive.isDesktop(
                                                        context))
                                                ? 500.h
                                                : (!isExtraFeatures &&
                                                        !Responsive.isDesktop(
                                                            context))
                                                    ? 300.h
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
                                                          fontSize: 22.sp,
                                                          color: Color.fromARGB(
                                                              255,
                                                              103,
                                                              103,
                                                              103),
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                              height: 35
                                                                  .h, // Adjust the height as needed
                                                              width:
                                                                  1, // Set the width to define the separator line thickness
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
                                                      // SizedBox(height: 1.h),

                                                      /*  Text(
  'Price: ${item.hotel.lowPrice.toString()}  ${item.hotel.currency.toString()}',
 // Liste des tailles de police pour différentes tailles d'écran
  style: GoogleFonts.roboto(
    textStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    ),
                                                        ) ), */

                                                      /* Text(
                                                        'Total pour 1 Chambre(s) x 7 Nuits',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          textStyle: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ),
 */
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

                                                      //  SizedBox(height: 10.sp),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if (!Responsive.isDesktop(context))
                                              AnimatedSize(
                                                duration: const Duration(
                                                    milliseconds: 600),
                                                curve: Curves.ease,
                                                child: Container(
                                                  height: isExtraFeatures
                                                      ? null
                                                      : 45,

                                                  /*   padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10), */
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 156, 156, 156),
                                                        offset: Offset(0,
                                                            2), // Décalage vertical de l'ombre
                                                        blurRadius:
                                                            2, // Rayon de flou de l'ombre
                                                      ),
                                                    ],
                                                    color: Color(0xFFF7F7FA),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          isExtraFeatures =
                                                              !isExtraFeatures;
                                                          /*  isExtraFeaturesList[
                                                                  index] =
                                                              !isExtraFeaturesList[
                                                                  index]; */

                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          // height: double.maxFinite,

                                                          color: Colors
                                                              .transparent,
                                                          padding:
                                                              EdgeInsets.only(
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
                                                                'Voir Tous les vendeurs ',
                                                                style:
                                                                    GoogleFonts
                                                                        .roboto(
                                                                  textStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                  ),
                                                                ),
                                                              ),
                                                              RotatedBox(
                                                                quarterTurns:
                                                                    isExtraFeatures
                                                                        ? 25
                                                                        : 0,
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 15.sp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      if (isExtraFeatures)
                                                        Container(
                                                          //  height: 200.h,
                                                          height: 200.h,

                                                          width: double
                                                              .maxFinite, // Set a fixed height for the SingleChildScrollView
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              children: item
                                                                  .sellers
                                                                  .map(
                                                                      (seller) =>
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
                                                                              /*  Text(
                                                                                'À partir de ' + seller.prixSeller +'TND',
                                                                                style:  TextStyle(
                                                                                  fontWeight: FontWeight.w300,
                                                                                  color: Colors.black,
                                                                                  fontSize: 18.sp,
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
                                                                                        color: Colors.red,
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
                                                                                    var url = seller.detailsLink;
                                                                                    if (await canLaunch(url)) {
                                                                                      await launch(url);
                                                                                    } else {
                                                                                      throw 'Impossible d\'ouvrir $url';
                                                                                    }
                                                                                    /*  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WebViewPage(url: seller.detailsLink),
    ),
  ); */
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.visibility,
                                                                                    size: 24.sp,
                                                                                    color: Color.fromARGB(255, 0, 0, 0),
                                                                                  ),
                                                                                  /* Text(
                                                                                    'Voir Offer',
                                                                                    style: GoogleFonts.roboto(
                                                                                      textStyle: TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontStyle: FontStyle.normal,
                                                                                      ),
                                                                                    ),
                                                                                  ), */
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 5.w),
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
                                                                                'Voir Tous les vendeurs ',
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
                                                                                                    color: Colors.red,
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

                                                            SizedBox(
                                                                height: 5.h),
                                                            Text(
                                                              'Total pour 1 Chambre(s) x 7 Nuits',
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
                                                                height: 10),
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
              ),
              // if(Rating)
            ]));
  }
}
