import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/day_model.dart';
import 'package:meus_estudos_app/models/user_model.dart';
import 'package:meus_estudos_app/tiles/home_tile.dart';
import 'package:meus_estudos_app/widgets/subject_alert.dart';
import 'package:meus_estudos_app/widgets/task_alert.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeTab({this.scaffoldKey});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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

  @override
  void initState({BuildContext context}) {
    super.initState();
    _initializeEventColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              child: HomeTile(
                day: "Segunda",
                scaffoldKey: this.widget.scaffoldKey,
              ),
            ),
            Container(
              child: HomeTile(
                day: "Terça",
                scaffoldKey: this.widget.scaffoldKey,
              ),
            ),
            Container(
              child: HomeTile(
                day: "Quarta",
                scaffoldKey: this.widget.scaffoldKey,
              ),
            ),
            Container(
              child: HomeTile(
                day: "Quinta",
                scaffoldKey: this.widget.scaffoldKey,
              ),
            ),
            Container(
              child: HomeTile(
                day: "Sexta",
                scaffoldKey: this.widget.scaffoldKey,
              ),
            ),
            Container(
              child: HomeTile(
                day: "Sábado",
                scaffoldKey: this.widget.scaffoldKey,
              ),
            ),
            Container(
              child: HomeTile(
                day: "Domingo",
                scaffoldKey: this.widget.scaffoldKey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTile extends StatefulWidget {
  final String day;
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeTile({this.day, this.scaffoldKey});

  @override
  _HomeTileState createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(builder: (context, snapshot, model) {
      if (model.isLoading)
        return Center();
      else
        return Column(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => HomeAlert(
                    day: widget.day,
                  ),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => TaskAlert(
                    day: widget.day,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.3,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.day,
                  style: TextStyle(
                    color: Color(0xFFe57373),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.66,
              width: MediaQuery.of(context).size.width * 0.3,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(User.of(context).myUser.uid)
                    .collection(this.widget.day)
                    .orderBy('começo')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  } else {
                    return SubjectWidget(
                      snapshot: snapshot.data.documents,
                      day: this.widget.day,
                    );
                  }
                },
              ),
            ),
          ],
        );
    });
  }
}

class SubjectWidget extends StatefulWidget {
  final List<DocumentSnapshot> snapshot;
  final String day;
  SubjectWidget({this.snapshot, this.day});

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  List<Color> _colorCollection;
  final random = Random();

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
    _colorCollection.add(const Color(0xFF6E800A));
    _colorCollection.add(const Color(0xFF805B0A));
    _colorCollection.add(const Color(0xFFE4490B));
    _colorCollection.add(const Color(0xFF800A70));
    _colorCollection.add(const Color(0xFFFF00DD));
    _colorCollection.add(const Color(0xFFFF004C));
  }

  @override
  void initState() {
    super.initState();
    _initializeEventColor();
    /*
    User.of(context).createSubjects(
      day: this.widget.day,
      color: _colorCollection[random.nextInt(9)],
      subDocs: this.widget.snapshot,
    );
    */
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        // semanticChildCount: User.of(context).subjects.length,
        // shrinkWrap: true,
        children: this.widget.snapshot.map((sub) {
      final dayModel = DayModel(); 

      dayModel.dayOfWeek = this.widget.day;
      dayModel.materia = sub.data['matéria'];
      dayModel.opcao = sub.data['estudo'];
      dayModel.comeco = sub.data['começo']  ;
      dayModel.fim = sub.data['final'];
      dayModel.color = _colorCollection[random.nextInt(16)];

      return HomeWidget(
        sid: sub.documentID,
        dayModel: dayModel,
        dayOfWeek: this.widget.day,
        // scaffoldKey: this.widget.scaffoldKey,
      );
    }).toList());
  }
}
