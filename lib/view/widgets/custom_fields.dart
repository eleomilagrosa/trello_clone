import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:trello_clone/constants/colors.dart';
import 'package:trello_clone/constants/font_style.dart';

class CustomButton{
  static Widget buildLoadingButton(String label ,{bool isLoading = false,Function? onPressed,Color btnColor = AppColors.colorPrimary,Color textColor = Colors.white}){
    return ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(label,style: AppFontStyle.font18Bold.copyWith(
            color: textColor
        )),
        ButtonState.loading: Text("Loading",style: AppFontStyle.font18Bold.copyWith(
            color: textColor
        )),
        ButtonState.fail: Text(label,style: AppFontStyle.font18Bold.copyWith(
            color: textColor
        )),
        ButtonState.success: Text(label,style: AppFontStyle.font18Bold.copyWith(
            color: textColor
        )),
      },
      stateColors: {
        ButtonState.idle: btnColor,
        ButtonState.loading: btnColor,
        ButtonState.fail: btnColor,
        ButtonState.success: btnColor,
      },
      padding: EdgeInsets.all(kIsWeb ? 12 : 8),
      radius: isLoading ? 100.0 : 5.0,
      onPressed: onPressed ?? (){},
      state: isLoading ? ButtonState.loading : ButtonState.idle,
      progressIndicatorSize: 30.0,
    );
  }
}