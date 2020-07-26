import 'package:diabetes_app/providers/healthInfo_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthProvider _auth;
  HealthInfoProvider _healthInfoProvider;
  var firstInit = true;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool showReports = true;
  String _password;
  String _email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstInit) {
      _auth = Provider.of<AuthProvider>(context);
      _healthInfoProvider = Provider.of<HealthInfoProvider>(context);
      if (_auth.user == null) {
        _auth.fetchAndSetUser().whenComplete(() {
          setState(() {
            firstInit = false;
          });
        });
      } else {
        setState(() {
          firstInit = false;
        });
      }
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Message:'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    bool pass = true;
    String message = 'Successfully changed';
    FirebaseUser user = await _auth.getFirebaseUser;

    try {
      if (user != null) {
        // Update Email
        await user.updateEmail(_email).then((_) {}).catchError((error) {
          pass = false;
          switch (error.code) {
            case 'ERROR_REQUIRES_RECENT_LOGIN':
              message = "Please login again to the app to change your info!";
              break;
            case 'ERROR_EMAIL_ALREADY_IN_USE':
              message = "Sorry this email is already in use!";
              break;
            default:
          }
        });
        // Update Password
        if (_password.trim().isNotEmpty)
          await user.updatePassword(_password).then((_) {}).catchError((error) {
            pass = false;
            switch (error.code) {
              case 'ERROR_REQUIRES_RECENT_LOGIN':
                message = "Please login again to the app to change your info!";
                break;
              case 'ERROR_WEAK_PASSWORD':
                message = "This password is too weak, please enter strong one!";
                break;
              default:
            }
          });
      }
    } catch (e) {
      print(e.message);
    }
    if (!pass) {
      _healthInfoProvider.updateHealthInfoEmail(_email, user.email);
      _showAlertDialog(message);
    } else {
      _auth
          .updateUserInfo(_auth.user)
          .whenComplete(() => _showAlertDialog(message));
      _auth.fetchAndSetUser();
    }
    setState(() {
      FocusScope.of(context).unfocus();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: firstInit
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).accentColor),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(Icons.arrow_back_ios),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    showReports = !showReports;
                                  });
                                },
                                icon: Icon(Icons.settings),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: NetworkImage(
                                "https://image.freepik.com/free-vector/man-profile-cartoon_18591-58482.jpg"),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(_auth.user.name,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    bottom: showReports ? 0 : -_deviceSize.height,
                    child: Container(
                      margin: EdgeInsets.only(top: _deviceSize.height * 0.5),
                      width: _deviceSize.width,
                      height: _deviceSize.height * 0.5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Profile Details",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Data(
                                attribute: "Age: ",
                                info: _healthInfoProvider.healthInfo.ageYears
                                    .toString(),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Data(
                                attribute: "BMI: ",
                                info: _healthInfoProvider.healthInfo.bmi,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Data(
                                attribute: "Diabetes Type: ",
                                info:
                                    _healthInfoProvider.healthInfo.diabetesType,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Data(
                                attribute: "Medication: ",
                                info: _healthInfoProvider.healthInfo.medication,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Data(
                                attribute: "Pump: ",
                                info: _healthInfoProvider.healthInfo.pump,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Data(
                                attribute: "Sensor: ",
                                info: _healthInfoProvider.healthInfo.sensor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    bottom: showReports ? -_deviceSize.height : 0,
                    child: Container(
                        margin: EdgeInsets.only(top: _deviceSize.height * 0.5),
                        width: _deviceSize.width,
                        height: _deviceSize.height * 0.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30))),
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: _deviceSize.width / 8),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        cursorColor:
                                            Theme.of(context).primaryColor,
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          labelText: 'New E-Mail',
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        initialValue: _auth.user.email,
                                        // ignore: missing_return
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Invalid email!';
                                          }
                                        },
                                        onSaved: (value) {
                                          setState(() {
                                            _email = value;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        cursorColor:
                                            Theme.of(context).primaryColor,
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          labelText: 'New Password',
                                        ),

                                        obscureText: true,
                                        // ignore: missing_return
                                        onSaved: (value) {
                                          _password = value;
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      if (_isLoading)
                                        CircularProgressIndicator()
                                      else
                                        ButtonTheme(
                                          child: RaisedButton(
                                            color:
                                                Theme.of(context).accentColor,
                                            onPressed: _submit,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              'Save',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}

class Data extends StatelessWidget {
  //final IconData icon;
  final String attribute;
  final String info;

  Data({this.attribute, this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: <Widget>[
          //Icon(icon, color:Colors.grey[400]),
          Text(attribute,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(width: 5.0),
          Text(info, style: TextStyle(fontSize: 20.0)),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
