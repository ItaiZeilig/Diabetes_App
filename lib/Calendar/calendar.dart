import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  CalendarController _calendarController;

  /// Color of event markers placed on the bottom of every day containing events.
  Color markersColor;

  /// General `Alignment` for event markers.
  /// NOTE: `markersPositionBottom` defaults to `5.0`, so you might want to set it to `null` when using `markersAlignment`.
  Alignment markersAlignment;

  /// `bottom` property of `Positioned` widget used for event markers.
  /// NOTE: This defaults to `5.0`, so you might occasionally want to set it to `null`.
  double markersPositionBottom;

  /// Maximum amount of event markers to be displayed.
  int markersMaxAmount;

  //List<DateTime> markedDates;


  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    this.markersColor = Color(0xFF263238); // Material blueGrey[900]
    this.markersAlignment = Alignment.bottomCenter;
    this.markersPositionBottom = 5.0;
    this.markersMaxAmount = 4;
  }


@override
 void dispose() {
   _calendarController.dispose();
   super.dispose();
 }



static DateTime toMidnight(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

static bool isToday(DateTime date) {
    var now = DateTime.now();
    return date.day == now.day && date.month == now.month && date.year == now.year;
  }

static bool isPastDay(DateTime date) {
    var today = toMidnight(DateTime.now());
    return date.isBefore(today);
  }

static bool isSpecialPastDay(DateTime date) {
    return isPastDay(date) || (isToday(date) && DateTime.now().hour >= 12);
  }  

DateTime getDateOnly(DateTime dateTimeObj) {
    return DateTime(dateTimeObj.year, dateTimeObj.month, dateTimeObj.day);
  }



// onDateTap(date) {
//     //if (!doesDateRangeExists) {
//       setState(() {
//         selectedDate = date;
//         widget.onDateSelected(date);
//       });
//     } else if (!isDateBefore(date, widget.startDate) &&
//         !isDateAfter(date, widget.endDate)) {
//       setState(() {
//         selectedDate = date;
//         widget.onDateSelected(date);
//       });
//     } else {}
//   }




// bool isDateMarked(date) {
//     date = getDateOnly(date);
//     bool _isDateMarked = false;
//     if (widget.markedDates != null) {
//       widget.markedDates.forEach((DateTime eachMarkedDate) {
//         if (getDateOnly(eachMarkedDate) == date) {
//           _isDateMarked = true;
//         }
//       });
//     }
//     return _isDateMarked;
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SingleChildScrollView(
         //controller: controller,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             TableCalendar(
               //events: _events,
                initialCalendarFormat: CalendarFormat.twoWeeks,
                
                calendarStyle: CalendarStyle(
                    todayColor: Theme.of(context).primaryColor,
                    selectedColor: Color(0xFF86E3CE),
                    todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                calendarController: _calendarController,
              ),
           ],
         ),
       ),
    );
  }
}