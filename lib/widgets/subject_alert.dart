import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';

class HomeAlert extends StatefulWidget {
  final String day;
  HomeAlert({this.day});

  @override
  _HomeAlertState createState() => _HomeAlertState();
}

class _HomeAlertState extends State<HomeAlert> {
  List<String> subjects = [
    'Matemática',
    'Física',
    'Biologia',
    'Química',
    'História',
    'Geografia',
    'Sociologia',
    'Filosofia',
    'Literatura',
    'Português',
    'Inglês',
    'Redação',
  ];

  List<String> options = [
    'Exercícios',
    'Teoria/Aula',
    'Teoria e Exercícios',
  ];

  String subjectValue;
  String optionValue;

  String _errorText;

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _finalTime = TimeOfDay.now();

  final user = User();

  @override
  void initState() {
    super.initState();

    print(User.of(context).myUser.uid);
  }

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
            } else if (subjectValue == null && optionValue == null ||
                subjectValue == null ||
                optionValue == null) {
              setState(() {
                _errorText = "Preencha todos os campos!";
              });
            } else {
              Map<String, dynamic> data = {
                'matéria': subjectValue,
                'estudo': optionValue,
                'começo': _startTime.format(context),
                'final': _finalTime.format(context),
              };

              //print(widget.day);

              await user
                  .sendSubject(
                      dayOfWeek: widget.day,
                      data: data,
                      uid: User.of(context).myUser.uid)
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
        'Adicionar nova tarefa para ${widget.day}:',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color(0xFF00E5FF).withAlpha(200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton(
                dropdownColor: Color(0xFF00E5FF),
                isExpanded: true,
                style: TextStyle(color: Colors.white),
                value: subjectValue,
                onChanged: (value) {
                  setState(() {
                    this.subjectValue = value;
                  });
                  print(subjectValue);
                },
                hint: Text(
                  subjectValue == null ? "Escolha uma matéria" : subjectValue,
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                items: subjects
                    .map(
                      (String sub) => DropdownMenuItem(
                        value: sub,
                        child: Text(sub),
                      ),
                    )
                    .toList()),
            DropdownButton<String>(
                dropdownColor: Color(0xFF00E5FF),
                isExpanded: true,
                style: TextStyle(color: Colors.white),
                value: optionValue,
                onChanged: (String newV) {
                  setState(() {
                    this.optionValue = newV;
                  });
                  print(optionValue);
                },
                hint: Text(
                  optionValue == null ? "Escolha uma opção" : optionValue,
                  style: TextStyle(color: Colors.white),
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                items: options
                    .map(
                      (String opt) => DropdownMenuItem<String>(
                        value: opt,
                        child: Text(opt),
                      ),
                    )
                    .toList()),
            Row(
              //mainAxisSize: MainAxisSize.min,
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
            SizedBox(
              height: 8,
            ),
            _errorText != null
                ? Container(
                    margin: EdgeInsets.all(6),
                    alignment: Alignment.center,
                    child: Text(
                      _errorText,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
