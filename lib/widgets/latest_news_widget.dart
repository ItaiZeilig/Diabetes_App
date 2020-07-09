import 'package:diabetes_app/models/article.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LatesNews extends StatefulWidget {
  final Article article;

  LatesNews({this.article});

  @override
  _LatesNewsState createState() => _LatesNewsState(article: article);
}

class _LatesNewsState extends State<LatesNews> {
  _LatesNewsState({this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey[400], width: 1.0),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 90.0,
            height: 135.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: NetworkImage(article.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    article.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                   SizedBox(height: 4.0),
                  Text(
                    article.subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    article.content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  Spacer(),
                  //SizedBox(height: 6.0),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text(
                         DateFormat('yyyy-MM-dd hh:mm')
                              .format(article.time.toDate()) != null ? DateFormat('yyyy-MM-dd hh:mm')
                              .format(article.time.toDate()) : "",
                          //article.author,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(width: 10.0),
                        CircleAvatar(
                            radius: 5.0, backgroundColor: Colors.grey[400]),
                        SizedBox(width: 10.0),
                        Text(
                          article.category,
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
