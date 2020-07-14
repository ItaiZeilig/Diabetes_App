import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:age/age.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

final _formKey = GlobalKey<FormState>();

<<<<<<< HEAD
final List<String> categorys = ['1' , '2' , 'GDM' , 'MODY'  , 'PREDIABETES' , 'other'];
final List<String> gendarType = ['Male' , 'Female'];
=======
final List<String> categorys = [
  '1',
  '2',
  'GDM',
  'MODY',
  'PREDIABETES',
  'other'
];
>>>>>>> f15dcf65b66af863879a9f74241212bee40b02c0

DateTime dateTime = DateTime.now();
final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

AgeDuration age;

String firstName;
String lastName;
DateTime birthday;
bool male = false;
bool female = false;
bool isEnable = true;
String gendar;
String diabetesDiagnosisDate;
double weight;
double height;
double bmi;
String fullDiabetesTypeOption;
int diabetesType;
String pump;
String medication;
String sensor;

class _PersonalInfoState extends State<PersonalInfo> {
  double calculateBMI(double weight, double height) {
    bmi = weight / pow(height / 100, 2);
    return bmi;
  }
  getAge(DateTime birthday, DateTime dateTime){
    var age = Age.dateDifference(fromDate: birthday, toDate: dateTime, includeToDate: false);
    if(age != null) {
      return age.years;
    }
    return dateTime;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Personal Info"),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              child: Center(
                child: Text(
                  'Personal Information',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 27.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'First Name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invalid name!';
                        }
                      },
                      onChanged: (value) => setState(() => firstName = value),
                      onSaved: (value) {
                        firstName = value;
                        print(firstName);
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Last Name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invalid name!';
                        }
                      },
                      onChanged: (value) => setState(() => lastName = value),
                      onSaved: (value) {
                        lastName = value;
                        print(lastName);
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Male:'),
                        Checkbox(
                            value: male,
                            onChanged: (bool response) {
                              setState(() {
                                male = response;
                                if (male == true) {
                                  print(male);
                                  gendar = 'Male';
                                }
                              });
                            }),
                        Text('Female:'),
                        Checkbox(
                            tristate: false,
                            value: female,
                            onChanged: (bool response) {
                              setState(() {
                                female = response;
                                print(female);
                                if (female == true) {
                                  gendar = 'Female';
                                }
                              });
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Birthday',
                            style: TextStyle(
                              color: Color(0xFF7f70e7),
                            ),
                          ),
<<<<<<< HEAD
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Invalid name!';
                            }
                          },
                          onChanged: (value) => setState(() => lastName = value),
                          onSaved: (value) {
                            lastName = value;
                            print(lastName);
                          },
                        ),
                                                
                        
                        
                       DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Gendar',
                            ),
                            value: gendar ?? 'Male',
                            items: gendarType.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text('$category'),
                              );
                            }).toList(),
                            //onChanged: (val) => setState(() => fullDiabetesTypeOption = val),
                            onChanged: (String value){                              
                              setState(() {
                                gendar = value;                                                              
                              });
                            },
                            onSaved: (value) {
                              if ((gendar != null)) {
                                gendar = value;
                              } else {
                                gendar = 'Male';
                              }
                            }),
                                                

                         SizedBox(
                          height: 15.0,
                        ),


                        Material(
                          color: Colors.transparent,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[                            
                              Text('Birthday',
                                  style: TextStyle(
                                  color: Color(0xFF7f70e7),
                                  ),
                                ),                              
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                              ),
                              CupertinoDateTextBox(
                                  initialValue: dateTime,
                                  onDateChange: onBirthdayChange,
                                  hintText: DateFormat.yMd().format(dateTime)),
                            ],
=======
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
>>>>>>> f15dcf65b66af863879a9f74241212bee40b02c0
                          ),
                          CupertinoDateTextBox(
                              initialValue: dateTime,
                              onDateChange: onBirthdayChange,
                              hintText: DateFormat.yMd().format(dateTime)),
                        ],
                      ),
<<<<<<< HEAD


                        TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Weight in Kilograms',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Weight cant be empty';
                            }
                          },
                          onChanged: (value) =>
                              setState(() => weight = double.parse(value)),
                          onSaved: (value) {
                            weight = double.parse(value);
                            print(weight);
                          },
