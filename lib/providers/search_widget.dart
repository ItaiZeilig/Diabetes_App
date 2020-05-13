import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';
import 'package:diabetes_app/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var queryResultSet = [];
  var tempSearchStore = [];

  

  void initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
          print(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final challenges = Provider.of<List<Challenge>>(context);

    return Scaffold(
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Search For',
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.w800, fontSize: 27.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Challenge 🏆',
            style: GoogleFonts.notoSans(
                fontWeight: FontWeight.w800, fontSize: 27.0),
          ),
        ),
        SizedBox(height: 25.0),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Container(
            padding: EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                //color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.notoSans(fontSize: 14.0),
                border: InputBorder.none,
                fillColor: Colors.grey.withOpacity(0.5),
                //fillColor: Colors.grey,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        //ChallengeList(),
          
       
        ListView.builder(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),            
            shrinkWrap: true,
            itemCount: challenges?.length ?? 0,
            itemBuilder: (context, index) {
              return buildResultCard(challenges[index]); 
            }, )
       ]),
    );
  }
}

Widget buildResultCard(Challenge challenge) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 2.0,
    child: Container(
      child: ListTile(
        title: Text(challenge.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),
        )
      )
    )
  );
}
