import 'package:flutter/material.dart';

class WeekDaysRow extends StatelessWidget {
  WeekDaysRow({
    Key key,
  }) : super(key: key);

  int dayNumber = DateTime.now().weekday;

  Color getDayColor(int dayNum , BuildContext context) {
    if (dayNum > dayNumber) {
      return Colors.grey.shade300;
    } else if (dayNum < dayNumber) {
      return Colors.amber;
    }
    return Theme.of(context).primaryColor;
  }

  Map<int, String> days = {
    1: "Mon",
    2: "Tue",
    3: "Wed",
    4: "Thu",
    5: "Fri",
    6: "Sat",
    0: "Sun",
  };

  BorderRadius getRadiusByDay(int dayOfWeekNum) {
    if (dayOfWeekNum == 0) {
      return BorderRadius.horizontal(left: Radius.circular(20));
    } else if (dayOfWeekNum == 6) {
      return BorderRadius.horizontal(right: Radius.circular(20));
    } else {
      return BorderRadius.circular(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: getDayColor(index , context),
                      borderRadius: getRadiusByDay(index)),
                  child: Text(
                    days[index].toString(),
                    style: TextStyle(fontSize: 15 ,fontWeight: FontWeight.bold),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
