import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meus_estudos_app/models/day_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class User extends Model {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseUser myUser;
  bool isLoading = false;

  List<DayModel> subjects = [];
  List<DocumentSnapshot> events = [];

  String dayOfWeek;

  String calendarOption;
  CalendarView _calendarViewSchedule = CalendarView.schedule;
  CalendarView _calendarViewMonth = CalendarView.month;
  CalendarView _calendarViewWeek = CalendarView.workWeek;
  CalendarView _calendarViewDay = CalendarView.timelineDay;
  CalendarView myCalendarView;

  static User of(BuildContext context) => ScopedModel.of<User>(context);

  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      this.getUser(user);
      getEvents();
      getCalendarOption();
    });
  }

  Future signIn() async {
    try {
      isLoading = true;

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final currentUser = authResult.user;

      this.getUser(currentUser);

      isLoading = false;
      notifyListeners();
    } catch (error) {
      isLoading = false;
      notifyListeners();
      print(error.toString());
      return null;
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
  }

  bool isLoggedIn() {
    if (myUser != null)
      return true;
    else
      return false;
  }

  Future<Null> sendSubject(
      {@required String dayOfWeek,
      @required Map<String, dynamic> data,
      @required String uid}) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .collection(dayOfWeek)
        .add(data);
  }

  Future<Null> removeSubject(
      {@required String day,
      @required String sid,
      @required DayModel daymodel}) async {
    await Firestore.instance
        .collection('users')
        .document(this.myUser.uid)
        .collection(day)
        .document(sid)
        .delete();
    subjects.remove(daymodel);
    notifyListeners();
  }

  Future<Null> sendNote({@required Map<String, dynamic> data}) async {
    await Firestore.instance
        .collection('users')
        .document(this.myUser.uid)
        .collection('notes')
        .add(data);
  }

  Future<Null> deleteNote({@required String nid}) async {
    await Firestore.instance
        .collection('users')
        .document(this.myUser.uid)
        .collection('notes')
        .document(nid)
        .delete();
    notifyListeners();
  }

  Future<Null> updateNote(
      {@required Map<String, dynamic> newNote, @required String nid}) async {
    await Firestore.instance
        .collection('users')
        .document(this.myUser.uid)
        .collection('notes')
        .document(nid)
        .updateData(newNote);
    notifyListeners();
  }

  Future<List<DocumentSnapshot>> getEvents({String uid}) async {
    final eventsList = await Firestore.instance
        .collection('users')
        .document(myUser.uid)
        .collection('eventos')
        .getDocuments();

    this.events = eventsList.documents;
    notifyListeners();
    return this.events;
  }

  Future<List<DocumentSnapshot>> removeEvent({DocumentSnapshot event}) async {
    await Firestore.instance
        .collection('users')
        .document(this.myUser.uid)
        .collection('eventos')
        .document(event.documentID)
        .delete()
        .then((_) {
      this.events.remove(event);
    });
    notifyListeners();
    return events;
  }

  FirebaseUser getUser(FirebaseUser thisUser) {
    myUser = thisUser;
    return myUser;
  }

  getDay(String day) {
    this.dayOfWeek = day;
    return this.dayOfWeek;
  }

  getCalendarOption() async {
    await Firestore.instance
        .collection('users')
        .document(this.myUser.uid)
        .collection('calendar')
        .document('option')
        .get()
        .then((user) {
      if (user.data['option'] == "Schedule") {
        this.myCalendarView = this._calendarViewSchedule;
        notifyListeners();
      } else if (user.data['option'] == "Month") {
        this.myCalendarView = this._calendarViewMonth;
        notifyListeners();
      } else if (user.data['option'] == "Week") {
        this.myCalendarView = this._calendarViewWeek;
        notifyListeners();
      } else if (user.data['option'] == "Day") {
        this.myCalendarView = this._calendarViewDay;
        notifyListeners();
      }
    });
  }

  changeCalendar(String option) async {
    Map<String, dynamic> data = {
      "option": option,
    };

    await Firestore.instance
        .collection('users')
        .document(this.myUser.uid)
        .collection('calendar')
        .document('option')
        .updateData(data)
        .then((_) {
      this.getCalendarOption();
      notifyListeners();
    });
  }
}
