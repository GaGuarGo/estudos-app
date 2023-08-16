import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';

class TaskAlert extends StatefulWidget {
  final String day;
  TaskAlert({this.day});

  @override
  _TaskAlertState createState() => _TaskAlertState();
}

class _TaskAlertState extends State<TaskAlert> {
  final _taskController = TextEditingController();

  String _errorText;

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _finalTime = TimeOfDay.now();

  final user = User();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            if (_startTime == _finalTime || _startTime.hour > _finalTime.hour) {
              setState(() {
                _errorText = "Digite horários coerentes!";
              });
            } else if (_taskController.text.trim().isEmpty) {
              setState(() {
                _errorText = "Preencha Todos os Campos!";
              });
            } else {
              Map<String, dynamic> data = {
                'matéria': _taskController.text,
                'estudo': '',
                'começo': _startTime.format(context),
                'final': _finalTime.format(context),
              };

              await user
                  .sendSubject(
                dayOfWeek: widget.day,
                data: data,
                uid: User.of(context).myUser.uid,
              )
                  .then((_) {
                Navigator.of(context).pop();
              });
            }
          },
          child: Text(
            'Confirmar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      title: Text(
        'Adicionar outra tarefa para ${widget.day}:',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color(0xFF00E5FF).withAlpha(200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Digite aqui',
                  labelStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    final timePicked = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (timePicked != null) {
                      setState(() {
                        _startTime = timePicked;
                      });
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.height * 0.16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      _startTime == TimeOfDay.now()
                          ? 'Começo:'
                          : 'Começo: ${_startTime.format(context)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final timePicked = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (timePicked != null) {
                      setState(() {
                        _finalTime = timePicked;
                      });
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.height * 0.16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Text(
                      _finalTime == TimeOfDay.now()
                          ? 'Fim:'
                          : 'Fim: ${_finalTime.format(context)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _errorText != null
                ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(8),
                    child: Text(
                      _errorText,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
