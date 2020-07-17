import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/models/healthInfo.dart';
import 'package:diabetes_app/providers/healthInfo_provider.dart';
import 'package:diabetes_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:age/age.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/auth_provider.dart';
import '../models/createdBy.dart';

class PersonalInfo extends StatefulWidget {
  static const routeName = '/personalInfo';
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

//final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

List<GlobalKey<FormState>> _formKey = [];

AuthProvider _auth;
HealthInfoProvider _healthInfoProvider;

var uuid = Uuid();

final List<String> categorys = [
  '1',
  '2',
  'GDM',
  'MODY',
  'PREDIABETES',
  'other'
];
final List<String> gendarType = ['Male', 'Female'];

DateTime dateTime = DateTime.now();
final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

AgeDuration age;
String name;
dynamic birthday;
String gendar;
dynamic diabetesDiagnosisDate;
double weight;
double height;
double bmi;
String diabetesTypeOption;
String pump;
String medication;
String sensor;
String email;

class _PersonalInfoState extends State<PersonalInfo> {
  Random random = new Random();
  int randomNumber;

  @override
  void initState() {
    randomNumber = random.nextInt(99);
    _formKey = new List<GlobalKey<FormState>>.generate(
        100, (i) => new GlobalKey<FormState>(debugLabel: ' _formKey'));
    height = null;
    super.initState();
  }

  double calculateBMI(double weight, double height) {
    if (weight == null || height == null) {
      weight = 0;
      height = 1;
    }

    bmi = weight / pow(height / 100, 2);

    return bmi;
  }

  getAge(DateTime birthday, DateTime dateTime) {
    var age = Age.dateDifference(
        fromDate: birthday, toDate: dateTime, includeToDate: false);
    if (age != null) {
      return age.years;
    }
    return dateTime;
  }

  String personFullName(String firstName, String lastName) {
    return (firstName + " " + lastName).toString();
  }

  void onBirthdayChange(DateTime chosen) {
    setState(() {
      birthday = chosen;
    });
  }

  void onDiabetesDateChange(DateTime chosen) {
    setState(() {
      diabetesDiagnosisDate = chosen;
    });
  }

  DateTime birthdayChangeStore(DateTime chosen) {
    setState(() {
      birthday = chosen;
    });
    return birthday;
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        //Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen())); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Patient Added Successfully"),
      content: Text("Email was sent to " + email), // need to add email
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    _healthInfoProvider = Provider.of<HealthInfoProvider>(context);
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
                key: _formKey[randomNumber],
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
                        labelText: 'Full Name (First + Last)',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Invalid name!';
                        }
                      },
                      onChanged: (value) => setState(() => name = value),
                      onSaved: (value) {
                        name = value;
                        print(name);
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
                        onChanged: (val) => setState(() => gendar = val),
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
                          const Text(
                            'Birthday',
                            style: TextStyle(
                              color: Color(0xFF7f70e7),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                          ),
                          CupertinoDateTextBox(
                              initialValue: dateTime,
                              onDateChange: onBirthdayChange,
                              hintText: DateFormat.yMd().format(dateTime)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Weight In Kilograms',
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'Height In Centimeters',
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
                        // filled: true,
                        // fillColor: (calculateBMI(weight == null ? 0 : weight, height == null ? 0 :  weight)) > 10 ?
                        //Colors.green : Colors.red,
                        isDense: true,
                        hintText:
                            'BMI = ' + calculateBMI(weight, height).toString(),
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                                color: CupertinoColors.inactiveGray,
                                width: 2.0)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                                color: CupertinoColors.inactiveGray,
                                width: 0.0)),
                      ),
                      onChanged: (value) =>
                          setState(() => bmi = double.parse(value)),
                      onSaved: (value) {
                        bmi = calculateBMI(weight, height);
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
                        value: diabetesTypeOption ?? '1',
                        items: categorys.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text('$category'),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            diabetesTypeOption = value;
                          });
                        },
                        onSaved: (value) {
                          if ((diabetesTypeOption != null)) {
                            diabetesTypeOption = value;
                          } else {
                            diabetesTypeOption = '1';
                          }
                          print(diabetesTypeOption);
                        }),
                    SizedBox(
                      height: 15.0,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Diabetes Diagnosis Date',
                            style: TextStyle(
                              color: Color(0xFF7f70e7),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                          ),
                          CupertinoDateTextBox(
                              initialValue: dateTime,
                              onDateChange: onDiabetesDateChange,
                              hintText: DateFormat.yMd().format(dateTime)),
                        ],
                      ),
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
                        labelText: 'Medication',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Medication cant be empty';
                        }
                      },
                      onChanged: (value) =>
                          setState(() => medication = (value)),
                      onSaved: (value) {
                        medication = (value);
                        print(medication);
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
                        labelText: 'Pump',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Pump cant be empty';
                        }
                      },
                      onChanged: (value) => setState(() => pump = (value)),
                      onSaved: (value) {
                        pump = (value);
                        print(pump);
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
                        labelText: 'Sensor',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Sensor cant be empty';
                        }
                      },
                      onChanged: (value) => setState(() => sensor = (value)),
                      onSaved: (value) {
                        sensor = (value);
                        print(sensor);
                      },
                    ),
                    TextFormField(
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        labelText: 'User E-Mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      },
                      onSaved: (String value) {
                        email = value;
                      },
                    ),
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
                        ),
                        onPressed: () async {
                          try {
                            if (_formKey[randomNumber]
                                .currentState
                                .validate()) {
                              _formKey[randomNumber].currentState.save();
                              age = Age.dateDifference(
                                  fromDate: birthday,
                                  toDate: dateTime,
                                  includeToDate: false);

                              await _healthInfoProvider.addNewHealthInfo(
                                uuid.v4(),
                                name,
                                age.toString(),
                                age.years,
                                diabetesTypeOption,
                                gendar,
                                Timestamp.fromMicrosecondsSinceEpoch(
                                        birthday.microsecondsSinceEpoch)
                                    .toDate(),
                                Timestamp.fromMicrosecondsSinceEpoch(
                                        diabetesDiagnosisDate
                                            .microsecondsSinceEpoch)
                                    .toDate(),
                                weight.toString(),
                                height.toString(),
                                bmi.toStringAsFixed(3).toString(),
                                medication,
                                pump,
                                sensor,
                                CreatedBy(
                                    name: _auth.user.name,
                                    type: _auth.user.type,
                                    userId: _auth.user.id),
                                email,
                              );

                              await showAlertDialog(context);

                              // await Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomeScreen()));
                            }
                          } catch (e) {
                            print(e);
                          }
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
      final formatter = new DateFormat('dd/MM/yyyy');

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
