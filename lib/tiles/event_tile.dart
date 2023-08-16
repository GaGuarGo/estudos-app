import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';

class EventTile extends StatefulWidget {
  @override
  _EventTileState createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFe57373),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Fechar',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      title: Text(
        'Meus Eventos:',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: User.of(context).events.isNotEmpty ? Column(
          mainAxisSize: MainAxisSize.min,
          children: User.of(context).events.isNotEmpty
              ? User.of(context)
                  .events
                  .map((event) => eventWidget(event: event))
                  .toList()
              : [],
        ) : Center(child: Icon(Icons.library_add, color: Colors.white, size: 40),),
      ),
    );
  }

  Widget eventWidget({DocumentSnapshot event}) {
    DateTime time = event.data['from'].toDate();

    return Dismissible(
      background: Container(
        padding: EdgeInsets.only(left: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        User.of(context).removeEvent(event: event);
      },
      key: Key(event.data['eventName']),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          alignment: WrapAlignment.spaceAround,
          children: [
            Text(
              time.day < 10 && time.month < 10
                  ? '${event.data['eventName']} - 0${time.day}/0${time.month}/${time.year}'
                  : '${event.data['eventName']} - ${time.day}/${time.month}/${time.year}',
              style: TextStyle(
                color: Color(0xFFe57373),
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
