// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3_market_place/MyScreen/responsive.dart';
import 'package:t3_market_place/MyScreen/hotelsPage.dart';
// import 'package:web/models/ApiHotels&Sellers.dart';

//import '../models/Api_Hotel_Sellers.dart';
import '../main.dart';
import '../models/ApiHotels&Sellers.dart';
//import '../models/hotel_Response.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

//String formattedDate = DateFormat('d/M/y').format(checkInDate);
DateTime checkInDate = DateTime.now();
DateTime checkOutDate = checkInDate.add(Duration(days: 1));
List<Hotels> productsSession = [];
List<Hotels> products = [];

bool loading = true;
/* DateTime checkInDate = DateFormat('dd/MM/yyyy').parse('27/03/2023');
DateTime checkOutDate = DateFormat('dd/MM/yyyy').parse('28/03/2023'); */
/* ProductsPage productsPage = ProductsPage(
  Mesproducts: products,
  checkInDate: checkInDate,
  checkOutDate: checkInDate,
  city: TextEditingController(),
  loading: loading 
); */

class _searchState extends State<search> {
//passez data

  //late int height1 = _isModalVisible ? 600 : 300;
  // end data
  // int defaultHeight2=height1;
  // create an instance of search2 using the default height

  bool _showContainer = false;
  bool _showCircuitContainer = false;
  bool _showVisaContainer = false;
  bool _showHotelContainer = true;
  String _selectedCity = 'Sousse';
  Color _color = Color.fromARGB(255, 255, 255, 255);
  Color _color1 = Color.fromARGB(255, 255, 255, 255);
  Color _color3 = Color.fromARGB(255, 255, 255, 255);
  Color _colorBlanc = Color.fromARGB(255, 248, 247, 248);

  Color _color2 = Color.fromARGB(255, 155, 155, 155);
  bool _isCodeVisible = false;
  //code of modal
  bool _isModalVisible = false;
  bool condition = true; // Remplacez "true" par votre condition
  //code Select
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
  List<int> _options_Ages = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  List<String> _selectedOption1 = ['tunis'];
  List<String> _selectedOption2 = ['Tous les thèmes'];
  List<String> _selectedOption3 = ['toutes'];
  List<String> _selectedOption4 = ['Eté'];
  List<String> _selectedOptionPays = ['Iran'];
  List<String> _selectedOptionVisa = ['Visa'];
  List<String> _selectedOptionBudget = ['Tous les Budgets'];
  var SommePersonnes2 = 0;
  //end code
  //fetchHotels
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

