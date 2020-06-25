import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

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

  final _passwordController = TextEditingController();

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
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
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // Login User
        var res = await _auth.signIn(
            email: _authData['email'].trim(),
            password: _authData['password'].trim());
        if (res != null) {
          _showErrorDialog(res);
          setState(() {
            _isLoading = false;
            _formKey.currentState.reset();
          });
        }
      } else {
        // Sign user up
        var res = await _auth.signUp(
            email: _authData['email'].trim(),
            password: _authData['password'].trim(),
            name: _authData['name']);
        if (res != null) {
          _showErrorDialog(res);
          setState(() {
            _isLoading = false;
            _formKey.currentState.reset();
          });
        }
      }
    } catch (error) {
      _showErrorDialog(error.message);
      setState(() {
        _formKey.currentState.reset();
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    _chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
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
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    labelText: 'Confirm Password'),
                                obscureText: true,
                                validator: _authMode == AuthMode.Signup
                                    ? (value) =>
                                        value != _passwordController.text
                                            ? 'Passwords not match'
                                            : null
                                    : null,
                              ),
                              TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
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
                                '${_authMode == AuthMode.Login ? 'LOGIN' : 'SIGNUP'}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: _switchAuthMode,
                              splashColor: Theme.of(context).primaryColor,
                              child: Text(
                                '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {},
                              splashColor: Theme.of(context).primaryColor,
                              child: Text(
                                'Forgot password',
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
