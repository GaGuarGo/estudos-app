import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';

class EditNote extends StatefulWidget {
  final String nid;

  EditNote({this.nid});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();

  String _errorTitle;
  String _errorDescription;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xC4E57373),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Edit Note:",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: this._formKey,
        child: !this._isLoading
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _title,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          errorText: this._errorTitle,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: "Novo Título:",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: _description,
                        keyboardType: TextInputType.text,
                        maxLines: 3,
                        decoration: InputDecoration(
                          errorText: this._errorDescription,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelText: "Nova descrição:",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
              if (_title.text.isEmpty) {
                setState(() {
                  this._isLoading = true;
                });
                Map<String, dynamic> newNote = {
                  "description": _description.text
                };

                User.of(context)
                    .updateNote(newNote: newNote, nid: this.widget.nid);
                setState(() {
                  this._isLoading = false;
                });
                Navigator.of(context).pop();
              } else if (_description.text.isEmpty) {
                setState(() {
                  this._isLoading = true;
                });
                Map<String, dynamic> newNote = {"title": _title.text};

                User.of(context)
                    .updateNote(newNote: newNote, nid: this.widget.nid);
                setState(() {
                  this._isLoading = false;
                });
                Navigator.of(context).pop();
              } else if(_title.text.isEmpty && _description.text.isEmpty) {
                setState(() {
                  _errorDescription = "Preencha pelo menos um campo!";
                  _errorTitle = "Preencha pelo menos um campo!";
                });
              }

          },
          child: Text(
            'Edit',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}
