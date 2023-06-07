import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3_market_place/MyScreen/responsive.dart';
import 'package:t3_market_place/MyScreen/hotelsPage.dart';
// import 'package:web/models/ApiHotels&Sellers.dart';

//import '../models/Api_Hotel_Sellers.dart';
import '../models/ApiHotels&Sellers.dart';
//import '../models/hotel_Response.dart';
import 'ResponsiveHotelView.dart';

class MoteurMobile extends StatefulWidget {
  @override
  State<MoteurMobile> createState() => _MoteurMobileState();
}

DateTime checkInDate = DateTime.now();

DateTime checkOutDate = checkInDate.add(Duration(days: 1));
String _selectedCity = "sousse";

class _MoteurMobileState extends State<MoteurMobile> {
  int nbEnfants = 0;
  int nbAdultes = 0;
  int Nbchambres = 0;
  //Map<String, dynamic>? receivedBody;

  Map<String, Object>? receivedBody = {
    "checkIn": checkInDate.toString(),
    // "checkIn": "$checkInDate",
    // "checkIn":"2023-06-27",
    // "checkOut":"2023-06-28",
    "checkOut": "$checkOutDate",
    //  "checkOut": chekout,
    //"checkOut":"$checkOutDate",
    "city": _selectedCity,
  };

  late Map<String, Object> combinedBody;
  void afficherDonnees(
      int Nbchambres, int enfants, int adultes, Map<String, Object> body) {
    setState(() {
      nbEnfants = enfants;
      nbAdultes = adultes;
      Nbchambres = Nbchambres;
      // receivedBody = body;
      receivedBody!.addEntries(body.entries);
      //receivedBody!.addAll(body);
      combinedBody = {...?receivedBody, ...body};
    });
  }

  final TextEditingController _textEditingController = TextEditingController();

  final TextEditingController _checkInController = TextEditingController();

  final TextEditingController _checkOutController = TextEditingController();

  List<Hotels> productsSession = [];

  List<Hotels> products = [];

  bool _showContainer = false;

  bool _showCircuitContainer = false;

  bool _showVisaContainer = false;

  bool _showHotelContainer = true;

  Color _color = Color.fromARGB(255, 255, 255, 255);

  Color _color1 = Color.fromARGB(255, 255, 255, 255);

  Color _color3 = Color.fromARGB(255, 255, 255, 255);

  Color _colorBlanc = Color.fromARGB(255, 248, 247, 248);

  Color _color2 = Color.fromARGB(255, 255, 253, 253);
  Color _Textcolor = Color.fromARGB(255, 0, 0, 0);

  bool _isCodeVisible = false;

  //code of modal
  bool _isModalVisible = false;

  bool condition = true;
  // Remplacez "true" par votre condition
  List<String> _options = ['tunis', 'sfax', 'touzer'];

  List<String> _options2 = [
    'Tous les thèmes',
    'Culture',
    'Découverte',
    'Saharien',
    'Aventure',
    'Histoire',
    'Terre & Mer'
  ];

  List<String> Pays = [
    'Iran',
    'Allemagne',
    'Autriche ',
    'Croatie',
    'BULGARIE',
    'Jordanie',
    'Maroc'
  ];

  List<String> Budget = [
    'Tous les Budgets',
    'Moins de 2000',
    'Entre 2001 et 4000 ',
    'Entre 4001 et 7000',
    '7001 et plus',
  ];

  List<String> Visa = [
    'Visa',
    'avec Visa',
    'sans Visa ',
  ];

  List<String> _options3 = [
    'toutes',
    '1 jour',
    'Entre 2 et 4 jours',
    'Entre 5 et 9 jours',
    '10 jours et plus'
  ];

  List<String> _options4 = [
    'Toutes les saisons',
    'Printemps',
    'Eté',
    'Automne',
    'Hiver'
  ];
  List<String> _options5 = [
    'Sousse',
    'Sousse,Hammamet',
    'Tunis',
    'Touzer',
    'Monastir',
    // 'Klibya'
  ];

  List<int> _options_Ages = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  List<String> _selectedOption1 = ['tunis'];

  List<String> _selectedOption2 = ['Tous les thèmes'];

  List<String> _selectedOption3 = ['toutes'];

  List<String> _selectedOption4 = ['Eté'];
  List<String> _selectedOption5 = ['Sousse'];

  List<String> _selectedOptionPays = ['Iran'];

  List<String> _selectedOptionVisa = ['Visa'];

  List<String> _selectedOptionBudget = ['Tous les Budgets'];

  var SommePersonnes2 = 0;

  //end code
  late TextEditingController _city = TextEditingController();

//late DateTime _checkIn;
  late DateTime _checkOut;

//int _numAdults = 1;
  int _numChildren = 0;

  List<int> _childrenAges = [1, 2, 3, 4];

  List<int> _childrenAges1 = [1];

  late int _children = 2;

  List<int> _childrenAges2 = [1, 2];

  List<int> _childrenAges3 = [1, 2, 3];

  int selectedAdults = 0;

  // bool _loading = true;
  late int adult1 = 0;

  late int adult2 = 0;

  late int adult3 = 0;

