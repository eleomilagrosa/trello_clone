import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trello_clone/model/models/card_data.dart';
import 'package:trello_clone/model/models/card_list_data.dart';
import 'package:trello_clone/model/repository/base/base_repository.dart';
import 'package:trello_clone/view_model/base/base_controller.dart';

class CardRepository extends BaseRepository{
  CardRepository(BaseController baseController): super(baseController);

  Future<List<CardData>> getCardItems(String cardListId)async{
    var data = await fireStore.collection('cards')
        .where("parentId",isEqualTo: cardListId)
        .where("deleted_at",isNull: true)
        .orderBy("index").get();
    return data.docs.map((it) => CardData.fromJson(it.data()..putIfAbsent("id", () => it.id))).toList();
  }

  Future<CardListData?> addCard(String cardListId,CardData cardList)async{
    var doc = await fireStore.collection('cards').add(cardList.add());
    var data = await doc.get();
    if(!data.exists) return null;
    return CardListData.fromJson(data.data()!..putIfAbsent("id", () => data.id));
  }

  Future updateCards({required List<CardData> oldCards,required List<CardData> newCards})async{
    WriteBatch batch = fireStore.batch();
    for (var card in oldCards) {
      batch.update(fireStore.collection('cards').doc(card.id), card.update());
    }
    for (var card in newCards) {
      batch.update(fireStore.collection('cards').doc(card.id), card.update());
    }
    await batch.commit();
  }

  Future deleteCard(CardData card)async{
    var doc = fireStore.collection("cards").doc(card.id);
    await doc.update(card.delete());
  }
}