  Future<void> fetchPosts() async {
    final url = Uri.parse('http://user3-market.3t.tn/ApiHotel/getApiHotels');
//   final url = Uri.https('btob.3t.tn', '/getProducts', {'product': 'hotels'});

    // Map<String, dynamic> result = {
    final body = {
      //  "checkIn": DateTime.parse(checkInDate    ),
      //"checkOut": DateTime.parse(checkOutDate ),
      "checkIn": "$checkInDate",
      "checkOut": "$checkOutDate",
      "city": _city.text,
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

    final response =
        await http.post(url, headers: null, body: jsonEncode(body));
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
      // setState(() {
      //
      // });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('nom', 'John');
      final nom = prefs.getString('nom') ?? '';
      //setData
      List<String> productsJsonList =
          products.map((product) => json.encode(product.toJson())).toList();
      prefs.setStringList('products', productsJsonList);
      //  Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => PaginationExample(),
      //         ),
      //       );
      /* Navigator.push(
       context,
      MaterialPageRoute(
           builder: (context) => PaginationExample()
           ),
     );  */
      //getData
      // List<String> productsJsonLists = prefs.getStringList('products') ?? [];
      // if (productsJsonList.isNotEmpty) {
      //   productsSession = productsJsonLists
      //       .map((productJson) => Hotels.fromJson(json.decode(productJson)))
      //       .toList();

      // }
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

  // int ageFieldIndex = 0;
  // final List<List<int>> _selectedAges = List.generate(_numField, (_) => []);

  /*  void _addSelectFields() {
    setState(() {
      _numFields++;
      _selectedOption1.add(1);
      _selectedOption2.add(1);
      // _selectedAges.add([]);
      _selectedOption3.add(1);
    });
  } */
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
  /* void _addSelectAge() {
    setState(() {
      _numFields++;
      //if (_selectedOption2 == _numFields)
      _selectedOption3.add(4);
      //  _selectedOption2.add(1);
    });
  }  */
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

  //end
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
  //end variable

  Widget buildModal(BuildContext context) {
    return Container(
      height: 500,
      //  width: 800,
      child: Column(
        children: [
        
        ],
      ),
    );
  }
  //end code Modal

  @override
  Widget build(BuildContext context) {
    void _onChanged(String? newValue) {
      setState(() {
        _selectedCity = newValue!;
      });
    }

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Container(
            // height: double.infinity,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),

            child: Column(
              children: [
                //add Hotels_circuit_visa_Button

                //end modal

                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 3,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
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
                              width: 180,
                              height: 40,
                              decoration: BoxDecoration(
                                //  color: Color.fromARGB(255, 255, 255, 255),
                                color: _color,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color.fromARGB(255, 123, 119, 119),
                                  width: 1,
                                ),
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
                                child: Text(
                                  'Hotels Tunisie',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 12, 10, 10),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
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
                              width: 180,
                              height: 40,
                              decoration: BoxDecoration(
                                //color: Color.fromARGB(255, 255, 255, 255),
                                border: Border.all(
                                  color: Color.fromARGB(255, 123, 119, 119),
                                  width: 1,
                                ),
                                color: _color1,
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
                                child: Text(
                                  'Circuits Tunisie',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 8, 4, 4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
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
                              width: 180,
                              height: 40,
                              decoration: BoxDecoration(
                                //  color: Color.fromARGB(255, 255, 255, 255),
                                color: _color3,

                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color.fromARGB(255, 123, 119, 119),
                                  width: 1,
                                ),
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
                                child: Text(
                                  'Voyages organisés',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 8, 4, 4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //end Hotels_circuit_visa_Button
                //add a destination....
                SizedBox(
                  height: 5,
                ),

                Column(
                  children: [
                    if (_showHotelContainer)
                      Container(
                        // height: double.infinity,

                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  //   height:180 ,
                                  padding: EdgeInsets.all(10),
                                  /*   margin:
                                          EdgeInsets.symmetric(horizontal: 20), */
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Destination",
                                          style: GoogleFonts.alike(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      TextField(
                                        controller: _city,
                                        decoration: InputDecoration(
                                            hintText: 'where are you going ?',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 6, 4, 4),
                                                width: 3.0,
                                              ),
                                            ),
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                            )),
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: Container(
                                //    height: 180,
                                //width: 20,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(boxShadow: [
                                  /*    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 253, 253, 253),
                                      ), */
                                ], borderRadius: BorderRadius.circular(20)),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Check In date',
                                        style: GoogleFonts.alike(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Container(
                                      //  padding: EdgeInsets.only(left: 75),
                                      padding: EdgeInsets.only(left: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Color.fromARGB(255, 7, 5, 5)
                                              .withOpacity(0.2),
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          /*  BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ), */
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Center(
                                            child: Text(
                                              ' ${DateFormat('yyyy-MM-dd').format(checkInDate)}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
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
                                                    checkOutDate = checkInDate
                                                        .add(Duration(days: 1));
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
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              //   flex: 2,
                              child: Container(
                                // height: 180,
                                // width: 20,

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Check Out date',
                                        style: GoogleFonts.alike(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Container(
                                      //     padding: EdgeInsets.only(left: 75),
                                      padding: EdgeInsets.only(left: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Color.fromARGB(255, 7, 5, 5)
                                              .withOpacity(0.2),
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [],
                                      ),
                                      child: Row(
                                        children: [
                                          Center(
                                            child: Text(
                                              ' ${DateFormat('yyyy-MM-dd').format(checkOutDate)}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDatePicker(
                                                context: context,
                                                initialDate: checkOutDate,
                                                firstDate: checkInDate
                                                    .add(Duration(days: 1)),
                                                // firstDate: DateTime(2023),
                                                lastDate: DateTime(2030),
                                                selectableDayPredicate:
                                                    (DateTime date) {
                                                  // disable dates before today and before check-in date
                                                  return date.isAfter(
                                                          DateTime.now()) &&
                                                      date.isAfter(checkInDate
                                                          .subtract(Duration(
                                                              days: 1)));
                                                },
                                              ).then((pickedDate) {
                                                if (pickedDate != null &&
                                                    pickedDate !=
                                                        checkOutDate) {
                                                  setState(() {
                                                    checkOutDate = pickedDate;
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
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              //flex: 1,
                              child: Container(
                                height: 50,
                                width: 20,
                                margin: EdgeInsets.only(top: 20),
                                padding: EdgeInsets.all(2),
                                // elevation: 3,
                                // borderRadius: BorderRadius.circular(82.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    // Add your function here

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.all(0),
                                          content: Container(
                                            width: 900,
                                            height: 300,
                                            child: Column(children: [
                                              Container(
                                                // margin: EdgeInsets.only(left: 580),
                                                // width: 770,
                                                //  height: double.maxFinite,

                                                height: 300,
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                //   appBar: AppBar(title: Text('Select Field Duplicator')),
                                                child: ListView.builder(
                                                  itemCount: _numFields,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    //
                                                    //ajouter un boucle
                                                    /*   for (int i = 0; i < _selectedOption2.length; i++)
                               v ar ageFieldIndex = _selectedOption2[i];  */
                                                    //end boucle

                                                    var NbChambres = index + 1;
                                                    NbChambres2 = NbChambres;
                                                    /* for (int i = 0; i < NbChambres; i++) {
                      Map<String, dynamic> occupancyData = {
                        "adult": "$_selected1[index]",
                        "child": {
                          "value": "", //childrenController.text,
                          "age": "",
                        }
                      };

                      occupanciesList.add(occupancyData);
                      /*  setState(() {
                        occupanciesList.add(occupancyData);
                        print(occupanciesList);
                      }); */
                    } */

                                                    /*  for (int i = 1; i <= NbChambres2; i++) {
                      Map<String, dynamic> occupancy = {
                        "adult": '$_selected1',
                        "child": {
                          "value": "$_selected2",
                          "age": _childrenAges.join(','),
                        },
                      };
                      occupancies["$i"] = occupancy;
                    } */
                                                    return Row(
                                                      children: [
                                                        //  for (int i = 0; i <= index - 2; i++)

                                                        Column(
                                                          children: [
                                                            Text(
                                                              ' CHambre N° $NbChambres   ',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        12,
                                                                        10,
                                                                        10),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(),
                                                        if (index == 0)
                                                          Row(children: [
                                                            Container(
                                                              width: 150,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  IconButton(
                                                                    onPressed:
                                                                        _addSelectFields,
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add),
                                                                  ),
                                                                  IconButton(
                                                                    onPressed: () =>
                                                                        _removeSelectFields(
                                                                            index),
                                                                    icon: Icon(Icons
                                                                        .remove),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                        /*  SizedBox(
                              height: 200,
                                ), */
                                                        //   Visibility(
                                                        //  visible: _isCodeVisible,

                                                        Container(
                                                          width: 100,
                                                          margin: index != 0
                                                              ? EdgeInsets.only(
                                                                  left: 150)
                                                              : EdgeInsets.only(
                                                                  left: 0),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.0),
                                                            child:
                                                                DropdownButtonFormField<
                                                                    int>(
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Adult',
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                              value: _selected1[
                                                                  index],
                                                              onChanged:
                                                                  (newValue) {
                                                                setState(() {
                                                                  //  if (_isModalVisible = true)
                                                                  //_selected1[index] = newValue!;
                                                                  // for (int i = 0; i < index; i++) {
                                                                  _selected1[
                                                                          index] =
                                                                      newValue!;
                                                                  // if (_selected1[index] == newValue) {
                                                                  //  NbPersonnes += _selected1[index];
                                                                  if (index ==
                                                                      0) {
                                                                    adult1 =
                                                                        _selected1[
                                                                            index];
                                                                    NbPersonnes =
                                                                        _selected1[
                                                                            index];
                                                                    //  print('index$index ,$NbPersonnes');
                                                                  } else if (index ==
                                                                      1) {
                                                                    adult2 =
                                                                        _selected1[
                                                                            index];
                                                                    if (index !=
                                                                        0) {
                                                                      NbPersonnes1 =
                                                                          _selected1[
                                                                              index];
                                                                    } else if (_numFields ==
                                                                        1) {
                                                                      NbPersonnes1 ==
                                                                          0;
                                                                    }
                                                                    //  print('index$index ,$NbPersonnes1');
                                                                  } else if (index ==
                                                                      2) {
                                                                    adult3 =
                                                                        _selected1[
                                                                            index];
                                                                    if (index !=
                                                                        0) {
                                                                      NbPersonnes2 =
                                                                          _selected1[
                                                                              index];
                                                                    } else if (_numFields ==
                                                                            1 &&
                                                                        _numField ==
                                                                            2) {
                                                                      NbPersonnes2 ==
                                                                          0;
                                                                    }
                                                                    //  print('index$index ,$NbPersonnes2');
                                                                  }
                                                                  // SommePersonnes += _selected1[index];

                                                                  //print('SommePersonnes=$SommePersonnes');
                                                                  //}
                                                                  //}
                                                                });
                                                              },
                                                              items: _optionsChambre
                                                                  .map((int
                                                                      option) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: option,
                                                                  child: Text(option
                                                                      .toString()),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        ),

                                                        Container(
                                                          width: 90,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child:
                                                                DropdownButtonFormField<
                                                                    int>(
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Enfant',
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                              value: _selected2[
                                                                  index],
                                                              onChanged:
                                                                  (newValue) {
                                                                setState(() {
                                                                  _selected2[
                                                                          index] =
                                                                      newValue!;
                                                                  print(index);
                                                                  if (index ==
                                                                      0) {
                                                                    enfant1 =
                                                                        _selected2[
                                                                            index];
                                                                  } else if (index ==
                                                                      1) {
                                                                    enfant2 =
                                                                        _selected2[
                                                                            index];
                                                                  } else if (index ==
                                                                      2) {
                                                                    enfant3 =
                                                                        _selected2[
                                                                            index];
                                                                  }
                                                                });
                                                              },
                                                              items: _optionsChambre
                                                                  .map((int
                                                                      option) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: option,
                                                                  child: Text(option
                                                                      .toString()),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        ),
                                                        //add champdage
                                                        //   if (_options.length >= 1)
                                                        /**************************************************************************testing************************************************************** */
                                                        /*        //  for (int index = 0; index < index; index++)
                        for (int ageIndex = 0;
                            ageIndex < _selected2[index];
                            ageIndex++) */
                                                        //  if (_selected2[index] == 0)
                                                        //  for (int j = 0; j <  _selectedOption2[index]; j++)
                                                        /*  for (int ageIndex = 0;
                            ageIndex < _selectedOption2.length;
                            ageIndex++) */
                                                        //for (int i = 0; i < ageIndex; i++)
                                                        for (int ageIndex = 0;
                                                            ageIndex <
                                                                _selected2[
                                                                    index];
                                                            ageIndex++)
                                                          Container(
                                                            width: 90,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  DropdownButtonFormField<
                                                                      int>(
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Age ${ageIndex + 1}',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                ),
                                                                value:
                                                                    _selected3[
                                                                        index],
                                                                onChanged:
                                                                    (newValue) {
                                                                  setState(() {
                                                                    _selected3[
                                                                            index] =
                                                                        newValue!;
                                                                    var ageNumber =
                                                                        ageIndex +
                                                                            1;
                                                                    print(
                                                                        'ageNumber$ageIndex+1');
                                                                    // AgeIndexOne =   _selectedAges[index][ageIndex];

                                                                    //    ageFieldIndex = index * 100 + ageIndex;
                                                                    //  print(index + newValue);$
                                                                    // index + 1;
                                                                    //_selectedOption3[index]++;
                                                                    // print("AgeIndexOne $AgeIndexOne");
                                                                    // print("ageIndex $ageIndex");
                                                                    //print("index $index+$ageIndex");
                                                                  });
                                                                },
                                                                items: _options_Ages1
                                                                    .map((int
                                                                        _options_Ages) {
                                                                  return DropdownMenuItem<
                                                                      int>(
                                                                    value:
                                                                        _options_Ages,
                                                                    child: Text(
                                                                        _options_Ages
                                                                            .toString()),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            ),
                                                          ),

                                                        //add 2
                                                        /*   if (_selected2[index] == 1)
                          //  for (int j = 0; j <  _selectedOption2[index]; j++)
                          /*  for (int ageIndex = 0; ageIndex < _selectedOption2.length; ageIndex++) */
                          Container(
                            width: 90,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Age ${index}',
                                  border: OutlineInputBorder(),
                                ),
                                value: AgeIndexOne,
                                onChanged: (newValue) {
                                  setState(() {
                                    // _selected3[index] = newValue!;
                                    AgeIndexOne = newValue!;

                                    //    ageFieldIndex = index * 100 + ageIndex;
                                    //  print(index + newValue);$
                                    // index + 1;
                                    //_selectedOption3[index]++;
                                    print("AgeIndexOne $AgeIndexOne");
                                    // print("ageIndex $ageIndex");
                                    //print("index $index+$ageIndex");
                                  });
                                },
                                items: _options_Ages1.map((int _options_Ages) {
                                  return DropdownMenuItem<int>(
                                    value: _options_Ages,
                                    child: Text(_options_Ages.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                        Container(
                          width: 90,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Age ${index}',
                                border: OutlineInputBorder(),
                              ),
                              // value: _selected3[index],
                              value: AgeIndexTwo,
                              onChanged: (newValue) {
                                setState(() {
                                  // _selected3[index] = newValue!;
                                  AgeIndexTwo = newValue;
                                  //    ageFieldIndex = index * 100 + ageIndex;
                                  //  print(index + newValue);$
                                  // index + 1;
                                  //_selectedOption3[index]++;
                                  print("AgeIndexTwo $AgeIndexTwo");
                                  // print("ageIndex $ageIndex");
                                  //print("index $index+$ageIndex");
                                });
                              },
                              items: _options_Ages1.map((int _options_Ages) {
                                return DropdownMenuItem<int>(
                                  value: _options_Ages,
                                  child: Text(_options_Ages.toString()),
                                );
                              }).toList(),
                            ),
                          ),
                        ), */
                                                        /**************************************************************************************************************************************** */
                                                        //end age
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              /*  Column(children: [
                    Container(
                      margin: EdgeInsets.only(left: 500),
                   child: ElevatedButton(onPressed: () {
                // Ferme le dialogue lorsque le bouton est pressé
                Navigator.pop(context);
              },
              child: Text('Confirmer'),)),
                    
                  ],) */
                                            ]),
                                          ),
                                        );
                                      },
                                    );

                                    //   _isCodeVisible = true;
                                    //   _showModal();
                                    print('Container clicked!');
                                    //_showModal2();
                                    //  });
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        border: Border.all(
                                          color: Color.fromARGB(255, 7, 5, 5)
                                              .withOpacity(0.2),
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: []),
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              //"Chambres $NbChambres2 et $SommePersonnes2 Personne(s)",
                                              'Occupancies',
                                              style: GoogleFonts.alike(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium,
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ),

                                          //add modal
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: TextButton(
                                      onPressed: () async {
                                      await fetchPosts();
                                    
                                      //  if ( fetchPosts().toString()!= null) {
                         
  //}
                                      },
                                      /*  onPressed: () {
                        sendData();
                      },  */
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromARGB(
                                                    255, 115, 110, 110)),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(82),
                                            side: BorderSide(
                                              color: Color.fromARGB(
                                                      255, 76, 71, 71)
                                                  .withOpacity(0.2),
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        width: 150,
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            'Rechercher',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 248, 248, 248),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )))
                            // if (_isModalVisible) buildModal(context),
                          ],
                        ),
                      ),
                    //add a tablette and mobile responsive oh hotels

                    // height: double.infinity,

                    if (_showCircuitContainer)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromARGB(255, 123, 119, 119),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(children: [
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Material(
                                //  elevation: 3,
                                // borderRadius: BorderRadius.circular(82.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 123, 119, 119),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 100,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: DropdownButtonFormField<String>(
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
                                          child: Text(option.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(82.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 123, 119, 119),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 100,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
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
                                          child: Text(option.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 123, 119, 119),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 100,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
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
                                          child: Text(option.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 123, 119, 119),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 100,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
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
                                          child: Text(option.toString()),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ]),
                        ),
                      ),
                    if (_showVisaContainer)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromARGB(255, 123, 119, 119),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 1,
                                child: Material(
                                  //  elevation: 3,
                                  // borderRadius: BorderRadius.circular(82.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 123, 119, 119),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 100,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
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
                                            child: Text(option.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(82.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 123, 119, 119),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 100,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
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
                                            child: Text(option.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 1,
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 123, 119, 119),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 100,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
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
                                            child: Text(option.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 1,
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 123, 119, 119),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 100,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
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
                                            child: Text(option.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 1,
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 123, 119, 119),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 100,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Budget',
                                          border: OutlineInputBorder(),
                                        ),
                                        value: _selectedOptionBudget[0],
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedOptionBudget[0] =
                                                newValue!;
                                          });
                                        },
                                        items: Budget.map((String option) {
                                          return DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(option.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                      child: TextButton(
                                    onPressed: () {},
                                    /*  onPressed: () {
                        sendData();
                      },  */
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(
                                                  255, 115, 110, 110)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(82),
                                          side: BorderSide(
                                            color:
                                                Color.fromARGB(255, 76, 71, 71)
                                                    .withOpacity(0.2),
                                            width: 3.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      width: 180,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          'Rechercher',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 248, 248, 248),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )))
                            ],
                          ),
                        ),
                      ),

                    //end hotels responsive
                  ],
                ),
              ],
            ),
          ),

          //end destination
          //add a form to children

          //end form children
          //   ),
        ],
      ),
    ));
  }
}