  late int enfant1 = 0;

  late int enfant2 = 0;

  late int enfant3 = 0;
bool RechercheLoading = false;

  /*  Future<void> fetch() async {
    setState(() {
      fetchPosts();
    });
  } */
  void _showModal2() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: FractionallySizedBox(
              widthFactor: 0.8, // Adjust the width factor as per your needs
              child: Container(
                color: null,
                height: 200,
                width: 700,
              )),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //  fetchPosts();

  }
  
  List<Map<String, dynamic>> occupanciesList = [];

  // List<Map<String, dynamic>> occupancies = [];
  Map<String, dynamic> occupancies = {};

  //end fetchHotels
  void sendData() {
    final body = {
      //  "checkIn": DateTime.parse(checkInDate    ),
      //"checkOut": DateTime.parse(checkOutDate ),
      // "checkIn": "$checkInDate",
      // "checkOut": "$checkOutDate",
      "city": _selectedCity,
      "hotelName": "",
      "boards": [],
      "rating": [],
      "occupancies": {
        for (int i = 1; i <= NbChambres2; i++)
          "$i": {
            "adult": i == 1
                ? adult1.toString()
                : i == 2
                    ? adult2.toString()
                    : adult3.toString(),
            "child": {
              "value": i == 1
                  ? enfant1.toString()
                  : i == 2
                      ? enfant2.toString()
                      : enfant3.toString(),
              "age": _children.toString(),
            },
          },
      },
      "channel": "b2c",
      "language": "fr_FR",
      "onlyAvailableHotels": false,
      "marketId": "1",
      "customerId": "7",
      "backend": 0,
      "filtreSearch": []
    };
    print(body);
    /*  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductsPage(
                Mesproducts: products,
              )),
    ); */
  }

  Future<void> fetchHotels() async {
    final url = Uri.parse('http://user3-market.3t.tn/ApiHotel/getApiHotels');

    combinedBody;

    print(combinedBody);

    final response =
        await http.post(url, headers: null, body: jsonEncode(combinedBody));
    debugPrint(response.body);
    //print(result);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      //var rest = jsonData["response"] as List;
      String firstKey = jsonData.keys.first;

      print(firstKey);
      /*  products = jsonData
          .map<Hotels>((json) => Hotels.fromJson(json))
          .toList();  */
      Map<String, Hotels> hotelsMap = hotelsSellersFromJson(response.body);
      List<Hotels> products = hotelsMap.values.toList();

      //solution of chat

//var jsonData = jsonDecode(response.body);

      // var hotelData = jsonData[hotelName]; // Access the hotel data
      //List<dynamic> sellerData = hotelData['seller']; // Access the seller data

      //Hotel hotel = Hotel.fromJson(jsonData);

      // List<Seller> sellers = sellerData.map<Seller>((seller) => Seller.fromJson(seller)).toList();
      //hotel.seller = sellers;

      // List<Hotel> products = [hotel];

      //print(products);
      //e,nd solution

      //store in session
      final prefs = await SharedPreferences.getInstance();
     
       
      if (prefs.getString('checkin') != null &&
          prefs.getString('checkout') != null) {
        prefs.remove('checkin');
         prefs.remove('checkout');
      
      }
   prefs.setString('checkin', '$checkInDate');
        prefs.setString('checkout', '$checkOutDate');

      //setData
      List<String> productsJsonList =
          products.map((product) => json.encode(product.toJson())).toList();
      prefs.setStringList('products', productsJsonList);
      //getData
      List<String> productsJsonLists = prefs.getStringList('products') ?? [];
      if (productsJsonList.isNotEmpty) {
        productsSession = productsJsonLists
            .map((productJson) => Hotels.fromJson(json.decode(productJson)))
            .toList();
      }
      //end session
      /*  setState(() {
        loading = false;
      }); */

      // print(products);

      /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsPage(
                  Mesproducts: productsSession,
                )),
      ); */
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  //end teste
  void _showModal() {
    setState(() {
      _isModalVisible = true;
      SommePersonnes = 0;
      print('SommePersonnes2  quand j\'ouvre, $SommePersonnes2');
      print('SommePersonnes  quand j\'ouvre, $SommePersonnes');
    });
  }

  void _hideModal() {
    setState(() {
      _isModalVisible = false;
      SommePersonnes = NbPersonnes2 + NbPersonnes1 + NbPersonnes;
      if (SommePersonnes != 0) {
        SommePersonnes2 = 0;
        SommePersonnes2 = SommePersonnes;
        print('SommePersonnes2 quand je ferme  $SommePersonnes2');
        print('SommePersonnes  quand je ferme $SommePersonnes');
      }
      // print('Somme$SommePersonnes');
    });
  }

  //add variable of select_CHambre
  int _maxFields = 3;

  int _numFields = 1;

  List<int> _optionsChambre = [0, 1, 2, 3, 4];

  // List<int> _options = [0, 1, 2, 3, 4, 5];
  List<int> _options_Ages1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

  List<int> _selected1 = [1];

  List<int> _selected2 = [1];

  List<int> _selected3 = [1];

  late int _numField;

  //List<List<int>> _selectedAges = [[]];
  List<List<int>> _selectedAges = [[], [], []];

  var ageFieldIndex;

  var AgeIndexOne;

  var AgeIndexTwo;

  var AgeIndexTHree;

  // bool _isCodeVisible = false;
  void _addSelectFields() {
    if (_numFields < _maxFields) {
      setState(() {
        _numFields++;
        _selected1.add(1);
        _selected2.add(1);
        // _selectedAges.add([1, 2]);
        _selected3.add(1);
        print('_numFields$_numFields');
      });
    } else {
      // handle maximum number of fields reached
      // for example, you can show a snackbar or a dialog
      // to inform the user that they cannot add more fields
    }
  }

  //add champ d'age
  void _addSelectAge(int index) {
    setState(() {
      _selectedAges[index].add(index);
    });
  }

  /*  void _addSelectAge() {
    // Effacer toutes les valeurs d'âge précédentes
    _selectedOption3[index].clear();

    // Ajouter les champs de sélection d'âge pour chaque enfant
    for (int i = 0; i < _selectedOption2[index]; i++) {
      _selectedAges[index].add(0); // Ajouter une valeur d'âge par défaut
    }
  } */
  void _removeSelectAge(int fieldIndex, int ageIndex) {
    setState(() {
      _selectedAges[fieldIndex].removeAt(ageIndex);
    });
  }

  void _removeSelectFields(int index) {
    setState(() {
      if (_numFields != 1) {
        _numFields--;

        _selected1.removeAt(_numFields);
        _selected2.removeAt(_numFields);
        _selected3.removeAt(_numFields);
        //_selectedAges.removeAt(_numFields);
      }
    });
  }

  var NbChambres2 = 1;

  var NbPersonnes = 0;

  var NbPersonnes1 = 0;

  var NbPersonnes2 = 0;

  var SommePersonnes = 0;

  void _onChangedValue() {
    setState(() {
      var SommePersonnes = NbPersonnes2 + NbPersonnes1 + NbPersonnes;
    });
  }

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //add a new container

            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(5),
                 /* boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 156, 156, 156),
                    offset: Offset(0, 2), // Décalage vertical de l'ombre
                    blurRadius: 2, // Rayon de flou de l'ombre
                  ),
                ],   */
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showCircuitContainer = false;
                                  _showVisaContainer = false;
                                  _showHotelContainer = true;

                                  _color = _color2;
                                  _color1 = _colorBlanc;
                                  _color3 = _colorBlanc;

                                  /* if (_showHotelContainer = true) {
                        _color = _color2;
                      } else {
                        _color = _color;
                      }  */
                                });
                              },
                              child: Container(
                                  //   width: Responsive.isTablet(context) ? 150 : 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    //  color: Color.fromARGB(255, 255, 255, 255),
                                    //  color: _color,
                                    borderRadius: BorderRadius.circular(5),
                                    /*  border: Border.all(
                                    color: Color.fromARGB(255, 3, 3, 3),
                                    width: 1,
                                  ), */
                                    boxShadow: [
                                      /*  BoxShadow(
                                  color: Color.fromARGB(255, 137, 135, 135)
                                      .withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                ),  */
                                    ],
                                  ),
                                  child: Center(
                                      child: Column(children: [
 
                                    

                                    Row(
                                      children: [
                                        Icon(
                                          Icons.hotel,
                                          size: 25.sp,
                                          color: _showHotelContainer
                                              ? _Textcolor
                                              : Colors.black,
                                        ),
                                        Text(
                                          'Hotels ',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: _showHotelContainer
                                                ? _Textcolor
                                                : Color.fromARGB(
                                                    255, 157, 157, 157),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      ],
                                    ),
                                    //   if (_showHotelContainer)
                                    // SizedBox(height: 10),
                                   if (_showHotelContainer &&
                                  MediaQuery.of(context).size.width < 358
                                        )
                                       // SizedBox(height: 2.h,),
                                      
                                     DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              width: 2.w,
                                            ),
                                          ),
                                        ),
                                        child: SizedBox(
                                          height: 5.h,
                                          width: 70.w,
                                        ),
                                        )     
                                  ]))),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showCircuitContainer = true;
                                  _showVisaContainer = false;
                                  _showHotelContainer = false;
                                  _color = _colorBlanc;
                                  _color1 = _color2;
                                  _color3 = _colorBlanc;
                                  /*  if (_showCircuitContainer = true) {
                        _color1 = _color2;
                      } else {
                        _color1 = _color;
                      } */
                                });
                              },
                              child: Container(
                                //  width: Responsive.isTablet(context) ? 150 : 80,
                                height: 30,
                                decoration: BoxDecoration(
                                  //color: Color.fromARGB(255, 255, 255, 255),

                                  //   color: _color1,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    /* BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                  
                                ), */
                                  ],
                                ),
                                child: Center(
                                    child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.alt_route,
                                          size: 25.sp,
                                          color: _showCircuitContainer
                                              ? _Textcolor
                                              : Colors.black,
                                        ),
                                        Text(
                                          'Tours ',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: _showCircuitContainer
                                                ? _Textcolor
                                                : Color.fromARGB(
                                                    255, 157, 157, 157),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_showCircuitContainer)
                                      SizedBox(width: 3.w),
                                    if (_showCircuitContainer &&
                                        MediaQuery.of(context).size.width < 360)
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 23, 23, 23),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: SizedBox(
                                          height: 5,
                                          width: 70,
                                        ),
                                      ),
                                  ],
                                )),
                              ),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            /* ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showCircuitContainer = false;
                      _showVisaContainer = true;
                      _showHotelContainer = false;
                    });
                  },
                  child: Text('Visa'),
                ), */
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showCircuitContainer = false;
                                  _showVisaContainer = true;
                                  _showHotelContainer = false;
                                  _color = _colorBlanc;
                                  _color1 = _colorBlanc;
                                  _color3 = _color2;
                                  /*  if (_showVisaContainer = true) {
                        _color3 = _color2;
                      } else if (_showCircuitContainer == true ||
                          _showVisaContainer == true) {
                        _color3 = _color3;
                      } */
                                });
                              },
                              child: Container(
                                //width: Responsive.isTablet(context) ? 150 : 80,
                                height: 30,
                                decoration: BoxDecoration(
                                  //  color: Color.fromARGB(255, 255, 255, 255),
                                  //  color: _color3,

                                  borderRadius: BorderRadius.circular(5),

                                  boxShadow: [
                                    /*  BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ), */
                                  ],
                                ),
                                child: Center(
                                    child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.flight,
                                          size: 25.sp,
                                          color: _showVisaContainer
                                              ? _Textcolor
                                              : Color.fromARGB(255, 10, 10, 10),
                                        ),
                                        Text(
                                          'Traveling ',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: _showVisaContainer
                                                ? _Textcolor
                                                : Color.fromARGB(
                                                    255, 157, 157, 157),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        )
                                      ],
                                    ),
                                    // if(_showVisaContainer)
                                    //   SizedBox(width: 3.w),
                                    if (_showVisaContainer &&
                                        MediaQuery.of(context).size.width < 360)
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 23, 23, 23),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: SizedBox(
                                          height: 5,
                                          width: 70,
                                        ),
                                      ),
                                  ],
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  if (_showHotelContainer)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              /*  Text(
                                "Destination",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.alike(
                                  textStyle:
                                      Theme.of(context).textTheme.displayMedium,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ), */
                              SizedBox(height: 2),
                              Container(
                              
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 157, 157, 157),
                                    width: 1,
                                  ),
                                ),
                                child:
                                    /* TextField(
                                  controller: _city,
                                  decoration: InputDecoration(
                                    hintText: 'where are you going ?',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 46, 4, 255),
                                        width: 5.0,
                                      ),
                                    ),
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ), */
                                    DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                  // suffixIcon: Icon(Icons.search,color: Colors.black,),
                                   // contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                    //   labelText: 'Destination',
                                    //iconColor:Colors.black,
                                    border: InputBorder.none,
                                    //   border: OutlineInputBorder(),
                                  ),
                                  value: _selectedOption5[0],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedOption5[0] = newValue!;
                                      _selectedCity = newValue;
                                      if (receivedBody != null) {
                                        receivedBody!["city"] = newValue;
                                      }
                                      print('_selectedCity$_selectedCity');
                                      //  print('_selectedCity$_selectedCity');
                                    });
                                  },
                                  items: _options5.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Row(
                                        children: [Icon(Icons.search,color: Colors.black,),  Center(
                                            child:Align(
                                              alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                              option.toString(),
                                              selectionColor:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              textAlign: TextAlign
                                                  .center, // Centrer le texte horizontalement
                                            ),
                                       ) ))],
                                       ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  if (_showHotelContainer)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //  Padding(
                          //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          /* Text(
                            'Check In date',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.alike(
                              textStyle:
                                  Theme.of(context).textTheme.displayMedium,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ), */

                          SizedBox(height: 1),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromARGB(255, 157, 157, 157),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              /*  boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ], */
                            ),
                            child: Row(
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd').format(checkInDate),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: checkInDate,
                                      firstDate: DateTime.now(),
                                      //  firstDate: DateTime(2023),
                                      lastDate: DateTime(2030),
                                    ).then((pickedDate) {
                                      if (pickedDate != null &&
                                          pickedDate != checkInDate) {
                                        setState(() {
                                          checkInDate = pickedDate;
                                          receivedBody!["checkIn"] =
                                              pickedDate.toString();

                                          checkOutDate = checkInDate
                                              .add(Duration(days: 1));

                                          receivedBody!["checkOut"] =
                                              checkOutDate.toString();
                                        });
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.calendar_month_outlined,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  if (_showHotelContainer)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*   Text(
                            'Check Out date',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.alike(
                              textStyle:
                                  Theme.of(context).textTheme.displayMedium,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ), */
                          SizedBox(height: 1),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromARGB(255, 157, 157, 157),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  ' ${DateFormat('yyyy-MM-dd').format(checkOutDate)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // checkInDate ==
                                    //     receivedBody!["checkIn"];
                                    showDatePicker(
                                      context: context,
                                      initialDate: checkOutDate,
                                      firstDate:
                                          checkInDate.add(Duration(days: 1)),
                                      // firstDate: DateTime(2023),
                                      lastDate: DateTime(2030),
                                      selectableDayPredicate: (DateTime date) {
                                        // disable dates before today and before check-in date
                                        return date.isAfter(DateTime.now()) &&
                                            date.isAfter(checkInDate
                                                .subtract(Duration(days: 1)));
                                      },
                                    ).then((pickedDate) {
                                      if (pickedDate != null &&
                                          pickedDate != checkOutDate) {
                                        setState(() {
                                          checkOutDate = pickedDate;
                                          receivedBody!["checkOut"] =
                                              pickedDate.toString();
                                          /*   receivedBody![
                                                              "checkOut"] ==
                                                          pickedDate.toString();
                                                      print(receivedBody![
                                                          "checkOut"]);
                                                      print(
                                                          'pickedDatestring${pickedDate.toString()}'); */
                                        });
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.calendar_month_outlined,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 5.sp,
                  ),
                  if (_showHotelContainer)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              /*  Text(
                                "Destination",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.alike(
                                  textStyle:
                                      Theme.of(context).textTheme.displayMedium,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ), */
                              SizedBox(height: 2.h),
                              Container(
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 157, 157, 157),
                                      width: 1,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        //  _isChampsChambresVisible = true;
                                        //_showModalContent();
                                        //  _showModal(context);

                                        // Add your function here

                                        /* showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return MyModal(
                                                counter: selectedAdults,
                                                addSelectFields:
                                                    _addSelectFields,
                                                removeSelectFields:
                                                    _removeSelectFields,
                                                callbackFunction:
                                                    afficherDonnees,
                                              );
                                            }); */
                                            

                                       showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                             isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                            //  width: double.maxFinite,
                                              color: Colors.white,
                                             /*  decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      16.0), // Arrondit les coins supérieurs
                                                ),
                                                border: Border.all(
                                                  color: Color.fromARGB(
                                                      255,
                                                      255,
                                                      255,
                                                      255), // Couleur de la bordure (optionnel)
                                                  width:
                                                      2.0, // Largeur de la bordure (optionnel)
                                                ),
                                              ), */
                                              //padding: EdgeInsets.all(0.0), // Ajoute un espacement autour du contenu
                                              child: MyModalMobile(
                                                counter: selectedAdults,
                                                addSelectFields:
                                                    _addSelectFields,
                                                removeSelectFields:
                                                    _removeSelectFields,
                                                callbackFunction:
                                                    afficherDonnees,
                                              ),
                                            );
                                          },
                                        ); 

                                        // print('counter${myModal.counter}');
                                        //   _isCodeVisible = true;
                                        //   _showModal();

                                        //   print('Container clicked!');
                                        //_showModal2();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 9),
                                        child: Row(
                                      children: [
                                       
                                        Icon(
                                          Icons.key,
                                          size: 20.sp,
                                          color: Color.fromARGB(
                                              255, 144, 144, 144),
                                        ),
                                        Text(
                                          //"Chambres $NbChambres2 et $SommePersonnes2 Personne(s)",
                                         // '$Nbchambres:Room,$nbAdultes:adult,$nbEnfants:enfant',
                                         'Rooms,Adults,Children',
                                          style: GoogleFonts.alike(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,fontWeight: FontWeight.bold,
                                              fontSize: 18.sp,
                                              color: Colors.black),
                                        ),
                                      ],
                                    )),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  /* Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Occupancies',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.alike(
                              textStyle:
                                  Theme.of(context).textTheme.displayMedium,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 1),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromARGB(255, 5, 5, 5),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [],
                            ),
                          ),
                        ],
                      ),
                    ), */
                  //add container

                  /*   Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 246, 246, 246)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.all(15),
                        child: TextButton(
                          onPressed: () async {
                            await fetchHotels();
                          },
                          style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 10, 3, 2)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                               // Color.fromARGB(255, 223, 2, 2)
                                   Color.fromARGB(255, 10, 3, 2)
                                ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                /*  side: BorderSide(
                                  color: Color.fromARGB(255, 254, 254, 255)
                                      .withOpacity(0.2),
                                  width: 3.0,
                                ), */
                              ),
                            ),
                          ),
                          child: Container(
                            width: Responsive.isTablet(context)
                                ? 300
                               : double.infinity,
                                 //: 200,
                            height: 40,
                            child: Center(
                              child: Text(
                                'search hotels',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Color.fromARGB(255, 248, 248, 248),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )),
 */
                  SizedBox(
                    height: 3.h,
                  ),
                  if (_showHotelContainer)
                    Container(
                        margin: EdgeInsets.all(10),
                        width: Responsive.isTablet(context)
                            ? 300
                            : double.infinity,
                        //: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 246, 246, 246)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                             setState(() {
                                            RechercheLoading =
                                                true; // Activer l'état de chargement
                                          });
                            await fetchHotels();
                            Navigator.pushNamed(context, '/Hotels');
                             setState(() {
                                            RechercheLoading =
                                                false; // Activer l'état de chargement
                                          });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Color.fromARGB(255, 212, 32, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          child: Text(
                            'Search hotels',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 254, 254, 254),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
                  SizedBox(
                    height: 1.h,
                  ),
 if (_showHotelContainer && RechercheLoading)
                      Container(
                        width: double.infinity,
                        height: 50.h,
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                          //  SizedBox(height: 1.h),
                          //  Text('Veuillez patienter...',style: TextStyle(color: Colors.black),),
                          ],
                        ),
                      ),
                        SizedBox(
                    height: 1.h,
                  ),
                   if (!RechercheLoading && _showHotelContainer)
                  Container(
                    child: Column(
                      children: [
                        Text(
                          'Become a vendor',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.alike(
                            textStyle:
                                Theme.of(context).textTheme.displayMedium,fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            var url =
                                "http://user3-market.3t.tn/admin/market/subscription/request/new";

                            // ignore: deprecated_member_use
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Impossible d\'ouvrir $url';
                            }
                            // Action à effectuer lorsque le bouton est pressé
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // Couleur de fond du bouton
                            onPrimary: Colors.red, // Couleur du texte du bouton
                            side: BorderSide(
                                color: Colors.red, width: 1), // Bordure rouge
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  30), // Forme arrondie (rounded pill)
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  //end container
                  //  if (_showHotelContainer)
                ],
              ),
            ),
          
