import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';
import 'package:meus_estudos_app/tabs/add_note_tab.dart';
import 'package:meus_estudos_app/tiles/note_tile.dart';

class NotesTab extends StatefulWidget {
  final bool isShowed;

  NotesTab({this.isShowed = false});

  @override
  _NotesTabState createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        body:  Stack(
          fit: StackFit.expand,
            children: [
              Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("users")
                      .document(User.of(context).myUser.uid)
                      .collection('notes')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.lightBlueAccent),
                        ),
                      );
                    else if (snapshot.data.documents.isEmpty)
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  CupertinoIcons.doc_text_viewfinder,
                                  size: 70,
                                  color: Color(0xC4E57373),
                                )),
                          )
                        ],
                      );
                    else
                      return ListView(
                        padding: EdgeInsets.all(6),
                        children: snapshot.data.documents
                            .map((note) => NoteTile(
                                  note: note,
                                ))
                            .toList(),
                      );
                  },
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.06,
                        minChildSize: 0.06,
                        maxChildSize: 0.47,
                        builder: (context, scrollController) {
                          return Container(
                              child: SingleChildScrollView(
                            controller: scrollController,
                            child: AddNoteTab(),
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
