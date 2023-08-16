import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/day_model.dart';
import 'package:meus_estudos_app/models/user_model.dart';

class HomeWidget extends StatefulWidget {
  final String sid;
  final DayModel dayModel;
  final String dayOfWeek;
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeWidget({this.dayModel, this.scaffoldKey, this.sid, this.dayOfWeek});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _fontSize = MediaQuery.of(context).size.height * 0.02;
    final _style = TextStyle(
        color: Colors.white, fontSize: _fontSize, fontWeight: FontWeight.w700);
    if (this.widget.dayModel != null &&
        this.widget.dayModel.dayOfWeek == this.widget.dayOfWeek)
      return Dismissible(
        key: Key(this.widget.sid),
        onDismissed: (direction) async {
          final thisDay = widget.dayModel;

          User.of(context).removeSubject(
              day: this.widget.dayModel.dayOfWeek,
              sid: this.widget.sid,
              daymodel: this.widget.dayModel);
          // ignore: deprecated_member_use
          this.widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                margin: EdgeInsets.all(8),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.grey[700],
                content: Text(
                  'Você realmente deseja excluir?',
                  style: TextStyle(
                    color: Color(0xFF634545),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      User.of(context).subjects.add(thisDay);
                    }),
              ));
        },
        direction: DismissDirection.startToEnd,
        background: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.delete_outline_outlined,
                color: Colors.white,
              )
            ],
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: widget.dayModel.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                '${widget.dayModel.materia}',
                textAlign: TextAlign.center,
                style: _style,
              ),
              Text(
                this.widget.dayModel.opcao != ''
                    ? '${widget.dayModel.opcao}'
                    : '',
                style: _style,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${widget.dayModel.comeco}',
                    style: _style,
                  ),
                  Text(
                    '-',
                    style: _style,
                  ),
                  Text(
                    '${widget.dayModel.fim}',
                    style: _style,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    else
      return Container();
  }
}