=======
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Weight in Kilograms',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Weight cant be empty';
                        }
                      },
                      onChanged: (value) =>
                          setState(() => weight = double.parse(value)),
                      onSaved: (value) {
                        weight = double.parse(value);
                        print(weight);
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
>>>>>>> f15dcf65b66af863879a9f74241212bee40b02c0
                        ),
                        labelText: 'Height in meters',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Height cant be empty';
                        }
                      },
                      onChanged: (value) =>
                          setState(() => height = double.parse(value)),
                      onSaved: (value) {
                        height = double.parse(value);
                        print(height);
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'BMI = ' +
                            calculateBMI(weight ?? 1, height ?? 1).toString(),
                        hintStyle: TextStyle(
                          color: Color(0xFF7f70e7),
                        ),
<<<<<<< HEAD
                        TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Height in Centimeter',
=======
                        //contentPadding: EdgeInsets.all(widget.textfieldPadding),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                                color: CupertinoColors.inactiveGray,
                                width: 0.0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                                color: CupertinoColors.inactiveGray,
                                width: 0.0)),
                      ),
                      onSaved: (value) {
                        bmi = calculateBMI(weight ?? 1, height ?? 1);
                        print(bmi);
                      },
                    ),
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
>>>>>>> f15dcf65b66af863879a9f74241212bee40b02c0
                          ),
                          labelText: 'Diabetes Type',
                        ),
<<<<<<< HEAD


                        TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'BMI = ' +  calculateBMI(weight == null ? 0 : weight,height == null ? 0 : height).toString(),
                              hintStyle: TextStyle(
                                  color: Color(0xFF7f70e7), ),
                              //contentPadding: EdgeInsets.all(widget.textfieldPadding),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                      color: CupertinoColors.inactiveGray, width: 0.0)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                      color: CupertinoColors.inactiveGray, width: 0.0)),
                            ),
                            onSaved: (value) {
                            bmi = calculateBMI(weight,height);
                            print(bmi);
                          },
                        ),



                        
                        
                        
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Diabetes Type',
                            ),
                            value: fullDiabetesTypeOption ?? '1',
                            items: categorys.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text('$category'),
                              );
                            }).toList(),
                            //onChanged: (val) => setState(() => fullDiabetesTypeOption = val),
                            onChanged: ( value){                              
                              setState(() {
                                fullDiabetesTypeOption = value.toString();
                                if(int.parse(fullDiabetesTypeOption) == 1){
                                  diabetesType = 1;
                                  print(diabetesType.toString() + " Ths is type 1");
                                }
                                else{
                                  diabetesType = 2;
                                  print(diabetesType.toString() + " Ths is type 2");
                                }
                                
                              });
                            },
                            onSaved: (value) {
                              if ((fullDiabetesTypeOption != null)) {
                                fullDiabetesTypeOption = value;
                              } else {
                                fullDiabetesTypeOption = '1';
                              }
                            }),
                        
                        
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: RaisedButton(
                            color: Colors.white,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Complete  ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(
                                  Icons.playlist_add_check,
                                  color: Colors.green,
                                ),
                              ],
