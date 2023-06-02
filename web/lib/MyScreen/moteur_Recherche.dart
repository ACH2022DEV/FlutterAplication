/* import 'package:flutter/material.dart';

class HotelSearchForm extends StatefulWidget {
  @override
  _HotelSearchFormState createState() => _HotelSearchFormState();
}

class _HotelSearchFormState extends State<HotelSearchForm> {
  final _formKey = GlobalKey<FormState>();
  late String _city;
  late String _checkIn;
  late String _checkOut;
  int _numAdults = 1;
  int _numChildren = 0;
  List<Map<String, dynamic>> _childrenAges = [];

  void _submitForm() async {
    // Validation code goes here
    // Call the fetchPosts() function with the entered data
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'City'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a city';
              }
              return null;
            },
            onSaved: (value) {
              _city = value!;
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Check-in'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a check-in date';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _checkIn = value!;
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Check-out'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a check-out date';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _checkOut = value!;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  value: _numAdults,
                  items: List.generate(10, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1} Adult${index == 0 ? '' : 's'}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _numAdults = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField(
                  value: _numChildren,
                  items: List.generate(10, (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text('${index} Child${index == 1 ? '' : 'ren'}'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _numChildren = value;
                    });
                  },
                ),
              ),
            ],
          ),
          if (_numChildren > 0) ...[
            SizedBox(height: 10),
            Text('Children ages'),
            SizedBox(height: 5),
            for (int i = 0; i < _numChildren; i++)
              TextFormField(
                decoration: InputDecoration(labelText: 'Child ${i + 1} age'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a child age';
                  }
                  return null;
                },
                on
 */
/*import 'package:flutter/material.dart';

class ExampleWidget extends StatefulWidget {
  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  List<int> _selectedOption2 = [1];
  List<List<int>> _selectedAges = [[]];
  List<int> _options = [1, 2, 3];
  int _numFields = 1;

  void _addSelectFields() {
    setState(() {
      _numFields++;
      _selectedOption2.add(1);
      _selectedAges.add([]);
    });
  }

  void _removeSelectFields(int index) {
    setState(() {
      _numFields--;
      _selectedOption2.removeAt(index);
      _selectedAges.removeAt(index);
    });
  }

  void _addSelectAge(int index) {
    setState(() {
      _selectedAges[index].add(1);
    });
  }

  void _removeSelectAge(int index, int ageIndex) {
    setState(() {
      _selectedAges[index].removeAt(ageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Field Duplicator')),
      body: ListView.builder(
        itemCount: _numFields,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Select 1',
                          border: OutlineInputBorder(),
                        ),
                        value: 1,
                        onChanged: (newValue) {},
                        items: _options.map((int option) {
                          return DropdownMenuItem<int>(
                            value: option,
                            child: Text(option.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Number of Children',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedOption2[index],
                        onChanged: (newValue) {
                          setState(() {
                            _selectedOption2[index] = newValue!;
                            if (_selectedOption2[index] == 1) {
                              _selectedAges[index].add(0);
                            } else {
                              _selectedAges[index] = [];
                            }
                          });
                        },
                        items: _options.map((int option) {
                          return DropdownMenuItem<int>(
                            value: option,
                            child: Text(option.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeSelectFields(index),
                  ),
                ],
              ),
              if (_selectedOption2[index] == 1)
                Column(
                  children: [
                    for (int ageIndex = 0;
                        ageIndex < _selectedAges[index].length;
                        ageIndex++)
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Select Age',
                                  border: OutlineInputBorder(),
                                ),
                                value: _selectedAges[index][ageIndex],
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedAges[index][ageIndex] = newValue!;
                                  });
                                },
                                items: _options.map((int option) {
                                  return DropdownMenuItem<int>(
                                    value: option,
                                    child: Text(option.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeSelectAge(index, ageIndex),
                          ),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () => _addSelectAge(index),
                      child: Text('Add Age'),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSelectFields,
        child: Icon(Icons.add),
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';

class AgeFields extends StatefulWidget {
  @override
  _AgeFieldsState createState() => _AgeFieldsState();
}

class _AgeFieldsState extends State<AgeFields> {
  int _selectedOption = 1;
  List<TextEditingController> _ageControllers = [TextEditingController()];

   _onSelectedOptionChanged(int value) {
    setState(() {
      _selectedOption = value;
      _ageControllers = List.generate(value, (index) => TextEditingController());
    });
  }

    _onAddAgeField() {
    setState(() {
      _ageControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Age Fields Example"),
      ),
      body: Column(
        children: [
          RadioListTile(
            title: Text("Option 1"),
            value: 1,
            groupValue: _selectedOption,
            onChanged: _onSelectedOptionChanged,
          ),
          RadioListTile(
            title: Text("Option 2"),
            value: 2,
            groupValue: _selectedOption,
            onChanged: _onSelectedOptionChanged,
          ),
          RadioListTile(
            title: Text("Option 3"),
            value: 3,
            groupValue: _selectedOption,
            onChanged: _onSelectedOptionChanged,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedOption,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return SizedBox.shrink();
                }

                return ListTile(
                  leading: Text("Field ${index + 1}"),
                  title: TextFormField(
                    controller: _ageControllers[index - 1],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Age",
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _onAddAgeField,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/