//partie circuit 
if(_showCircuitContainer)
Container(padding: EdgeInsets.only(left:8,right: 8),
                           /*  decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromARGB(255, 157, 157, 157),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ), */ child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Ville',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: _selectedOption1[0],
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedOption1[0] = newValue!;
                                        });
                                      },
                                      items: _options.map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(  style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,),
                                         
                                        );
                                      }).toList(),
                                    ),),

                                    SizedBox(height: 5.h,),
                                    if(_showCircuitContainer)
                                    Container( padding: EdgeInsets.only(left:8,right: 8),
                           /*  decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color.fromARGB(255, 157, 157, 157),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                             */
                             child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Thème',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: _selectedOption2[0],
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedOption2[0] = newValue!;
                                        });
                                      },
                                      items: _options2.map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text( style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,),
                                        );
                                      }).toList(),
                                    ),
                            
                            ),   SizedBox(height: 5.h,),
                          if(_showCircuitContainer)
                                    Container( padding: EdgeInsets.only(left:8,right: 8),
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Durée',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: _selectedOption3[0],
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedOption3[0] = newValue!;
                                        });
                                      },
                                      items: _options3.map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text( style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,),
                                        );
                                      }).toList(),
                                    ),),   SizedBox(height: 5.h,),
                                    if(_showCircuitContainer)
                                    Container( padding: EdgeInsets.only(left:8,right: 8),
                                     child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Saison',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: _selectedOption4[0],
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedOption4[0] = newValue!;
                                        });
                                      },
                                      items: _options4.map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text( style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,),
                                        );
                                      }).toList(),
                                    ),
                                    ),   SizedBox(height: 5.h,),
                                    if(_showCircuitContainer)
                                    Container(
                        margin: EdgeInsets.all(15),
                        width: Responsive.isTablet(context)
                            ? 300
                            : double.infinity,
                        //: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 246, 246, 246)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: ()  {
                            
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Color.fromARGB(255, 212, 32, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          child: Text(
                            'Search Circuits',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 254, 254, 254),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),
//fin partie circuit 
//ajouter partie voyages
 if(_showVisaContainer)
                                    Container( padding: EdgeInsets.only(left:8,right: 8),
                                     child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Pays',
                                          border: OutlineInputBorder(),
                                     
                                        ),
                                        value: _selectedOptionPays[0],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedOptionPays[0] = newValue!;
                                          });
                                        },
                                        items: Pays.map((String option) {
                                          return DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,),
                                          );
                                        }).toList(),
                                      ),
                                    
                                    ),
                                     SizedBox(height: 5.h,),
                                     if(_showVisaContainer)
                                    Container( padding: EdgeInsets.only(left:8,right: 8),
                                     child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Thème',
                                          border: OutlineInputBorder(),
                                        ),
                                        value: _selectedOption2[0],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedOption2[0] = newValue!;
                                          });
                                        },
                                        items: _options2.map((String option) {
                                          return DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,),
                                          );
                                        }).toList(),
                                      ),
                                    
                                    ),
                                     SizedBox(height: 5.h,),
                                     if(_showVisaContainer)
                                    Container( padding: EdgeInsets.only(left:8,right: 8),
                                     child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Visa',
                                          border: OutlineInputBorder(),
                                        ),
                                        value: _selectedOptionVisa[0],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedOptionVisa[0] = newValue!;
                                          });
                                        },
                                        items: Visa.map((String option) {
                                          return DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,),
                                          );
                                        }).toList(),
                                      ),
                                    
                                    ),
                                     SizedBox(height: 5.h,),
                                     if(_showVisaContainer)
                                    Container( padding: EdgeInsets.only(left:8,right: 8),
                                    
                                     child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Saison',
                                          border: OutlineInputBorder(),
                                        ),
                                        value: _selectedOption4[0],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedOption4[0] = newValue!;
                                          });
                                        },
                                        items: _options4.map((String option) {
                                          return DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                     SizedBox(height: 5.h,),
                                           if(_showVisaContainer)  Container(
                        margin: EdgeInsets.all(15),
                        width: Responsive.isTablet(context)
                            ? 300
                            : double.infinity,
                        //: 200,
                        height: 40,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 246, 246, 246)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: ()  {
                            
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Color.fromARGB(255, 212, 32, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          child: Text(
                            'Search Voyages',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 254, 254, 254),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )),

//fin de partie voyage

          ],
        ),
      ),
    );
  }
}