=======
                        value: fullDiabetesTypeOption ?? '1',
                        items: categorys.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text('$category'),
                          );
                        }).toList(),
                        //onChanged: (val) => setState(() => fullDiabetesTypeOption = val),
                        onChanged: (String value) {
                          setState(() {
                            fullDiabetesTypeOption = value;
                            if (int.parse(fullDiabetesTypeOption) == 1) {
                              diabetesType = 1;
                              print(diabetesType.toString() + " Ths is type 1");
                            } else {
                              diabetesType = 2;
                              print(diabetesType.toString() + " Ths is type 2");
                            }
                          });
                        },
                        onSaved: (value) {
                          if ((fullDiabetesTypeOption != null)) {
                            fullDiabetesTypeOption = value;
                          } else {
                            fullDiabetesTypeOption = '1';
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RaisedButton(
                        color: Colors.white,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Complete  ',
                              style: TextStyle(color: Colors.black),
                            ),
                            Icon(
                              Icons.playlist_add_check,
                              color: Colors.green,
>>>>>>> f15dcf65b66af863879a9f74241212bee40b02c0
                            ),
                          ],
                        ),
                        onPressed: () async {
                          // try {
                          if (_formKey.currentState.validate()) {
                            print(formattedDate);
                            //  print(birthdayChangeStore(birthday));
                            //  final difference = dateTime.difference(birthday).inDays;
                            //  print(difference);

                            age = Age.dateDifference(
                                fromDate: birthday,
                                toDate: dateTime,
                                includeToDate: false);

                            print(age.years);

                            //     _formKey.currentState.save();

                            //     await _articleProvider.addNewArticle(
                            //         uuid.v4(),
                            //         title,
                            //         subtitle,
                            //         content,
                            //         category,
                            //         diabetesType,
                            //         time,
                            //         author,
                            //         image,
                            //         CreatedBy(
                            //             name: _auth.user.name,
                            //             type: _auth.user.type,
                            //             userId: _auth.user.id),
                            //         _isPopular);

                            //     await Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => HomeScreen()));
                          }
                          // } catch (e) {}
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onBirthdayChange(DateTime chosen) {
    setState(() {
      birthday = chosen;
    });
  }

  DateTime birthdayChangeStore(DateTime chosen) {
    setState(() {
      birthday = chosen;
    });
    return birthday;
  }
}

class CupertinoDateTextBox extends StatefulWidget {
  /// A text box widget which displays a cupertino picker to select a date if clicked
  CupertinoDateTextBox(
      {@required this.initialValue,
      @required this.onDateChange,
      @required this.hintText,
      //this.color = CupertinoColors.label,
      this.color,
      this.hintColor = CupertinoColors.inactiveGray,
      this.pickerBackgroundColor = CupertinoColors.systemBackground,
      this.fontSize = 17.0,
      this.textfieldPadding = 15.0,
      this.enabled = true});

  /// The initial value which shall be displayed in the text box
  final DateTime initialValue;

  /// The function to be called if the selected date changes
  final Function onDateChange;

  /// The text to be displayed if no initial value is given
  final String hintText;

  /// The color of the text within the text box
  final Color color;

  /// The color of the hint text within the text box
  final Color hintColor;

  /// The background color of the cupertino picker
  final Color pickerBackgroundColor;

  /// The size of the font within the text box
  final double fontSize;

  /// The inner padding within the text box
  final double textfieldPadding;

  /// Specifies if the text box can be modified
  final bool enabled;

  @override
  _CupertinoDateTextBoxState createState() => new _CupertinoDateTextBoxState();
}

class _CupertinoDateTextBoxState extends State<CupertinoDateTextBox> {
  final double _kPickerSheetHeight = 250.0;

  DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialValue;
  }

  void callCallback() {
    widget.onDateChange(_currentDate);
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: TextStyle(
          color: widget.color,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  void onSelectedDate(DateTime date) {
    setState(() {
      _currentDate = date;
    });
  }

  Widget _buildTextField(String hintText, Function onSelectedFunction) {
    String fieldText;
    Color textColor;
    if (_currentDate != null) {
      final formatter = new DateFormat.yMd();
      fieldText = formatter.format(_currentDate);
      textColor = widget.color;
    } else {
      fieldText = hintText;
      textColor = widget.hintColor;
    }

    return new Flexible(
      child: new GestureDetector(
        onTap: !widget.enabled
            ? null
            : () async {
                if (_currentDate == null) {
                  setState(() {
                    _currentDate = DateTime(1992, 1, 1, 1, 1);
                  });
                }
                await showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBottomPicker(CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        backgroundColor: widget.pickerBackgroundColor,
                        initialDateTime: _currentDate,
                        onDateTimeChanged: (DateTime newDateTime) {
                          onSelectedFunction(newDateTime);
                        }));
                  },
                );

                // call callback
                callCallback();
              },
        child: new InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(
                color: CupertinoColors.inactiveGray, fontSize: widget.fontSize),
            contentPadding: EdgeInsets.all(widget.textfieldPadding),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                    color: CupertinoColors.inactiveGray, width: 0.0)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                    color: CupertinoColors.inactiveGray, width: 0.0)),
          ),
          child: new Text(
            fieldText,
            style: TextStyle(
              color: textColor,
              fontSize: widget.fontSize,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      _buildTextField(widget.hintText, onSelectedDate),
    ]);
  }
}
