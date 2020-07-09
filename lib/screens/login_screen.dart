import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login, ResetPassword }

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthMode _authMode = AuthMode.Login;
  AuthProvider _auth;
  ChatProvider _chatProvider;
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _firstInit = true;
  final _passwordController = TextEditingController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
  };

  @override
  void initState() {
    super.initState();
    if (_firstInit) {
      _auth = Provider.of<AuthProvider>(context, listen: false);
      _chatProvider = Provider.of<ChatProvider>(context, listen: false);
      _firstInit = false;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Alert!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    String _res = '';

    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_authMode == AuthMode.Login) {
      // Login User
      _res = await _auth.signIn(
          email: _authData['email'].trim(),
          password: _authData['password'].trim());
    } else if (_authMode == AuthMode.Signup) {
      // Sign user up
      _res = await _auth.signUp(
          email: _authData['email'].trim(),
          password: _authData['password'].trim(),
          name: _authData['name']);
      if (_res == null) {
        await _auth.fetchAndSetUser().whenComplete(() {
          _chatProvider.createNewChatRoomForUser(_auth.user);
        });
      }
      setState(() {
        _authMode = AuthMode.Login;
      });
    } else {
      _res = await _auth.resetPassword(_authData['email'].trim());
    }
    if (_res != null) {
      _showErrorDialog(_res);
      setState(() {
        _isLoading = false;
        _formKey.currentState.reset();
        _passwordController.clear();
      });
    }
  }

  void _switchAuthMode(AuthMode mode) {
    switch (mode) {
      case AuthMode.Login:
        setState(() {
          _authMode = AuthMode.Login;
        });
        break;
      case AuthMode.Signup:
        setState(() {
          _authMode = AuthMode.Signup;
        });
        break;
      case AuthMode.ResetPassword:
        setState(() {
          _authMode = AuthMode.ResetPassword;
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _firstInit
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(40),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  labelText: 'E-Mail',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'Invalid email!';
                                  }
                                },
                                onSaved: (value) {
                                  _authData['email'] = value;
                                },
                              ),
                              // TextFormField(
                              //   decoration: InputDecoration(
                              //     fillColor: Colors.grey[350],
                              //     hintText: 'Enter Email Add',
                              //     filled: true,
                              //     enabledBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(color: Colors.white, width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     focusedBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(color: Colors.pink, width: 2.0),
                              //     ),
                              //   ),
                              //   validator: (val) {
                              //     if (val.isEmpty) {
                              //       return 'Add Challenge Name';
                              //     }
                              //     // else if (checkChallengeName(val[0].toUpperCase() + val.substring(1))){
                              //     //   _sameNames = true;
                              //     //   //checkChallengeName(val[0].toUpperCase() + val.substring(1))
                              //     //   return 'This Name Exists';
                              //     // }
                              //     return null;
                              //   },
                              //   onChanged: (val) => setState(() => _challengeName = val),
                              // ),
                              if (_authMode != AuthMode.ResetPassword)
                                TextFormField(
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    labelText: 'Password',
                                  ),
                                  controller: _passwordController,
                                  obscureText: true,
                                  onFieldSubmitted: (_) {
                                    _submit();
                                  },
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value.isEmpty || value.length < 5) {
                                      return 'Password is too short!';
                                    }
                                  },
                                  onSaved: (value) {
                                    _authData['password'] = value;
                                  },
                                ),
                              if (_authMode == AuthMode.Signup)
                                Column(
                                  children: <Widget>[
                                    TextFormField(
                                      enabled: _authMode == AuthMode.Signup,
                                      decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          labelText: 'Confirm Password'),
                                      obscureText: true,
                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty || value.length < 5) {
                                          return 'Password is too short!';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Passwords not match';
                                        }
                                      },
                                    ),
                                    TextFormField(
                                      cursorColor:
                                          Theme.of(context).primaryColor,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        labelText: 'Display Name',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) => value.isEmpty
                                          ? 'Display Name is not valid'
                                          : null,
                                      onSaved: (value) {
                                        _authData['name'] = value;
                                      },
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: 25,
                              ),
                              if (_isLoading)
                                CircularProgressIndicator()
                              else
                                ButtonTheme(
                                  minWidth: 300.0,
                                  child: RaisedButton(
                                    color: Color(0xFFc1b7f3),
                                    onPressed: _submit,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      _authMode == AuthMode.ResetPassword
                                          ? 'SEND'
                                          : '${_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'}',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  if (_authMode != AuthMode.ResetPassword)
                                    MaterialButton(
                                      onPressed: () => _switchAuthMode(
                                          _authMode == AuthMode.Login
                                              ? AuthMode.Signup
                                              : AuthMode.Login),
                                      splashColor:
                                          Theme.of(context).primaryColor,
                                      child: Text(
                                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  MaterialButton(
                                    onPressed: () => _switchAuthMode(
                                        _authMode == AuthMode.ResetPassword
                                            ? AuthMode.Login
                                            : AuthMode.ResetPassword),
                                    splashColor: Theme.of(context).primaryColor,
                                    child: Text(
                                      '${_authMode == AuthMode.ResetPassword ? 'Login' : 'Forgot Password'}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
