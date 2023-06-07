import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t3_market_place/MyScreen/responsive.dart';

// import 'package:web/models/ApiHotels&Sellers.dart';

//import '../models/Api_Hotel_Sellers.dart';
import '../models/ApiHotels&Sellers.dart';
//import '../models/hotel_Response.dart';

class MoteurWeb extends StatefulWidget {
  MoteurWeb({
    super.key,
    required this.showContainer,
    required this.counter,
  });

  int counter;
  bool showContainer;
  @override
  State<MoteurWeb> createState() => _MoteurWebState();
}

//String formattedDate = DateFormat('d/M/y').format(checkInDate);
DateTime checkInDate = DateTime.now();
DateTime checkOutDate = checkInDate.add(Duration(days: 1));
String chekout = "25/06/1998";
List<Hotels> productsSession = [];
List<Hotels> products = [];
String _selectedCity = "sousse";
bool loading = true;
bool RechercheLoading = false;
/* DateTime checkInDate = DateFormat('dd/MM/yyyy').parse('27/03/2023');
DateTime checkOutDate = DateFormat('dd/MM/yyyy').parse('28/03/2023'); */
/* ProductsPage productsPage = ProductsPage(
  Mesproducts: products,
  checkInDate: checkInDate,
  checkOutDate: checkInDate,
  city: TextEditingController(),
  loading: loading 
); */

class _MoteurWebState extends State<MoteurWeb> {
  int nbEnfants = 0;
  int nbAdultes = 0;
  int Nbchambre = 0;
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
      Nbchambre = Nbchambres;

