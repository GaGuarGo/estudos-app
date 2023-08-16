import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/calendar_model.dart';
import 'package:meus_estudos_app/models/user_model.dart';
import 'package:meus_estudos_app/widgets/event_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsTab extends StatefulWidget {
  @override
  _EventsTabState createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  @override
  void initState() {
    super.initState();
    _initializeEventColor();

    User.of(context).getEvents();
    User.of(context).getCalendarOption();
  }

  List<Color> _colorCollection;

  void _initializeEventColor() {
    this._colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  List<Meeting> meetings;
  Map<String, dynamic> eventMap;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(builder: (context, child, model) {
      if (model.isLoading)
        return Center(
          child: CircularProgressIndicator(),
        );
      else
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (String option) {
                    User.of(context).changeCalendar(option);
                  },
                  itemBuilder: (context) => [
                    new PopupMenuItem<String>(
                      child: Text('Schedule View'),
                      value: "Schedule",
                    ),
                    new PopupMenuItem<String>(
                      child: Text('Month View'),
                      value: "Month",
                    ),
                    new PopupMenuItem<String>(
                      child: Text('Week View'),
                      value: "Week",
                    ), new PopupMenuItem<String>(
                      child: Text('Day View'),
                      value: "Day",
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => SubjectAlert());
              },
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  CupertinoIcons.add,
                  color: Color(0xFFe57373),
                ),
              ),
              elevation: 20.0,
            ),
            extendBody: true,
            body: Container(
              child: SfCalendar(
                monthViewSettings: MonthViewSettings(showAgenda: true),
                view: model.myCalendarView,
                dataSource: MeetingDataSource(
                    _getDataSource(events: User.of(context).events)),
              ),
            ));
    });
  }

  List<Meeting> _getDataSource({List<DocumentSnapshot> events}) {
    meetings = <Meeting>[];
    eventMap = {};
    if (events.isNotEmpty) {
      final Random random = new Random();
      events.forEach((doc) {
        DateTime from = doc.data['from'].toDate();
        DateTime to = doc.data['to'].toDate();

        eventMap = {
          'eventName': doc.data['eventName'],
          'from': from,
          'to': to,
          'isAllDay': false,
          'Color': _colorCollection[random.nextInt(9)],
        };

        Meeting eventNow = Meeting(
          eventName: eventMap['eventName'],
          from: eventMap['from'],
          to: eventMap['to'],
          background: eventMap['Color'],
          isAllDay: eventMap['isAllDay'],
        );

        meetings.add(eventNow);
      });

      return meetings;
    } else {
      meetings = <Meeting>[];
      return meetings;
    }
  }
}
