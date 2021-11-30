import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trello_clone/model/models/card_data.dart';
import 'package:trello_clone/model/models/card_list_data.dart';
import 'package:trello_clone/model/repository/card_list_repository.dart';
import 'package:trello_clone/model/repository/card_repository.dart';
import 'package:trello_clone/view_model/base/app_controller.dart';
import 'package:trello_clone/view_model/base/base_controller.dart';
import 'package:collection/collection.dart';

class DashboardViewModel extends BaseController{

  late CardRepository cardRepository;
  late CardListRepository cardListRepository;
  DashboardViewModel(AppController appController): super(appController){
    cardListRepository = CardListRepository(this);
    cardRepository = CardRepository(this);
    loadCardList();
  }

  List<CardListData> originalList = [];
  Map<String,List<CardData>> cards = {};
  BehaviorSubject<List<CardListData>> cardListStream = BehaviorSubject();

  loadCardList(){
    cardListStream.add([]);
    cardListRepository.streamCardList().listen((cardList)async{
      originalList = cardList;
      cardListStream.add(originalList);

      var listCardList = await Future.wait(cardList.map<Future<List<CardData>>>((cardList) => cardRepository.getCardItems(cardList.id!)).toList());
      listCardList.forEachIndexed((index, data) {
        cards[cardList[index].id!] = data;
      });
      cardListStream.add(originalList);
    });
  }

  Future addCardList(CardListData cardList)async{
    originalList.add(cardList);
    cardListStream.add(originalList);
    await cardListRepository.addCardList(cardList);
  }
  Future updateCardList(int oldListIndex, int newListIndex)async{
    var movedList = originalList.removeAt(oldListIndex);
    originalList.insert(newListIndex, movedList);

    originalList.forEachIndexed((index, data) {
      data.index = index + 1;
    });
    await cardListRepository.updateAllCardList(originalList);
  }

  Future deleteCardList(CardListData cardList)async{
    originalList.remove(cardList);
    cardListStream.add(originalList);
    await cardListRepository.deleteCardList(cardList);
  }


  Future addCard(String cardListId,CardData card)async{
    card.email = auth.currentUser?.email ?? "";
    cards[cardListId]?.add(card);
    cardListStream.add(originalList);
    await cardRepository.addCard(cardListId,card);
  }
  Future updateCard(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex)async{
    var movedItem = cards[originalList[oldListIndex].id]!.removeAt(oldItemIndex);
    movedItem.parentId = originalList[newListIndex].id!;
    cards[originalList[newListIndex].id]!.insert(newItemIndex, movedItem);

    cards[originalList[oldListIndex].id]?.forEachIndexed((index, data) {
      data.index = index + 1;
    });
    cards[originalList[newListIndex].id]?.forEachIndexed((index, data) {
      data.index = index + 1;
    });

    cardListStream.add(originalList);

    await cardRepository.updateCards(
      newCards: cards[originalList[newListIndex].id] ?? [],
      oldCards: cards[originalList[oldListIndex].id] ?? [],
    );
    cardListRepository.updateCardList(originalList[newListIndex]);
  }
  Future deleteCard(String cardListId,CardData card)async{
    var cardList = cards[cardListId];
    cardList?.remove(card);
    cardListStream.add(originalList);
    await cardRepository.deleteCard(card);
  }
}