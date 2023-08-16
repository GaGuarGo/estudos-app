import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_estudos_app/models/user_model.dart';
import 'package:meus_estudos_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meus_estudos_app/tabs/events_tab.dart';
import 'package:meus_estudos_app/tabs/home_tab.dart';
import 'package:meus_estudos_app/tabs/notes_tab.dart';
import 'package:meus_estudos_app/tiles/event_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = User();

  int _currentPage = 0;
  final _pageController = PageController();

  GlobalKey bottomNavigationKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isShowed = false;

  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((loggedUser) {
      setState(() {
        user.myUser = loggedUser;
      });
      User.of(context).getUser(loggedUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user.myUser != null)
      return Scaffold(
        key: _scaffoldKey,
        floatingActionButtonLocation: _currentPage == 0
            ? FloatingActionButtonLocation.miniCenterFloat
            : _currentPage == 1
                ? FloatingActionButtonLocation.endFloat
                : FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: this._thisFab(),
        bottomNavigationBar: FancyBottomNavigation(
          key: bottomNavigationKey,
          circleColor: Colors.white,
          textColor: Colors.white,
          activeIconColor: Color(0xFFe57373),
          inactiveIconColor: Colors.white70,
          barBackgroundColor: Color(0xC4E57373),
          tabs: [
            TabData(
              iconData: CupertinoIcons.calendar_circle,
              title: "Cronograma",
              onclick: () {},
            ),
            TabData(
              iconData: Icons.event,
              title: "Eventos",
              onclick: () {},
            ),
            TabData(
              iconData: Icons.sticky_note_2_outlined,
              title: "Anotações",
              onclick: () {},
            ),
          ],
          onTabChangedListener: (int position) {
            setState(() {
              _currentPage = position;
            });
            _pageController.animateToPage(
              position,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInQuint,
            );
          },
          initialSelection: _currentPage,
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFe57373),
                    Color(0xFF00E5FF),
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            user.signOut();
                          },
                          icon: Icon(
                            Icons.exit_to_app_rounded,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                        ),
                        Text(
                          "Cronograma - ${user.myUser.displayName}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: HomeTab(
                    scaffoldKey: this._scaffoldKey,
                  )),
                ],
              ),
            ),
            EventsTab(),
            NotesTab(
              isShowed: this.isShowed,
            ),
          ],
        ),
      );
    else
      return LoginScreen();
  }

  Widget _thisFab() {
    if (this._currentPage == 0 || this._currentPage == 2)
      return Container();
    else
      return FloatingActionButton(
        onPressed: _currentPage == 0
            ? () {
                user.signOut();
              }
            : _currentPage == 1
                ? () {
                    showDialog(
                        context: context, builder: (context) => EventTile());
                  }
                : () {
                    setState(() {
                      isShowed = !isShowed;
                    });
                  },
        backgroundColor: Colors.white,
        tooltip:
            _currentPage == 0 ? "Pressione para sair!" : "Ver meus Eventos!",
        elevation: 20,
        isExtended: true,
        child: Center(
          child: Icon(
            _currentPage == 0
                ? Icons.exit_to_app_rounded
                : _currentPage == 1
                    ? Icons.list_outlined
                    : !this.isShowed
                        ? Icons.add
                        : Icons.clear,
            color: Color(0xFFe57373),
          ),
        ),
      );
  }
}
