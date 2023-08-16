import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';

class SubjectAlert extends StatefulWidget {
  @override
  _SubjectAlertState createState() => _SubjectAlertState();
}

class _SubjectAlertState extends State<SubjectAlert> {
  final _titleController = new TextEditingController();

  DateTime _timePicked;
  String _errorText = '';

  TimeOfDay _initialTime = TimeOfDay.now();
  TimeOfDay _finalTime = TimeOfDay.now();

  bool _isLoading = false;

  Future<Null> _getInitialTime() async {
    final TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: _initialTime,
    );
    if (selectedTime != null) {
      setState(() {
        _initialTime = selectedTime;
      });
      print(_initialTime.format(context));
    }
  }

  Future<Null> _getFinalTime() async {
    final TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: _finalTime,
    );
    if (selectedTime != null) {
      setState(() {
        _finalTime = selectedTime;
      });
      print(_finalTime.format(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Criar novo Evento:",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (_timePicked != null &&
                _titleController.text.trim() != null &&
                _initialTime != null &&
                _finalTime != null) {
              setState(() {
                this._isLoading = true;
              });

              Map<String, dynamic> event = {
                'eventName': _titleController.text,
                'from': _timePicked.add(Duration(hours: _initialTime.hour)),
                'to': _timePicked.add(Duration(hours: _finalTime.hour)),
              };

              await Firestore.instance
                  .collection('users')
                  .document(User.of(context).myUser.uid)
                  .collection('eventos')
                  .add(event);
              // ignore: invalid_use_of_protected_member

              Navigator.of(context).pop();
              User.of(context).addListener(() {
                User.of(context).getEvents();
              });

              setState(() {
                this._isLoading = false;
              });
            } else {
              setState(() {
                _errorText = 'Preencha todos os campos!';
              });
            }
          },
          child: Text(
            'Concluido',
            style: TextStyle(
              color: Colors.blueAccent[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      backgroundColor: Color(0xFFe57373),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: !this._isLoading ? Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _timePickerField(
                  time: _initialTime,
                  title: 'Começo',
                  getTime: _getInitialTime,
                ),
                _timePickerField(
                  time: _finalTime,
                  title: 'Final',
                  getTime: _getFinalTime,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            // ignore: missing_required_param
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () async {
                final pickedDay = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)));

                if (pickedDay != null) {
                  setState(() {
                    _timePicked = pickedDay;
                  });
                  return _timePicked;
                } else {}
              },
              color: Colors.white,
              elevation: 16.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.transparent)),
              child: Center(
                child: Text(
                  _timePicked == null
                      ? 'Escolha o dia:'
                      : 'Dia: ${_timePicked.day}/${_timePicked.month}/${_timePicked.year}',
                  style: TextStyle(
                      color: Color(0xFFe57373),
                      fontWeight: FontWeight.normal,
                      fontSize: MediaQuery.of(context).size.width * 0.03),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: TextField(
              controller: _titleController,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'Título do evento',
                labelStyle: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.normal),
              ),
            ),
          ),
          _errorText == ''
              ? Container()
              : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(6),
                  child: Text(
                    '$_errorText',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
        ],
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      )
    );
  }

  Widget _timePickerField({String title, Function getTime, TimeOfDay time}) =>
      Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white),
        ),
        alignment: Alignment.center,
        child: OutlinedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent)))),
          onPressed: getTime,
          child: Text(
            '$title: ${time.format(context)}',
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
        ),
      );
}
