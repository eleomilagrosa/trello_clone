import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


// Root Controller - contains themes changes, preference, localization changes, language changes,.. etc
// Any related to Global App Changes
class AppController extends ChangeNotifier{
  final Completer<bool> isInitialized = Completer();

  Future logout()async {
    await FirebaseAuth.instance.signOut();
  }
}