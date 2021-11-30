import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:trello_clone/constants/colors.dart';
import 'package:trello_clone/constants/error_codes.dart';
import 'package:trello_clone/constants/font_style.dart';
import 'package:trello_clone/view_model/auth_view_model.dart';
import 'package:trello_clone/view/widgets/custom_fields.dart';
import 'package:trello_clone/view/widgets/custom_pop_up.dart';
import 'package:validators/validators.dart';

class RegistrationScreen extends StatefulWidget {
  final AuthViewModel authController;
  const RegistrationScreen(this.authController,{Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final TextEditingController _etUsername = TextEditingController();
  final TextEditingController _etPasswordController = TextEditingController();
  final TextEditingController _etConfirmPasswordController = TextEditingController();

  bool _isCreatePasswordHidden = true;
  final _formKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  String? _errorMessage;

  final _pFocus = FocusNode();
  final _cpFocus = FocusNode();

  AuthViewModel get authController => widget.authController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<bool>(
                  stream: createLoginEmailWithPasswordEvent.stream,
                  builder: (context, snapshot) {
                    bool isLoading = snapshot.hasData ? (snapshot.data!) : false;
                    return Form(
                      key: _formKey,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                key: const Key("register-email-field"),
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  labelStyle: AppFontStyle.font18,
                                  errorStyle: AppFontStyle.errorTextStyle,
                                  errorText: _errorMessage,
                                ),
                                enabled: !isLoading,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(_cpFocus);
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
                                  if(!isEmail(username)){
                                    return "This email address is invalid";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                key: const Key("register-password-field"),
                                focusNode: _pFocus,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: AppFontStyle.font18,
                                  errorStyle: AppFontStyle.errorTextStyle,
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
                                      )),
                                ),
                                enabled: !isLoading,
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(_cpFocus);
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
                                  if(password != null){
                                    if(password.isEmpty){
                                      return "Field Required";
                                    }

                                    int minCaps = 1;
                                    int minLength = 5;
                                    int minNumbers = 1;
                                    int minSpecial = 1;

                                    int numCaps = password.split("").where((it) => isUppercase(it) && isAlpha(it)).length;
                                    int numLength = password.length;
                                    int numNumbers = password.split("").where((it) => isNumeric(it)).length;
                                    int numSpecial = password.split("").where((it) => !isAlphanumeric(it)).length;

                                    List<String> errors = [];

                                    if(minCaps > numCaps){
                                      errors.add("* A minimum of $minCaps capital letters are required for passwords");
                                    }
                                    if(minLength > numLength){
                                      errors.add("* A minimum of $minLength length are required for passwords");
                                    }
                                    if(minNumbers > numNumbers){
                                      errors.add("* A minimum of $minNumbers numbers are required for passwords");
                                    }
                                    if(minSpecial > numSpecial){
                                      errors.add("* A minimum of $minSpecial special characters are required for passwords");
                                    }

                                    if(errors.isNotEmpty){
                                      return errors.join("\n");
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                key: const Key("register-cpassword-field"),
                                focusNode: _cpFocus,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  labelStyle: AppFontStyle.font18,
                                  errorStyle: AppFontStyle.errorTextStyle,
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
                                      )),
                                ),
                                enabled: !isLoading,
                                onFieldSubmitted: (String password) async {
                                  await submitCreateAccountWithPassword(isLoading);
                                },
                                obscureText: _isCreatePasswordHidden,
                                controller: _etConfirmPasswordController,
                                style: AppFontStyle.font20,
                                maxLines: 1,
                                autovalidateMode: _isAutoValidate
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                validator: (password) {
                                  if (_etConfirmPasswordController.text != _etPasswordController.text) {
                                    return "Password and Confirm Password does not match";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                key: const Key("create-account"),
                                height: 45,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 30,bottom: 30,),
                                child: CustomButton.buildLoadingButton( "Create Account",
                                  isLoading: isLoading,
                                  onPressed: () async {
                                    await submitCreateAccountWithPassword(isLoading);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
                _backButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _backButton(){
    return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text("Back",
              style: AppFontStyle.font16.copyWith(
                decoration: TextDecoration.underline,
              )),
        ));
  }


  Future<void> submitCreateAccountWithPassword(bool isLoading) async {
    _isAutoValidate = true;
    if(_formKey.currentState?.validate() ?? false){
      if (!isLoading) {
        await attemptCreateAccountWithPassword(
            _etUsername.text,
            _etPasswordController.text,
            _etConfirmPasswordController.text);
        if (_errorMessage != null && _errorMessage!.isEmpty) _errorMessage = null;
      }
    }
    setState(() {});
  }

  BehaviorSubject<bool> createLoginEmailWithPasswordEvent = BehaviorSubject();
  Future attemptCreateAccountWithPassword(String email, String password, String confirmPassword) async {
    FocusScope.of(context).unfocus();

    createLoginEmailWithPasswordEvent.add(true);
    return await authController.attemptCreateAccountWithPassword(email, password)
        .then((isCreateAccount) {
          createAccountSuccess();
          _errorMessage = "";
      return;
    }).catchError((error, trace) {
      // print([error,trace]);
      if (error == ErrorCodes.email_already_in_use) {
        _errorMessage = "Email is already in use, Please use another email";
      } else if (error == ErrorCodes.invalid_email) {
        _errorMessage = "Invalid email, Please use another email";
      } else {
        _errorMessage = "Error occurred, Please try Again";
      }
      return;
    }).whenComplete((){
      createLoginEmailWithPasswordEvent.add(false);
    });
  }

  void createAccountSuccess()async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: CustomAlertDialog(
              "Create Account Success",
              buttonPositive: ButtonBuilder("Close", () {
                Navigator.of(context).pop(true);
              }),
            ),
          );
        }
      );
    Navigator.pop(context);
  }

}
