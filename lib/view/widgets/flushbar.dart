import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/view/widgets/custom_pop_up.dart';

class CustomPopUp{
  static String showError(BuildContext context, String message){
    FlushbarHelper.createError(message: message).show(context);
    return message;
  }
  static String showErrorDialog({required BuildContext context,required String message,required String btnLabel}){
    showDialog(
        context: context,
        builder: (alertContext) {
          return CustomAlertDialog(message,
            buttonNegative: ButtonBuilder( btnLabel, () {
              Navigator.pop(alertContext);
            }),
          );
        }
    );
    return message;
  }
  static String showSuccessMessage(BuildContext context, String message, [String? title]){
    FlushbarHelper.createSuccess(title: title,message: message).show(context);
    return message;
  }
}