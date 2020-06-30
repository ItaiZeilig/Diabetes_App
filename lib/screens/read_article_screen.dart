import 'package:diabetes_app/models/article.dart';
import 'package:flutter/material.dart';

class ReadFullArticle extends StatelessWidget {
  
  final Article article;

  ReadFullArticle({this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Latest News"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 12.0),
              Hero(
                tag: article.title,
                child: Container(
                  height: 220.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(image: NetworkImage(article.image),
                    fit: BoxFit.fill),                    
                  ),
                ),
                ),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey[400], width: 1.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 5.0,
                            backgroundColor: Colors.grey[400],
                          ),
                          SizedBox(width: 6.0),
                          Text(article.category,
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Status(
                      icon: Icons.remove_red_eye,
                      total: article.author,
                    ),
                    SizedBox(width: 15.0),
                    Status(
                      icon:Icons.favorite,
                      total:article.diabetesType.toString(),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Text(
                  article.title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold).copyWith(fontSize: 28.0),
                ),
                SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    Text(article.time.toDate().toString(), style: TextStyle(fontSize: 14.0)),
                    SizedBox(width: 5.0),
                    SizedBox(
                    width: 10.0,
                    child: Divider(
                      color: Colors.black,
                      height: 1.0,
                    ),
                    ),
                    SizedBox(width: 5.0),
                    Text(article.author, style: TextStyle(fontSize: 14.0)),                    
                  ],
                ),
                SizedBox(height: 15.0),
                Text(article.content, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold).copyWith(height: 2.0)),
            ],
          ),
        ),
      ),
    );
  }
}

class Status extends StatelessWidget {

  final IconData icon;
  final String total;

  Status({this.icon, this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color:Colors.grey[400]),
        SizedBox(width: 4.0),
        Text(total, style: TextStyle(fontSize: 14.0))
      ],
    );
  }
}