import 'dart:math';

import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/constants/routes.dart';
import 'package:trello_clone/view/screens/dashboard/dashboard_screen.dart';
import 'package:trello_clone/view/screens/login/login_screen.dart';
import 'package:trello_clone/view/screens/login/registration_screen.dart';
import 'package:trello_clone/view_model/auth_view_model.dart';
import 'package:trello_clone/view_model/base/app_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppController>(create: (_) => AppController()),
      ],
      builder: (context, _) =>  MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.LOGIN_PAGE,
          onGenerateRoute: (RouteSettings settings) {
            final arg = settings.arguments;
            switch (settings.name) {
              case Routes.DASHBOARD_PAGE:
                return MaterialPageRoute(builder: (_) => DashboardScreen());
              case Routes.REGISTER_PAGE:
                return MaterialPageRoute(builder: (_) => RegistrationScreen(arg as AuthViewModel));
              case Routes.LOGIN_PAGE:
              default:
                // return MaterialPageRoute(builder: (_) => DashboardScreen());
                return MaterialPageRoute(builder: (_) => LoginScreen());
            }
          }
      ),
    );
  }
}