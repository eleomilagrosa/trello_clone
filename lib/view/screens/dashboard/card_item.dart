import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/model/models/card_data.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trello_clone/view/widgets/custom_pop_up.dart';
import 'package:trello_clone/view_model/dashboard_view_model.dart';

class CardItemWidget extends StatelessWidget {
  final String cardListId;
  final CardData item;
  late DashboardViewModel dashboardViewModel;
  CardItemWidget(this.cardListId,this.item,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dashboardViewModel = Provider.of<DashboardViewModel>(context);
    return Container(
      color: Colors.white,
      child: ListTile(
        tileColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Text(item.title),
        subtitle: Text("${item.description}\n${timeago.format(item.created_at)}"),
        trailing: IconButton(
          onPressed: (){
            _deleteCardItem(context,cardListId,item);
          },
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }


  _deleteCardItem(context,String cardListId,CardData card)async{
    await showDialog(
        context: context,
        builder: (alertContext) {
          return CustomAlertDialog("Are you sure you want to delete this Card Item?",
            buttonPositive: ButtonBuilder( "Delete", () {
              Navigator.pop(alertContext);
              dashboardViewModel.deleteCard(cardListId,card);
            },textColor: Colors.white,bgColor: Colors.red),
            buttonNegative: ButtonBuilder( "Close", () {
              Navigator.pop(alertContext);
            }),
          );
        }
    );
  }
}
