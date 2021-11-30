import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trello_clone/model/models/card_data.dart';
import 'package:trello_clone/model/models/card_list_data.dart';
import 'package:trello_clone/model/repository/base/base_repository.dart';
import 'package:trello_clone/view_model/base/base_controller.dart';

class CardListRepository extends BaseRepository{
  CardListRepository(BaseController baseController): super(baseController);

  Stream<List<CardListData>> streamCardList(){
    return fireStore.collection('card_list')
        .where("deleted_at",isNull: true)
        .orderBy("index").snapshots()
        .map<List<CardListData>>((data) =>
        data.docs.map((it){
          return CardListData.fromJson(it.data()..putIfAbsent("id", () => it.id));
        }).toList()
    );
  }

  Future<CardListData?> addCardList(CardListData cardList)async{
    var doc = await fireStore.collection('card_list').add(cardList.add());
    var data = await doc.get();
    if(!data.exists) return null;
    return CardListData.fromJson(data.data()!..putIfAbsent("id", () => data.id));
  }

  Future updateAllCardList(List<CardListData> cardListData)async{
    WriteBatch batch = fireStore.batch();
    for (var cardList in cardListData) {
      batch.update(fireStore.collection('card_list').doc(cardList.id), cardList.update());
    }
    await batch.commit();
  }

  Future<CardListData?> updateCardList(CardListData cardList)async{
    var doc = fireStore.collection('card_list').doc(cardList.id);
    await doc.update(cardList.update());
    var data = await doc.get();
    if(!data.exists) return null;
    return CardListData.fromJson(data.data()!..putIfAbsent("id", () => data.id));
  }

  Future deleteCardList(CardListData cardList)async{
    var doc = fireStore.collection('card_list').doc(cardList.id);
    await doc.update(cardList.delete());
  }
}