import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.decal,
                colors: [
                  //Colors.deepPurple,
                  //Colors.yellow[600],
                  Color(0xFFe57373),
                  Color(0xFF00E5FF),
                ],
              ),
            ),
          ),
          Center(
              child: !User.of(context).isLoading
                  // ignore: deprecated_member_use
                  ? OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () async {
                        await user.signIn();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      borderSide: BorderSide(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Image(
                                image: AssetImage("assets/googlelogo.png"),
                                height: 35.0),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ))
        ],
      ),
    );
  }
}
