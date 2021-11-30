import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trello_clone/constants/apptheme.dart';
import 'package:trello_clone/constants/font_style.dart';

class CustomAlertDialog extends StatelessWidget {

  final ButtonBuilder? buttonPositive;
  final ButtonBuilder? buttonNegative;
  final ButtonBuilder? buttonNeutral;
  final String title;
  final Widget? customContent;
  CustomAlertDialog(this.title,{this.buttonPositive,this.buttonNegative,this.buttonNeutral,this.customContent});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: buildBody(),
    );
  }

  Widget buildBody(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          const SizedBox(height: 20),
          Text(title,textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          if(customContent != null) customContent!,
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: buttonNeutral == null ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (buttonNeutral == null) ? Container() : generateButton(buttonNeutral!),
                  (buttonNegative == null) ? Container() : generateButton(buttonNegative!),
                  (buttonPositive == null) ? Container() : generateButton(buttonPositive!),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget generateButton(ButtonBuilder button){
    return Card(
      elevation: 4,
      color: button.bgColor,
      child: InkWell(
        onTap: (){
          button.onTap();
        },
        child: Container(
          constraints: BoxConstraints(minWidth: 70),
          padding: EdgeInsets.symmetric(horizontal: 4),
          height: 38,
          child: Center(
              child: Text(button.title,
                  style: TextStyle(color: button.textColor,fontSize: 16)
              )
          ),
        ),
      ),
    );
  }
}

class ButtonBuilder{
  final String title;
  final Function() onTap;
  final Color bgColor;
//  AppColors.primaryColor
  final Color textColor;

  ButtonBuilder(this.title,this.onTap, {
    this.bgColor = Colors.white,
    this.textColor = Colors.black
  });

}