//ajouter un modal
typedef ModalCallback = void Function(int nbEnfants, int nbAdultes);

class MyModalMobile extends StatefulWidget {
  final Function(int, int, int, Map<String, Object> body) callbackFunction;

  int counter;
  final void Function() addSelectFields;
  final void Function(int value) removeSelectFields;
  MyModalMobile(
      {required this.counter,
      required this.addSelectFields,
      required this.removeSelectFields,
      required this.callbackFunction});

  @override
  _MyModalMobileState createState() => _MyModalMobileState();
}

class _MyModalMobileState extends State<MyModalMobile> {
  int nbEnfants = 0;
  int nbAdultes = 0;
  int Nbchambres = 0;
  int counter = 0;
  // Map<String, dynamic> body;
  Map<String, dynamic> occupancies = {};
  void envoyerDonnees() {
    final body = {
      //  "checkIn": DateTime.parse(checkInDate    ),
      //"checkOut": DateTime.parse(checkOutDate ),
      /*  "checkIn": "$checkInDate",
      "checkOut": "$checkOutDate",
      "city": _selectedCity, */
      "hotelName": "",
      "boards": [],
      "rating": [],
      "occupancies": {
        for (int i = 1; i <= _numFields; i++)
          "$i": {
            "adult": _selectedAdults[i - 1].toString(),
            "child": {
              "value": _selectedChildren[i - 1].toString(),
              "age": _selectedAges[i - 1].join(',').toString(),
            },
          },
      },
      "channel": "b2c",
      "language": "fr_FR",
      "onlyAvailableHotels": false,
      "marketId": "1",
      "customerId": "7",
      "backend": 0,
      "filtreSearch": []
    };
    // Récupérez le nombre d'enfants et d'adultes depuis votre modal
    Nbchambres = _numFields; //NbChambres2;
   // nbEnfants =  //enfant1 + enfant2 + enfant3;
   // nbAdultes = 3; //adult1 + adult2 + adult3;
    widget.callbackFunction(Nbchambres, nbEnfants, nbAdultes, body);
  }

//current code
  int _numFields = 1;
  List<int> _selectedAdults = [1];
  List<int> _selectedChildren = [1];
  List<List<int>> _selectedAges = [
    [1]
  ];

