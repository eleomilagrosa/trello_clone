// To parse this JSON data, do
//
//     final cardListData = cardListDataFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:trello_clone/model/models/card_data.dart';

class CardListData {
  CardListData({
    required this.id,
    required this.index,
    required this.title,
  });

  String? id;
  int index;
  String title;

  CardListData copyWith({
    int? index,
    String? id,
    String? title,
  }) =>
      CardListData(
        id: id ?? this.id,
        index: index ?? this.index,
        title: title ?? this.title,
      );

  factory CardListData.fromRawJson(String str) => CardListData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardListData.fromJson(Map<String, dynamic> json) => CardListData(
    id: json["id"],
    index: json["index"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "index": index,
    "title": title,
  };

  Map<String, dynamic> add() => {
    "index": index,
    "title": title,
    "deleted_at": null,
  };

  Map<String, dynamic> update() => {
    "index": index,
    "updated_at": FieldValue.serverTimestamp(),
  };

  Map<String, dynamic> delete() => {
    "deleted_at": FieldValue.serverTimestamp(),
  };
}