      // receivedBody = body;
      receivedBody!.addEntries(body.entries);
      //receivedBody!.addAll(body);
      combinedBody = {...?receivedBody, ...body};
    });
  }

  //des methode modal
  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _showModalContent();
      },
    );
  }

  Widget _showModalContent() {
    // TODO: Personnalisez le contenu du modal en utilisant les champs des chambres

    /*return AlertDialog(
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
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            //   appBar: AppBar(title: Text('Select Field Duplicator')),
            child: ListView.builder(
              itemCount: _numFields,
              itemBuilder: (BuildContext context, int index) {
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
                            color: Color.fromARGB(255, 12, 10, 10),
                            fontWeight: FontWeight.bold,
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: _addSelectFields,
                                icon: Icon(Icons.add),
                              ),
                              IconButton(
                                onPressed: () => _removeSelectFields(index),
                                icon: Icon(Icons.remove),
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
                          ? EdgeInsets.only(left: 150)
                          : EdgeInsets.only(left: 0),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: 'Adult',
                            border: OutlineInputBorder(),
                          ),
                          value: _selected1[index],
                          onChanged: (newValue) {
                            setState(() {
                              //  if (_isModalVisible = true)
                              //_selected1[index] = newValue!;
                              // for (int i = 0; i < index; i++) {
                              _selected1[index] = newValue!;
                              // if (_selected1[index] == newValue) {
                              //  NbPersonnes += _selected1[index];
                              if (index == 0) {
                                adult1 = _selected1[index];
                                NbPersonnes = _selected1[index];
                                //  print('index$index ,$NbPersonnes');
                              } else if (index == 1) {
                                adult2 = _selected1[index];
                                if (index != 0) {
                                  NbPersonnes1 = _selected1[index];
                                } else if (_numFields == 1) {
                                  NbPersonnes1 == 0;
                                }
                                //  print('index$index ,$NbPersonnes1');
                              } else if (index == 2) {
                                adult3 = _selected1[index];
                                if (index != 0) {
                                  NbPersonnes2 = _selected1[index];
                                } else if (_numFields == 1 && _numField == 2) {
                                  NbPersonnes2 == 0;
                                }
                                //  print('index$index ,$NbPersonnes2');
                              }
                              // SommePersonnes += _selected1[index];

                              //print('SommePersonnes=$SommePersonnes');
                              //}
                              //}
                            });
                          },
                          items: _optionsChambre.map((int option) {
                            return DropdownMenuItem<int>(
                              value: option,
                              child: Text(option.toString()),
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
                            labelText: 'Enfant',
                            border: OutlineInputBorder(),
                          ),
                          value: _selected2[index],
                          onChanged: (newValue) {
                            setState(() {
                              _selected2[index] = newValue!;
                              print(index);
                              if (index == 0) {
                                enfant1 = _selected2[index];
                              } else if (index == 1) {
                                enfant2 = _selected2[index];
                              } else if (index == 2) {
                                enfant3 = _selected2[index];
                              }
                            });
                          },
                          items: _optionsChambre.map((int option) {
                            return DropdownMenuItem<int>(
                              value: option,
                              child: Text(option.toString()),
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
                        ageIndex < _selected2[index];
                        ageIndex++)
                      Container(
                        width: 90,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              labelText: 'Age ${ageIndex + 1}',
                              border: OutlineInputBorder(),
                            ),
                            value: _selected3[index],
                            onChanged: (newValue) {
                              setState(() {
                                _selected3[index] = newValue!;
                                var ageNumber = ageIndex + 1;
                                //        print('ageNumber$ageIndex+1');
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
                            items: _options_Ages1.map((int _options_Ages) {
                              return DropdownMenuItem<int>(
                                value: _options_Ages,
                                child: Text(_options_Ages.toString()),
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
  */
    return Dialog(
        child: Container(
      width: 900,
      height: 300,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          // margin: EdgeInsets.only(left: 580),
          // width: 770,
          //  height: double.maxFinite,

          height: 300,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          //   appBar: AppBar(title: Text('Select Field Duplicator')),
          child: ListView.builder(
            itemCount: _numFields,
            itemBuilder: (BuildContext context, int index) {
              //
              //ajouter un boucle
              /*   for (int i = 0; i < _selectedOption2.length; i++)
                               v ar ageFieldIndex = _selectedOption2[i];  */
              //end boucle

              var NbChambres = index + 1;
              NbChambres2 = NbChambres;
              // counter = NbChambres;
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
                          color: Color.fromARGB(255, 12, 10, 10),
                          fontWeight: FontWeight.bold,
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: _addSelectFields,
                              icon: Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () => _removeSelectFields(index),
                              icon: Icon(Icons.remove),
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
                        ? EdgeInsets.only(left: 150)
                        : EdgeInsets.only(left: 0),
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Adult',
                          border: OutlineInputBorder(),
                        ),
                        value: _selected1[index],
                        onChanged: (newValue) {
                          setState(() {
                            //  if (_isModalVisible = true)
                            //_selected1[index] = newValue!;
                            // for (int i = 0; i < index; i++) {
                            _selected1[index] = newValue!;
                            // if (_selected1[index] == newValue) {
                            //  NbPersonnes += _selected1[index];
                            if (index == 0) {
                              adult1 = _selected1[index];
                              NbPersonnes = _selected1[index];
                              //  print('index$index ,$NbPersonnes');
                            } else if (index == 1) {
                              adult2 = _selected1[index];
                              if (index != 0) {
                                NbPersonnes1 = _selected1[index];
                              } else if (_numFields == 1) {
                                NbPersonnes1 == 0;
                              }
                              //  print('index$index ,$NbPersonnes1');
                            } else if (index == 2) {
                              adult3 = _selected1[index];
                              if (index != 0) {
                                NbPersonnes2 = _selected1[index];
                              } else if (_numFields == 1 && _numField == 2) {
                                NbPersonnes2 == 0;
                              }
                              //  print('index$index ,$NbPersonnes2');
                            }
                            // SommePersonnes += _selected1[index];

                            //print('SommePersonnes=$SommePersonnes');
                            //}
                            //}
                          });
                        },
                        items: _optionsChambre.map((int option) {
                          return DropdownMenuItem<int>(
                            value: option,
                            child: Text(option.toString()),
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
                          labelText: 'Enfant',
                          border: OutlineInputBorder(),
                        ),
                        value: _selected2[index],
                        onChanged: (newValue) {
                          setState(() {
                            _selected2[index] = newValue!;
                            print(index);
                            if (index == 0) {
                              enfant1 = _selected2[index];
                            } else if (index == 1) {
                              enfant2 = _selected2[index];
                            } else if (index == 2) {
                              enfant3 = _selected2[index];
                            }
                          });
                        },
                        items: _optionsChambre.map((int option) {
                          return DropdownMenuItem<int>(
                            value: option,
                            child: Text(option.toString()),
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
                      ageIndex < _selected2[index];
                      ageIndex++)
                    Container(
                      width: 90,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            labelText: 'Age ${ageIndex + 1}',
                            border: OutlineInputBorder(),
                          ),
                          value: _selected3[index],
                          onChanged: (newValue) {
                            setState(() {
                              _selected3[index] = newValue!;
                              var ageNumber = ageIndex + 1;
                              //        print('ageNumber$ageIndex+1');
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
                          items: _options_Ages1.map((int _options_Ages) {
                            return DropdownMenuItem<int>(
                              value: _options_Ages,
                              child: Text(_options_Ages.toString()),
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
    ));
  }

  int name = 0;
  //modal
  Widget build2(BuildContext context) {
    return Stack(
      children: [
        // Fond noir semi-transparent
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        // Widget centré
        Center(
          child: _showModalContent(),
        ),
      ],
    );
  }
  //String email = '';
//passez data

  //late int height1 = _isModalVisible ? 600 : 300;
  // end data
  // int defaultHeight2=height1;
  // create an instance of search2 using the default height

  bool _showContainer = false;
  bool _showCircuitContainer = false;
  bool _showVisaContainer = false;
  bool _showHotelContainer = true;

  Color _color = Color.fromARGB(255, 255, 255, 255);
  Color _color1 = Color.fromARGB(255, 255, 255, 255);
  Color _color3 = Color.fromARGB(255, 255, 255, 255);
  Color _colorBlanc = Color.fromARGB(255, 255, 255, 255);

  Color _color2 = Color.fromARGB(255, 212, 32, 32);
  bool _isCodeVisible = false;
  bool _isChampsChambresVisible = false;

  //code of modal
  bool _isModalVisible = false;
  bool condition = true; // Remplacez "true" par votre condition
  //code Select
  List<String> _options = ['tunis', 'sfax', 'touzer'];
  List<String> _options2 = [
    'All themes',
    'Culture',
    'Découverte',
    'Saharien',
    'Aventure',
    'History',
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
    'All',
    '1 jour',
    'Entre 2 et 4 jours',
    'Entre 5 et 9 jours',
    '10 jours et plus'
  ];
  List<String> _options4 = [
    'Toutes les saisons',
    'Printemps',
    'Summer',
    'Automne',
    'Hiver'
  ];
  List<String> _options5 = [
    'Sousse',
    ',Sousse,Hammamet',
    'Tunis',
    'Touzer',
    'Monastir',
    // 'Klibya'
  ];
  List<int> _options_Ages = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  List<String> _selectedOption1 = ['tunis'];
  List<String> _selectedOption2 = ['All themes'];
  List<String> _selectedOption3 = ['All'];
  List<String> _selectedOption4 = ['Summer'];
  List<String> _selectedOption5 = ['Sousse'];
  List<String> _optionsDestianton1 = ['Sousse'];
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

  /*  void _showModal2() {
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
  } */
  bool isActivate = false;

  @override
  void initState() {
    super.initState();
    isActivate = true;
  }

  List<Map<String, dynamic>> occupanciesList = [];
  // List<Map<String, dynamic>> occupancies = [];
  Map<String, dynamic> occupancies = {};

  //end fetchHotels
  //tester avec une autre methode

  Future<void> fetchPosts() async {
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
          prefs.getString('checkout') != null &&
          prefs.getString('destination') != null) {
        prefs.remove('checkin');
        prefs.remove('checkout');
      }
      prefs.setString('checkin', '$checkInDate');
      prefs.setString('checkout', '$checkOutDate');
      prefs.setString('destination', _selectedCity);
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

  // void _showModal() {
  //   setState(() {
  //     _isModalVisible = true;
  //     SommePersonnes = 0;
  //     print('SommePersonnes2  quand j\'ouvre, $SommePersonnes2');
  //     print('SommePersonnes  quand j\'ouvre, $SommePersonnes');
  //   });
  // }

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

  /*  Widget buildModal(BuildContext context) {
    return Container(
      height: 500,
      //  width: 800,
      child: Column(
        children: [
          SelectFieldDuplicator(),
        ],
      ),
    );
  } */
  //end code Modal

  @override
  Widget build(BuildContext context) {
    /* final myModal = MyModal(
      callback: (int nbEnfants, int nbAdultes) {
        // Vous pouvez utiliser les données ici
        print('Nombre d\'enfants : $nbEnfants');
        print('Nombre d\'adultes : $nbAdultes');

        // Effectuez votre logique de recherche avec les données
      },
      counter: name,
      addSelectFields: () {
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
      },
      removeSelectFields: (int value) {},
    ); */

    void _onChanged(String? newValue) {
      setState(() {
        _selectedCity = newValue!;
      });
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 2), // changes position of shadow
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
                            color: Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 3,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          if (!RechercheLoading)
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _showCircuitContainer = false;
                                      _showVisaContainer = false;
                                      _showHotelContainer = true;
   isActivate = true;
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
                                  child: Material(
                                      borderRadius: BorderRadius.circular(40),
                                      elevation: 3,
                                      child: Container(
                                        width: 180,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          //  color: Color.fromARGB(255, 255, 255, 255),
                                          color: isActivate ? _color2 : _color,
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          border: Border.all(
                                            color: isActivate
                                                ? Colors.transparent
                                                : Color.fromARGB(255, 8, 4, 4),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            /*  BoxShadow(
                                  color: Color.fromARGB(255, 60, 60, 60)
                                      .withOpacity(0.2),
                                  spreadRadius: 4,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),   */
                                          ],
                                        ),
                                        child: Center(
                                            child: Row(
                                          children: [
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Icon(
                                              Icons.hotel,
                                              color: isActivate
                                                  ? Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : Color.fromARGB(
                                                      255, 8, 4, 4),
                                              size: 30,
                                            ),
                                            Text(
                                              'Hotels ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: isActivate
                                                    ? Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    : Color.fromARGB(
                                                        255, 8, 4, 4),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )),
                                      )),
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
                                         isActivate = false;
                                      /*  if (_showCircuitContainer = true) {
                        _color1 = _color2;
                      } else {
                        _color1 = _color;
                      } */
                                    });
                                  },
                                  child: Material(
                                      borderRadius: BorderRadius.circular(40),
                                      elevation: 3,
                                      child: Container(
                                        width: 180,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          //color: Color.fromARGB(255, 255, 255, 255),
                                          border: Border.all(
                                            color: _showCircuitContainer
                                                ? Colors.transparent
                                                : Color.fromARGB(255, 8, 4, 4),
                                            width: 1,
                                          ),
                                          color: _color1,
                                          borderRadius:
                                              BorderRadius.circular(40),
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
                                            child: Row(
                                          children: [
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Icon(
                                              Icons.alt_route,
                                              color: _showCircuitContainer
                                                  ? Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : Color.fromARGB(
                                                      255, 8, 4, 4),
                                              size: 30,
                                            ),
                                            Text(
                                              'Tours ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: _showCircuitContainer
                                                    ? Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    : Color.fromARGB(
                                                        255, 8, 4, 4),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )),
                                      )),
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
                                      isActivate = false;
                                      /*  if (_showVisaContainer = true) {
                        _color3 = _color2;
                      } else if (_showCircuitContainer == true ||
                          _showVisaContainer == true) {
                        _color3 = _color3;
                      } */
                                    });
                                  },
                                  child: Material(
                                      borderRadius: BorderRadius.circular(40),
                                      elevation: 3,
                                      child: Container(
                                        width: 180,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          //  color: Color.fromARGB(255, 255, 255, 255),
                                          color: _color3,

                                          borderRadius:
                                              BorderRadius.circular(40),
                                          border: Border.all(
                                            color: _showVisaContainer
                                                ? Colors.transparent
                                                : Color.fromARGB(255, 8, 4, 4),
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
                                            child: Row(
                                          children: [
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Icon(
                                              Icons.flight,
                                              color: _showVisaContainer
                                                  ? Color.fromARGB(
                                                      255, 255, 255, 255)
                                                  : Color.fromARGB(
                                                      255, 8, 4, 4),
                                              size: 30,
                                            ),
                                            Text(
                                              'Traveling ',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: _showVisaContainer
                                                    ? Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    : Color.fromARGB(
                                                        255, 8, 4, 4),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )),
                                      )),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    //end Hotels_circuit_visa_Button
                    //add a destination....
                    SizedBox(
                      height: 5.h,
                    ),

                    Column(
                      /// mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        if (_showHotelContainer && !RechercheLoading)
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              // height: double.infinity,

                              child: Row(
                                children: [
                                  Expanded(
                                    //    flex: MediaQuery.of(context).size.width>900 && MediaQuery.of(context).size.width<950 ? 2:1,
                                    child: Container(
                                      //     margin: EdgeInsets.symmetric(horizontal: 10),
                                      //      width:

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
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              //   labelText: 'Destination',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                                borderSide: BorderSide(
                                                  color: Colors
                                                      .black, // Modifier cette valeur pour la couleur noire
                                                  width:
                                                      2.0, // Épaisseur de la bordure selon vos besoins
                                                ),
                                              ),
                                              //  border: InputBorder.none,
                                              focusColor:
                                                  Color.fromARGB(255, 1, 1, 1),
                                            ),
                                            value: _selectedOption5[0],
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedOption5[0] = newValue!;
                                                _selectedCity = newValue;
                                                if (receivedBody != null) {
                                                  receivedBody!["city"] =
                                                      newValue;
                                                }
                                                print(
                                                    '_selectedCity$_selectedCity');
                                              });
                                            },
                                            items:
                                                _options5.map((String option) {
                                              return DropdownMenuItem<String>(
                                                value: option,
                                                child: Text(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  option.toString(),
                                                  selectionColor: Colors.black,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // SizedBox(
                                  //   width: 1.h,
                                  // ),
                                  Expanded(
                                    child: Container(
                                      //    height: 180,
                                      //width: 20,
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            /*    BoxShadow(
                                        color:
                                            Color.fromARGB(255, 253, 253, 253),
                                      ), */
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Check In date',
                                              style: GoogleFonts.alike(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium,
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Container(
                                            //  padding: EdgeInsets.only(left: 75),
                                            padding: EdgeInsets.only(left: 0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 173, 173, 173),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
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
                                                          pickedDate !=
                                                              checkInDate) {
                                                        setState(() {
                                                          checkInDate =
                                                              pickedDate;
                                                          receivedBody![
                                                                  "checkIn"] =
                                                              pickedDate
                                                                  .toString();

                                                          checkOutDate =
                                                              checkInDate.add(
                                                                  Duration(
                                                                      days: 1));

                                                          receivedBody![
                                                                  "checkOut"] =
                                                              checkOutDate
                                                                  .toString();
                                                        });
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .calendar_month_outlined,
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
                                  // SizedBox(
                                  //   width: 1,
                                  // ),
                                  Expanded(
                                    //   flex: 2,
                                    child: Container(
                                      // height: 180,
                                      // width: 20,

                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      padding: EdgeInsets.all(7),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Check Out date',
                                              style: GoogleFonts.alike(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium,
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Container(
                                            //     padding: EdgeInsets.only(left: 75),
                                            padding: EdgeInsets.only(left: 0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 173, 173, 173),
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [],
                                            ),
                                            child: Row(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    ' ${DateFormat('yyyy-MM-dd').format(checkOutDate)}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    // checkInDate ==
                                                    //     receivedBody!["checkIn"];
                                                    showDatePicker(
                                                      context: context,
                                                      initialDate: checkOutDate,
                                                      firstDate: checkInDate
                                                          .add(Duration(
                                                              days: 1)),
                                                      // firstDate: DateTime(2023),
                                                      lastDate: DateTime(2030),
                                                      selectableDayPredicate:
                                                          (DateTime date) {
                                                        // disable dates before today and before check-in date
                                                        return date.isAfter(
                                                                DateTime
                                                                    .now()) &&
                                                            date.isAfter(checkInDate
                                                                .subtract(
                                                                    Duration(
                                                                        days:
                                                                            1)));
                                                      },
                                                    ).then((pickedDate) {
                                                      if (pickedDate != null &&
                                                          pickedDate !=
                                                              checkOutDate) {
                                                        setState(() {
                                                          checkOutDate =
                                                              pickedDate;
                                                          receivedBody![
                                                                  "checkOut"] =
                                                              pickedDate
                                                                  .toString();
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
                                                    Icons
                                                        .calendar_month_outlined,
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

                                  Expanded(
                                    //flex: 1,
                                    child: Container(
                                      height: 50,

                                      // width: 20,
                                      margin: EdgeInsets.only(top: 25),
                                      padding: EdgeInsets.all(2),
                                      // elevation: 3,
                                      // borderRadius: BorderRadius.circular(82.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          //    callback(name, email);
                                          //   });
                                          setState(() {
                                            //  _isChampsChambresVisible = true;
                                            //_showModalContent();
                                            //  _showModal(context);

                                            // Add your function here

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return MyModal(
                                                    counter: selectedAdults,
                                                    addSelectFields:
                                                        _addSelectFields,
                                                    removeSelectFields:
                                                        _removeSelectFields,
                                                    callbackFunction:
                                                        afficherDonnees,
                                                  );
                                                });

                                            /*  showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MyModal(
                                              counter: selectedAdults,
                                              addSelectFields: _addSelectFields,
                                              removeSelectFields:
                                                  _removeSelectFields,
                                              callbackFunction: afficherDonnees,
                                            );
                                          },
                                        ); */
                                            // print('counter${myModal.counter}');
                                            //   _isCodeVisible = true;
                                            //   _showModal();

                                            //   print('Container clicked!');
                                            //_showModal2();
                                          });
                                        },
                                        child: Container(
                                          height: 90,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 173, 173, 173),
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [],
                                          ),
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
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
                                                      //  '$Nbchambres:Room,$nbAdultes:adult,$nbEnfants:enfant',
                                                      'Rooms,Adults,Children',
                                                      //$Nbchambre,
                                                      style: GoogleFonts.alike(
                                                          textStyle: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium,
                                                          fontSize: 16.sp,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                )),

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
                                        // child:Material(elevation: 5,

                                        child: TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              RechercheLoading =
                                                  true; // Activer l'état de chargement
                                            });
                                            await fetchPosts();
                                            // Navigator.pushNamed(context, '/PaginationExample');
                                            Navigator.pushNamed(
                                                context, '/Hotels');
                                            setState(() {
                                              RechercheLoading =
                                                  false; // Activer l'état de chargement
                                            });
                                          },
                                          /*  onPressed: () {
                        sendData();
                      },  */
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(Color.fromARGB(
                                                        255, 212, 32, 32)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(82),
                                                side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 212, 32, 32),
                                                  width: 3.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        900 &&
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width <
                                                        1000
                                                ? 100
                                                : 150,
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                'Search',
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Color.fromARGB(
                                                      255, 248, 248, 248),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  // if (_isModalVisible) buildModal(context),
                                ],
                              ),
                            ),
                          ),
                        //add chambresChamps
                        if (_showHotelContainer && RechercheLoading)
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10),
                                Text('Please wait...'),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 5.h,
                        ),

                        // champs chambres

                        if (_showCircuitContainer)
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              child: Row(children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    // width: 100,

                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'City',
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
                                          child: Text(
                                            style:
                                                TextStyle(color: Colors.black),
                                            option.toString(),
                                            selectionColor: Colors.black,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width > 907
                                      ? 1.w
                                      : 0,
                                ),
                                Expanded(
                                  /*  child: Material(
                                elevation: 5, */
                                  // borderRadius: BorderRadius.circular(82.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Theme',
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
                                          child: Text(
                                            style:
                                                TextStyle(color: Colors.black),
                                            option.toString(),
                                            selectionColor: Colors.black,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width > 907
                                      ? 1.w
                                      : 0,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      /* border: Border.all(
                                      color: Color.fromARGB(255, 123, 119, 119),
                                      width: 2,
                                    ), */
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //   width: 100,

                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Duration',
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
                                          child: Text(
                                            style:
                                                TextStyle(color: Colors.black),
                                            option.toString(),
                                            selectionColor: Colors.black,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width > 907
                                      ? 1.w
                                      : 0,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Season',
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
                                          child: Text(
                                            style:
                                                TextStyle(color: Colors.black),
                                            option.toString(),
                                            selectionColor: Colors.black,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                /* SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width > 907
                                            ? 1.w
                                            : 0,
                                  ), */
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      child: TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 212, 32, 32),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(82),
                                              side: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 212, 32, 32),
                                                width: 3.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      900 &&
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1000
                                              ? 100
                                              : 150,
                                          height: 40,
                                          child: Center(
                                            child: Text(
                                              'Search',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Color.fromARGB(
                                                    255, 248, 248, 248),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                              ]),
                            ),
                          ),
                        if (_showVisaContainer)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Country',
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
                                            child: Text(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width > 907
                                            ? 1.w
                                            : 0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Theme',
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
                                            child: Text(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width > 907
                                            ? 1.w
                                            : 0,
                                  ),
                                  Expanded(
                                    child: Container(
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
                                            child: Text(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width > 907
                                            ? 1.w
                                            : 0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          labelText: 'Season',
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
                                            child: Text(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              option.toString(),
                                              selectionColor: Colors.black,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width > 907
                                            ? 1.w
                                            : 0,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.all(1),
                                      child: Container(
                                        child: TextButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              Color.fromARGB(255, 212, 32, 32),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(82),
                                                side: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 212, 32, 32),
                                                  width: 3.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        900 &&
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width <
                                                        1000
                                                ? 100
                                                : 150,
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                'Search',
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Color.fromARGB(
                                                      255, 248, 248, 248),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
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
              SizedBox(
                height: 5.h,
              ),

              //end destination
              //add a form to children

              //   ),
            ],
          ),
        ));
  }
}

//ajouter un modal
typedef ModalCallback = void Function(int nbEnfants, int nbAdultes);

class MyModal extends StatefulWidget {
  final Function(int, int, int, Map<String, Object> body) callbackFunction;

  int counter;
  final void Function() addSelectFields;
  final void Function(int value) removeSelectFields;
  MyModal(
      {required this.counter,
      required this.addSelectFields,
      required this.removeSelectFields,
      required this.callbackFunction});

  @override
  _MyModalState createState() => _MyModalState();
}

class _MyModalState extends State<MyModal> {
  int nbEnfants = 0;
  int nbAdultes = 0;
  int Nbchambres = 0;
  int counter = 0;
  int counters = 0;
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

    Nbchambres = _numFields;

    //NbChambres2;
    // nbEnfants =  //enfant1 + enfant2 + enfant3;
    // nbAdultes = 3; //adult1 + adult2 + adult3;
    widget.callbackFunction(Nbchambres, nbEnfants, nbAdultes, body);
  }

  Future<void> setChambre() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('chambre') != null) {
      prefs.remove('chambre');
    }
    prefs.setString('chambre', '$_numFields');
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
    return Dialog(
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
        child: Container(
            width: 600,
            height: 400,
            child: Column(
              children: [
                Container(
                  width: 900,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset:
                            Offset(0, 3), // Offset in the x and y directions
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Rooms & Guests',
                        style: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      /* Row(mainAxisAlignment: MainAxisAlignment.end
      , crossAxisAlignment: CrossAxisAlignment.end,
        children: [ CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.remove),
          color: Color.fromARGB(255, 11, 11, 11),
          onPressed: () {
            removeSelectFields(index),
          },
        ),
      ),
      SizedBox(width: 10,), CircleAvatar(
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.add),
          color: Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
              addSelectFields();
          },
        ),
      ),],) */
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _numFields,
                  itemBuilder: (BuildContext context, int index) {
                    var fieldNumber = index + 1;

                    counters = _numFields;

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
                                  /* CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 2, 2, 2),
                                    child: IconButton(
                                      icon: Icon(Icons.remove),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      onPressed: () {
                                        removeSelectFields(index);
                                      },
                                    ),
                                  ), */
                                  Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          width: 1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(Icons.remove),
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          onPressed: () {
                                            removeSelectFields(index);
                                          },
                                        ),
                                      )),
                                SizedBox(
                                  width: 10,
                                ),
                                if (index == 0)
                                  /*  CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 3, 3, 3),
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      onPressed: () {
                                        addSelectFields();
                                      },
                                    ),
                                  ) */
                                  Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          width: 1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(Icons.add),
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          onPressed: () {
                                            addSelectFields();
                                          },
                                        ),
                                      )),
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
                                      items: List.generate(5, (index) => index)
                                          .map((adultCount) {
                                        return DropdownMenuItem<int>(
                                          value: adultCount,
                                          child: Text(
                                            adultCount.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
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
                                        items:
                                            List.generate(5, (index) => index)
                                                .map((childrenCount) {
                                          return DropdownMenuItem<int>(
                                            value: childrenCount,
                                            child: Text(
                                              childrenCount.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )),
                                  //ajouter les ages
                                  SizedBox(width: 3.w),
                                  Container(
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
                                                    child: Text(
                                                      age.toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              )),
                                        ],
                                      );
                                    }),
                                  )),
                                  //end ages
                                ],
                              ),
                            ),
                            // Expanded(
                            // child:

                            //   ),
                          ],
                        ),
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
                    height: 60,
                    margin: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: counters == 0
                            ? 150
                            : counters == 1
                                ? 40
                                : counters == 2
                                    ? 10
                                    : 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              elevation: MaterialStateProperty.all(5),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255))),
                          onPressed: () {
                            // Action pour le bouton "Cancel"
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        )),
                        SizedBox(
                          width: 5.w,
                        ),
                        Expanded(
                            child: TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              elevation: MaterialStateProperty.all(5),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(255, 255, 255, 255))),
                          onPressed: () async {
                            await setChambre();
                            envoyerDonnees();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        )),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ))
              ],
            )));
  }
}