  void addSelectFields() {
    if (_numFields < 3) {
      setState(() {
        _numFields++;
        _selectedAdults.add(1);
        _selectedChildren.add(1);
        _selectedAges.add([1]);
      });
    }
  }

  void removeSelectFields(int index) {
    setState(() {
      if (_numFields != 1) {
        _numFields--;
        _selectedAdults.removeAt(index);
        _selectedChildren.removeAt(index);
        _selectedAges.removeAt(index);
      }
    });
  }

  void getChildrenAges() {
    for (int i = 0; i < _selectedChildren.length; i++) {
      List<int> ages = [];
      for (int j = 0; j < _selectedChildren[i]; j++) {
        int age = _selectedAges[i][j];
        ages.add(age);
      }
      print(
          'Room ${i + 1} - Adults: ${_selectedAdults[i]}, Children: ${_selectedChildren[i]}, Ages: $ages');
    }
  }

  void makeRequest() {
    Map<String, dynamic> occupancies = {};
    for (int i = 1; i <= _numFields; i++) {
      occupancies["$i"] = {
        "adult": _selectedAdults[i - 1].toString(),
        "child": {
          "value": _selectedChildren[i - 1].toString(),
          "age": _selectedAges[i - 1].join(',').toString(),
        },
      };
    }
    print(occupancies);
  }

