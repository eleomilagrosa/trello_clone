import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_clone/constants/apptheme.dart';
import 'package:trello_clone/constants/colors.dart';
import 'package:trello_clone/constants/font_style.dart';
import 'package:trello_clone/model/models/card_data.dart';
import 'package:trello_clone/model/models/card_list_data.dart';
import 'package:trello_clone/view/screens/dashboard/card_item.dart';
import 'package:trello_clone/view/widgets/custom_pop_up.dart';
import 'package:trello_clone/view_model/base/app_controller.dart';
import 'package:trello_clone/view_model/dashboard_view_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  DashboardViewModel? _dashboardViewModel;
  DashboardViewModel get dashboardViewModel => _dashboardViewModel!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dashboardViewModel ??= DashboardViewModel(Provider.of<AppController>(context));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardViewModel>(create: (_) => dashboardViewModel),
      ],
      child: Scaffold(
        backgroundColor: AppColors.bgBlue,
        appBar: AppBar(
          title: const Text('Trello Clone'),
          actions: [
            InkWell(
              onTap: (){
                _addCardList();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 4,),
                    Text("Add Card list", style: AppFontStyle.font14),
                  ],
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder<List<CardListData>>(
          stream: dashboardViewModel.cardListStream,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Container();
            var list = snapshot.data!;
            return DragAndDropLists(
              children: List.generate(list.length, (index) => _buildList(list[index])),
              onItemReorder: _onItemReorder,
              onListReorder: _onListReorder,
              axis: Axis.horizontal,
              listWidth: 300,
              listDraggingWidth: 250,
              listDecoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black45,
                    spreadRadius: 3.0,
                    blurRadius: 6.0,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              listPadding: const EdgeInsets.all(8.0),
            );
          }
        ),
      ),
    );
  }

  _buildList(CardListData cardListData) {
    return DragAndDropList(
      header: Row(
        children: <Widget>[
          Expanded(
              child: ListTile(
                title: Text('${cardListData.title}',maxLines: 1,overflow: TextOverflow.ellipsis,),
                leading: const Icon(Icons.drag_handle),
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (int selected){
                    if(selected == 1){
                      _deleteCardList(cardListData);
                    }else{
                      _addCardItem(cardListData.id!);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 4,),
                            Text("Add Card", style: AppFontStyle.font14),
                          ],
                        )
                    ),
                    PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(width: 4,),
                            Text("Delete List", style: AppFontStyle.font14),
                          ],
                        )
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.drag_handle),
        ],
      ),
      leftSide: const VerticalDivider(
        color: Colors.pink,
        width: 1.5,
        thickness: 1.5,
      ),
      rightSide: const VerticalDivider(
        color: Colors.pink,
        width: 1.5,
        thickness: 1.5,
      ),
      children: List.generate(dashboardViewModel.cards[cardListData.id]?.length ?? 0,
              (index) => _buildItem(cardListData.id!,dashboardViewModel.cards[cardListData.id]![index]))
    );
  }

  _buildItem(String cardListId,CardData item){
    return DragAndDropItem(
      child: CardItemWidget(cardListId,item),
    );
  }

  _addCardItem(String cardListId)async{
    String inputTitle = "";
    String inputDesc = "";
    await showDialog(
        context: context,
        builder: (alertContext) {
          return CustomAlertDialog("New Card List",
            customContent:
            Column(
              children: [
                TextFormField(
                  style: AppFontStyle.font16,
                  maxLines: 1,
                  minLines: 1,
                  decoration: roundedInputDecoration.copyWith(hintText: "Title"),
                  onChanged: (value){
                    inputTitle = value;
                  },
                ),
                SizedBox(height: 12,),
                TextFormField(
                  style: AppFontStyle.font16,
                  maxLines: 5,
                  minLines: 3,
                  decoration: roundedInputDecoration.copyWith(hintText: "Description"),
                  onChanged: (value){
                    inputDesc = value;
                  },
                )
              ],
            ),
            buttonPositive: ButtonBuilder( "Add", () {
              Navigator.pop(alertContext);
            },bgColor: AppColors.bgBlue,textColor: Colors.white),
            buttonNegative: ButtonBuilder( "Close", () {
              inputTitle = "";
              Navigator.pop(alertContext);
            }),
          );
        }
    );

    if(inputTitle.isNotEmpty){
      var data = CardData(
          parentId: cardListId,
          description: inputDesc,
          index: dashboardViewModel.cardListStream.value.length + 1,
          created_at: DateTime.now(),
          title: inputTitle);

      await dashboardViewModel.addCard(cardListId,data);
    }
  }


  _addCardList()async{
    String inputValue = "";
    await showDialog(
        context: context,
        builder: (alertContext) {
          return CustomAlertDialog("New Card Item",
            customContent:
            TextFormField(
              style: AppFontStyle.font16,
              maxLines: 1,
              minLines: 1,
              decoration: roundedInputDecoration.copyWith(hintText: "Title"),
              onChanged: (value){
                inputValue = value;
              },
            ),
            buttonPositive: ButtonBuilder( "Add", () {
              Navigator.pop(alertContext,inputValue);
            },bgColor: AppColors.bgBlue,textColor: Colors.white),
            buttonNegative: ButtonBuilder( "Close", () {
              inputValue = "";
              Navigator.pop(alertContext);
            }),
          );
        }
    );

    if(inputValue.isNotEmpty){
      var data = CardListData(
          id: (dashboardViewModel.cardListStream.value.length + 1).toString(),
          index: dashboardViewModel.cardListStream.value.length + 1,
          title: inputValue);

      await dashboardViewModel.addCardList(data);
    }
  }

  _deleteCardList(CardListData cardList)async{
    await showDialog(
        context: context,
        builder: (alertContext) {
          return CustomAlertDialog("Are you sure you want to delete this Card List?",
            buttonPositive: ButtonBuilder( "Delete", () {
              Navigator.pop(alertContext);
              dashboardViewModel.deleteCardList(cardList);
            },textColor: Colors.white,bgColor: Colors.red),
            buttonNegative: ButtonBuilder( "Close", () {
              Navigator.pop(alertContext);
            }),
          );
        }
    );
  }

  _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    dashboardViewModel.updateCard(oldItemIndex, oldListIndex,newItemIndex,newListIndex);
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    dashboardViewModel.updateCardList(oldListIndex, newListIndex);
  }
}