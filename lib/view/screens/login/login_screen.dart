import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trello_clone/constants/colors.dart';
import 'package:trello_clone/constants/error_codes.dart';
import 'package:trello_clone/constants/font_style.dart';
import 'package:trello_clone/constants/routes.dart';
import 'package:trello_clone/view/widgets/flushbar.dart';
import 'package:trello_clone/view_model/auth_view_model.dart';
import 'package:trello_clone/view_model/base/app_controller.dart';
import 'package:trello_clone/view/widgets/custom_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _etUsername = TextEditingController();
  final TextEditingController _etPasswordController = TextEditingController();

  AuthViewModel? _authController;
  AuthViewModel get authController => _authController!;

  final _formKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  final _pFocus = FocusNode();
  bool _isCreatePasswordHidden = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authController ??= AuthViewModel(Provider.of<AppController>(context));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => authController),
      ],
      builder: (context, _) => Scaffold(

        body: SafeArea(

          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width  * .5,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLoginForm(),
                  _buildCreateAccountButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildLoginForm(){
    return StreamBuilder<bool>(
        stream: loginWithPasswordEvent.stream,
        builder: (context, snapshot) {
          bool isLoading = snapshot.hasData ? (snapshot.data!) : false;
          return Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  TextFormField(
                    key: const Key("login-email-field"),
                    decoration: const InputDecoration(
                        labelText: "Username"
                    ),
                    enabled: !isLoading,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_pFocus);
                    },
                    textInputAction: TextInputAction.next,
                    controller: _etUsername,
                    style: AppFontStyle.font20,
                    maxLines: 1,
                    autovalidateMode: _isAutoValidate
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (username) {
                      if(username == null) return "Field Required";
                      if(username.isEmpty) return "Field Required";
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    key: const Key("login-password-field"),
                    focusNode: _pFocus,
                    decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _isCreatePasswordHidden =
                                !_isCreatePasswordHidden;
                              });
                            },
                            child: Icon(
                              _isCreatePasswordHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.warmGrey,
                            ))
                    ),
                    enabled: !isLoading,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_pFocus);
                    },
                    textInputAction: TextInputAction.next,
                    obscureText: _isCreatePasswordHidden,
                    controller: _etPasswordController,
                    style: AppFontStyle.font20,
                    maxLines: 1,
                    autovalidateMode: _isAutoValidate
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    validator: (password) {
                      if(password == null) return "Field Required";
                      if(password.isEmpty) return "Field Required";
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 30,bottom: 30,),
                    child: CustomButton.buildLoadingButton( "Login",
                      isLoading: isLoading,
                      onPressed: () async {
                        await submit(isLoading);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _buildCreateAccountButton(){
    return InkWell(
        key: const Key("create-account"),
        onTap: () {
          gotoRegistration();
        },
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text("Create Account",
              style: AppFontStyle.font16.copyWith(
                decoration: TextDecoration.underline,
              )),
        ));
  }

  BehaviorSubject<bool> loginWithPasswordEvent = BehaviorSubject();
  Future submit(bool isLoading)async{
    _isAutoValidate = true;
    if(_formKey.currentState?.validate() ?? false) {
      if (!isLoading) {
        loginWithPasswordEvent.add(true);
        authController.attemptLoginWithPassword(_etUsername.text, _etPasswordController.text)
        .then((user){
          gotoDashboard(user);
        })
        .catchError((error,trace){
          if(error == ErrorCodes.wrong_password){
            CustomPopUp.showError(context, "Wrong Password");
          }else if(error == ErrorCodes.user_not_found){
            CustomPopUp.showError(context, "Email not found");
          }
        }).whenComplete((){
          loginWithPasswordEvent.add(false);
        });
      }
    }
    setState((){});
  }

  void gotoDashboard(User? user){
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.DASHBOARD_PAGE, (Route<dynamic> route) => false,
        arguments: user
    );
  }
  void gotoRegistration(){
    Navigator.of(context).pushNamed(Routes.REGISTER_PAGE, arguments: authController);
  }
}