  @override
  Widget build(BuildContext context) {
    return 
    //Dialog(
        /* child:Scaffold(
      appBar: AppBar(
        title: Text('Age Selection'),
        actions: [
          ElevatedButton(
            onPressed: () {
              makeRequest();
            },
            child: Text('Press Me'),
          )
        ],
      ), */
        Container(
           // width: 500,
           // height: 400,
         //  color: Color.fromARGB(0, 208, 208, 208),
            width: double.infinity,
            height: 610,
            //version Web
// height:  double.infinity,
            child:SingleChildScrollView(child:
             Column(
              children: [
                Container(
                 decoration: BoxDecoration( 
         //   color: Color.fromARGB(255, 255, 255, 255),
         color: Color.fromARGB(255, 255, 255, 255),

        /*  borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0), // Arrondit les coins supérieurs
        ), */  boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 190, 190, 190).withOpacity(0.8),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2), // Offset in the downward direction
              ),
            ],
       
      ), 
                  
                  width: 900,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: 
                      Text(
                        'Rooms & Guests',
                        style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                     ) ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(2),
                        child: 
                       Row(
                        mainAxisAlignment: MainAxisAlignment.end
      , crossAxisAlignment: CrossAxisAlignment.end,
        children: [ CircleAvatar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        child: IconButton(
       icon: Icon(Icons.close),
          color: Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
     ],),) 
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _numFields,
                  itemBuilder: (BuildContext context, int index) {
                    var fieldNumber = index + 1;

                    return Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(2),
                            margin: EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Text(
                                  'Room $fieldNumber',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Spacer(),
                                if (index == 0)
                                   Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: Color.fromARGB(255, 94, 94, 94),
      width: 1,
    ),
    shape: BoxShape.circle,
  ),
                               
                                    child:Center(
                                    child: IconButton(
                                      icon: Icon(Icons.remove),
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      onPressed: () {
                                        removeSelectFields(index);
                                      },
                                    ),
                                    ) ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (index == 0)
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: Color.fromARGB(255, 94, 94, 94),
      width: 1,
    ),
    shape: BoxShape.circle,
  ),
                               
