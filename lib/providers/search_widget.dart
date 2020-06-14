import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabetes_app/dailyChallenge/challenge.dart';
import 'package:diabetes_app/screens/hcp_add_new_challenge.dart';
import 'package:diabetes_app/screens/hcp_update_challenge.dart';
import 'package:diabetes_app/services/challenges_service.dart';
import 'package:diabetes_app/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchController = TextEditingController();
  List<Challenge> allChallengesList;
  Challenge challenge = Challenge();
  bool foundChallenge = false;


  @override
  void initState() { 
    super.initState();
  }
   

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

  void _addingNewChallenge() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: AddChallenge(),
          );
        });
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
                
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.notoSans(fontSize: 14.0),
                border: InputBorder.none,
                fillColor: Colors.grey.withOpacity(0.5),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                suffixIcon: IconButton(
                  padding: EdgeInsets.only(right: 20.0),
                  icon: Icon(Icons.close,
                  color: Colors.grey,),
                  onPressed: (){
                    WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                  })
              ),
            ),
          ),
        ),


        ListView.builder(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          shrinkWrap: true,
          itemCount: challenges?.length ?? 0,
          itemBuilder: (context, index) {

            return buildResultCard(context, challenges[index]);
          },
        ),

        // GridView.count(
        //    padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //       crossAxisCount: 2,
        //       crossAxisSpacing: 4.0,
        //       mainAxisSpacing: 4.0,
        //       primary: false,
        //       shrinkWrap: true,
        //       children: tempSearchStore.map((element) {
        //         return buildResultCard(element);
        //       }).toList()
        //   ),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addingNewChallenge(),
        tooltip: 'Add New Challenge',
      ),
    );
  }
}



Widget buildResultCard(BuildContext context, Challenge challenge) {

  void _updateChallengeInfo(String name, String category) {
    showModalBottomSheet(context: context, builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: UpdateChallenge(
                challeName: challenge.name, cateName: challenge.category),
          );
        });
  }

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    elevation: 2.0,
    child: Container(
      
        child: ListTile(
          title: Text(
            challenge.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            tooltip: 'Click For Update',
            color: Colors.black,
            onPressed: () =>
                _updateChallengeInfo(challenge.name, challenge.category),
          ),
        ),
     
    ),
  );
}
