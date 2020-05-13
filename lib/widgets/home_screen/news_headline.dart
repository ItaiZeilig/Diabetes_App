import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SingleNewsHeadline extends StatelessWidget {
  final String _topic;
  final Timestamp _time;
  final double _rate;
  final String _image;

  SingleNewsHeadline(this._topic, this._time, this._rate, this._image);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(
              width: 100,
              image: NetworkImage(
                  "https://p7.hiclipart.com/preview/14/65/239/ico-avatar-scalable-vector-graphics-icon-doctor-with-stethoscope.jpg"),
            ),
            Column(
              children: <Widget>[
                Text(
                  _topic,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                    Text(_time.toDate().hour.toString() + " hours ago "),
                    Container(
                      color: Colors.black45,
                      height: 20,
                      width: 2,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.yellow,
                    ),
                    Text(
                      _rate.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