                                    child:Center(child:IconButton(
                                      icon: Icon(Icons.add),
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      onPressed: () {
                                        addSelectFields();
                                      },
                                    ), )
                                     
                                   
                                  )
                              ],
                            )),
                        /* ListTile(
                          title: Text(
                            'Chambre $fieldNumber',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                         
                          trailing: IconButton(
                            /*  icon: Icon(Icons.remove),
                  onPressed: () => removeSelectFields(index), */
                            icon: Icon(Icons.remove),
                            color: Color.fromARGB(255, 11, 11, 11),
                            onPressed: () {
                              removeSelectFields(index);
                            },
                          ),
                        ), */
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 8),
                                    //  height: 100,
                                    width: 70,

                                    child: DropdownButtonFormField<int>(
                                      decoration: InputDecoration(
                                        labelText: 'Adult',
                                        border: OutlineInputBorder(),
                                      ),
                                      value: _selectedAdults[index],
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedAdults[index] = newValue!;
                                        });
                                      },
                                      items:
                                          List.generate(5, (index) => index)
                                              .map((adultCount) {
                                        return DropdownMenuItem<int>(
                                          value: adultCount,
                                          child: Text(adultCount.toString(), style: TextStyle(
          color:  Colors.black,
        ),),
                                        );
                                      }).toList(),
                                      // Add this line for the hint text
                                      //  underline: Container(), // Remove the default underline
                                    ),
                                  ),

                                  SizedBox(width: 3.w),
                                  Container(
                                      //  height: 100,
                                      width: 70,
                                      child: DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          labelText: 'Child',
                                          border: OutlineInputBorder(),
                                        ),
                                        value: _selectedChildren[index],
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedChildren[index] =
                                                newValue!;
                                            _selectedAges[index] =
                                                List.generate(
                                                    newValue!, (index) => 1);
                                          });
                                        },
                                        items: List.generate(
                                                5, (index) => index )
                                            .map((childrenCount) {
                                          return DropdownMenuItem<int>(
                                            value: childrenCount,
                                            child:
                                                Text(childrenCount.toString(), style: TextStyle(
          color:  Colors.black,
        ),),
                                          );
                                        }).toList(),
                                      )),
                                  //ajouter les ages
                                  SizedBox(width: 3.w),
                                 
                                  //end ages
                                ],
                              ),
                            ),
                            // Expanded(
                            // child:

                            //   ),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Column(children: [
 Container(
  margin: EdgeInsets.only(left: 8),
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        _selectedChildren[index], (ageIndex) {
                                      return Row(
                                        children: [
                                          Container(
                                              width: 70,
                                              child:
                                                  DropdownButtonFormField<int>(
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Age ${ageIndex + 1}',
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: _selectedAges[index]
                                                    [ageIndex],
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _selectedAges[index]
                                                        [ageIndex] = newValue!;
                                                  });
                                                },
                                                items: List.generate(17,
                                                        (index) => index + 1)
                                                    .map((age) {
                                                  return DropdownMenuItem<int>(
                                                    value: age,
                                                    child: Text(age.toString(), style: TextStyle(
          color:  Colors.black,
        ),),
                                                  );
                                                }).toList(),
                                              )),
                                        ],
                                      );
                                    }),
                                  )),
                        ],)
                        //  Divider(),
                        /*  Text(
                'Room $fieldNumber - Adults: ${_selectedAdults[index]}, Children: ${_selectedChildren[index]}, Ages: ${_selectedAges[index].join(",")}',
              ), */
                      ],
                    );
                  },
                ),
                /*  floatingActionButton: FloatingActionButton(
        onPressed: () {
          addSelectFields();
        },
        child: Icon(Icons.add),
      ), */
                Container(
                    height: 40,
                    width: 300,
                    margin: EdgeInsets.all(5),
                    child:ElevatedButton(
                          onPressed: ()  {
                              envoyerDonnees();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: Color.fromARGB(255, 212, 32, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 254, 254, 254),
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ) )
              ],
           )  ));
  }
}

 