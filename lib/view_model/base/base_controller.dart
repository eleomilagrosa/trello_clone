import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:trello_clone/view_model/base/app_controller.dart';

abstract class BaseController extends ChangeNotifier{
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;
  final AppController appController;

  BaseController(this.appController):
    fireStore = FirebaseFirestore.instance,
    auth = FirebaseAuth.instance;
}