import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:diabetes_app/models/article.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/createdBy.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class AddNewArticle extends StatefulWidget {
  static const routeName = '/addNewArticle';

  @override
  _AddNewArticleState createState() => _AddNewArticleState();
}

class _AddNewArticleState extends State<AddNewArticle> {
  Article article;
  List<Article> allArticles = [];
  AuthProvider _auth;

  var uuid = Uuid();

  ArticleProvider _articleProvider = ArticleProvider();

  final List<String> categorys = ['Sport', 'Nutrition', 'Medical'];
  final List<int> diabetesTypes = [1, 2];

  final _formKey = GlobalKey<FormState>();

  String _title;
  String _subtitle;
  String _content;
  String _category;
  int _diabetesType;
  String _author;
  String _seen;
  String _favorite;
  String _image;
  dynamic _time = FieldValue.serverTimestamp();

  Future<List<Article>> loadArticles() async {
    return allArticles =
        await _articleProvider.reciveAllChallengesFromDBFuture();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Arcitle"),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              //child: Center(
              child: Text(
                'Add Article',
                style: (TextStyle(fontWeight: FontWeight.bold, fontSize: 27.0)),
              ),
              //),
            ),
            //SizedBox(height: 5.0),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 40.0, left: 40.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Article Title',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Invalid name!';
                            }
                          },
                          onChanged: (value) => setState(() => _title = value),
                          onSaved: (value) {
                            _title = value;
                          },
                        ),
                        TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Article Sub - Title',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Article Title cant be empty';
                            }
                          },
                          onChanged: (value) =>
                              setState(() => _subtitle = value),
                          onSaved: (value) {
                            _subtitle = value;
                          },
                        ),
                        TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Article Author',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Article Author cant be empty';
                            }
                          },
                          onSaved: (value) {
                            _author = value;
                          },
                        ),
                        TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Article Content',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Content cant be empty';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _content = value;
                          },
                        ),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Article Category',
                            ),
                            value: _category ?? 'Sport',
                            items: categorys.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text('$category'),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _category = val),
                            onSaved: (value) {
                              if ((_category != null)) {
                                _category = value;
                              } else {
                                _category = 'Sport';
                              }
                            }),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Article Diabetes Type',
                            ),
                            value: _diabetesType ?? 1,
                            items: diabetesTypes.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text('$category'),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => _diabetesType = value),
                            onSaved: (value) {
                              if ((_diabetesType != null)) {
                                _diabetesType = value;
                              } else {
                                _diabetesType = 1;
                              }
                            }),
                        TextFormField(
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            labelText: 'Article Image',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter image URL';
                            }
                            return null;
                          },
                          onChanged: (value) => setState(() => _image = value),
                          onSaved: (value) {
                            _image = value;
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
                                  'Add Article  ',
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
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  _articleProvider.addNewArticle(
                                      uuid.v4(),
                                      _title,
                                      _subtitle,
                                      _content,
                                      _category,
                                      _diabetesType,
                                      _time,
                                      _author,
                                      _image,
                                      CreatedBy(
                                          name: _auth.user.name,
                                          type: _auth.user.type,
                                          userId: _auth.user.id));

                                  //allArticles = await loadArticles();
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                }
                              } catch (e) {}
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
