import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:diabetes_app/models/article.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  String title;
  String subtitle;
  String content;
  String category;
  int diabetesType;
  String author;
  //String _seen;
  //String _favorite;
  String image;
  dynamic time = FieldValue.serverTimestamp();
  

  bool _isPopular = false;

  Future<List<Article>> loadArticles() async {
    return allArticles = await _articleProvider.reciveAllArticlesFromDBFuture();
  }

  @override
  void initState() {
    super.initState();
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
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Container(
                height: 210.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/article_coffee_cup_desk_pen.jpg"),
                      fit: BoxFit.fill),
                ),
              ),
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
                          onChanged: (value) => setState(() => title = value),
                          onSaved: (value) {
                            title = value;
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
                              setState(() => subtitle = value),
                          onSaved: (value) {
                            subtitle = value;
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
                            author = value;
                          },
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(22),
                          ],
                        ),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Article Diabetes Type',
                            ),
                            value: diabetesType ?? 1,
                            items: diabetesTypes.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text('$category'),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => diabetesType = value),
                            onSaved: (value) {
                              if ((diabetesType != null)) {
                                diabetesType = value;
                              } else {
                                diabetesType = 1;
                              }
                            }),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              labelText: 'Article Category',
                            ),
                            value: category ?? 'Sport',
                            items: categorys.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text('$category'),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => category = val),
                            onSaved: (value) {
                              if ((category != null)) {
                                category = value;
                              } else {
                                category = 'Sport';
                              }
                            }),
                        CheckboxListTile(
                            title: Text(
                              "Is article popular?",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            activeColor: Colors.green,
                            secondary: Icon(
                              Icons.star,
                              color: Colors.yellow[600],
                              size: 25.0,
                            ),
                            value: _isPopular,
                            onChanged: (bool response) {
                              setState(() {
                                _isPopular = response;
                              });
                            }),
                        SizedBox(
                          height: 15.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Article Content',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15.0)),
                          child: TextFormField(
                            onSaved: (value) {
                              content = value;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: 13,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              border: InputBorder.none,
                              //fillColor: Colors.white,
                            ),
                          ),
                        ),
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
                              return 'Enter full image URL';
                            }
                            return null;
                          },
                          onChanged: (value) => setState(() => image = value),
                          onSaved: (value) {
                            image = value;
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

                                  await _articleProvider.addNewArticle(
                                      uuid.v4(),
                                      title,
                                      subtitle,
                                      content,
                                      category,
                                      diabetesType,
                                      time,
                                      author,
                                      image,
                                      CreatedBy(
                                          name: _auth.user.name,
                                          type: _auth.user.type,
                                          userId: _auth.user.id),
                                      _isPopular);

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
