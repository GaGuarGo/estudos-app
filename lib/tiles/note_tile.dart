import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';
import 'package:meus_estudos_app/widgets/edit_note_widget.dart';

class NoteTile extends StatefulWidget {
  final DocumentSnapshot note;

  NoteTile({this.note});

  @override
  _NoteTileState createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {

  @override
  Widget build(BuildContext context) {
    double _sizeHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      padding: EdgeInsets.only(bottom: 20.0),
      child: Card(
        elevation: 20.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              //alignment: Alignment.centerRight,
              height: _sizeHeight * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //SizedBox(width: 1,),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      this.widget.note.data['title'],
                      style: TextStyle(
                        fontSize: _sizeHeight * 0.028,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  widget.note.data['photo'] != null
                      ? PopupMenuButton<String>(
                          onSelected: (String option) {
                            if (option == 'vp') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: Text(
                                    "Photo:",
                                  ),
                                  content: Container(
                                    child: this.widget.note.data['photo'] != ''
                                        ? Image.network(
                                            this.widget.note.data['photo'],
                                            fit: BoxFit.contain,
                                            filterQuality: FilterQuality.high,
                                          )
                                        : Center(
                                            child: Text("No Photo!"),
                                          ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Close",
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ],
                                ),
                              );
                            } else if (option == 'delete') {
                              User.of(context)
                                  .deleteNote(nid: this.widget.note.documentID);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => EditNote(
                                        nid: this.widget.note.documentID,
                                      ));
                            }
                          },
                          itemBuilder: (context) => [
                            new PopupMenuItem<String>(
                              child: Text('View Photo'),
                              value: "vp",
                            ),
                            new PopupMenuItem<String>(
                              child: Text('Delete'),
                              value: "delete",
                            ),
                            new PopupMenuItem<String>(
                              child: Text('Edit'),
                              value: "edit",
                            ),
                          ],
                        )
                      : Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(CupertinoIcons.pen),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => EditNote(
                                            nid: this.widget.note.documentID,
                                          ));
                                },
                              ),
                              IconButton(
                                icon: Icon(CupertinoIcons.delete),
                                onPressed: () {
                                  User.of(context).deleteNote(
                                      nid: this.widget.note.documentID);
                                },
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
              child: Container(
                child: Text(
                    this.widget.note.data['description'],
                    style: TextStyle(
                      fontSize: _sizeHeight * 0.024,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
