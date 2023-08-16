import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meus_estudos_app/models/user_model.dart';

class AddNoteTab extends StatefulWidget {
  @override
  _AddNoteTabState createState() => _AddNoteTabState();
}

class _AddNoteTabState extends State<AddNoteTab> {
  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();

  String _titleError;
  String _descriptionError;

  bool _isLoading = false;
  File _imgFile;
  String _url;

  void _clear() {
    setState(() {
      this._imgFile = null;
      this._title.text = "";
      this._description.text = "";
      this._url = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _sizeScreen = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Color(0xC4E57373),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(26),
          topLeft: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
                size: _sizeScreen * 0.04,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _title,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                errorText: this._titleError,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: "Título da Anotação:",
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _description,
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(
                errorText: this._descriptionError,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: "Descrição:",
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 6.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                this._imgFile == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.camera,
                              color: Colors.white,
                              size: _sizeScreen * 0.04,
                            ),
                            onPressed: () async {
                              var img = await ImagePicker.pickImage(
                                  source: ImageSource.camera);
                              if (img != null) {
                                setState(() {
                                  this._imgFile = img;
                                });
                              }
                              return this._imgFile;
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.photo_on_rectangle,
                              color: Colors.white,
                              size: _sizeScreen * 0.04,
                            ),
                            onPressed: () async {
                              var img = await ImagePicker.pickImage(
                                  source: ImageSource.gallery);
                              if (img != null) {
                                setState(() {
                                  this._imgFile = img;
                                });
                              }
                              return this._imgFile;
                            },
                          ),
                        ],
                      )
                    : Container(
                        width: _sizeScreen * 0.06,
                        height: _sizeScreen * 0.06,
                        child: Image.file(
                          this._imgFile,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 6.0,
                  ),
                  width: _sizeScreen * 0.34,
                  height: _sizeScreen * 0.06,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (this._title.text.isNotEmpty &&
                            this._description.text.isNotEmpty) {
                          if (this._imgFile == null) {
                            setState(() {
                              this._isLoading = true;
                            });
                            Map<String, dynamic> data = {
                              "title": this._title.text,
                              "description": this._description.text,
                              "photo": null,
                            };
                            User.of(context).sendNote(data: data);
                            setState(() {
                              this._isLoading = false;
                            });
                            this._clear();
                          } else {
                            setState(() {
                              this._isLoading = true;
                            });
                            StorageUploadTask task = FirebaseStorage.instance
                                .ref()
                                .child(DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString())
                                .putFile(this._imgFile);

                            StorageTaskSnapshot taskSnapshot =
                                await task.onComplete;
                            String url =
                                await taskSnapshot.ref.getDownloadURL();

                            setState(() {
                              _url = url;
                            });

                            Map<String, dynamic> data = {
                              "title": this._title.text,
                              "description": this._description.text,
                              "photo": _url,
                            };
                            User.of(context).sendNote(data: data);
                          }
                          setState(() {
                            this._isLoading = false;
                          });
                          this._clear();
                        } else if (_title.text.isEmpty) {
                          setState(() {
                            _titleError = "Preencha este campo!";
                          });
                        } else if (_description.text.isEmpty) {
                          setState(() {
                            _descriptionError = "Preencha este campo!";
                          });
                        } else {
                          setState(() {
                            _descriptionError = "Preencha este campo!";
                            _titleError = "Preencha este campo!";
                          });
                        }
                      },
                      style: ButtonStyle(
                          animationDuration: Duration(milliseconds: 500),
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xFF00E5FF),
                          )),
                      child: !this._isLoading
                          ? Text(
                              "ADICIONAR",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
