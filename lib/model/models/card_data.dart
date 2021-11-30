// To parse this JSON data, do
//
//     final cardData = cardDataFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class CardData {
  CardData({
    this.id = "",
    required this.parentId,
    required this.index,
    required this.title,
    this.email = "",
    required this.description,
    required this.created_at,
    this.updated_at,
  });

  String parentId;
  String id;
  int index;
  String email;
  String title;
  String description;
  DateTime created_at;
  DateTime? updated_at;

  CardData copyWith({
    int? index,
    String? id,
    String? parentId,
    String? title,
    String? description,
    String? email,
    DateTime? date,
    DateTime? updated_at,
  }) =>
      CardData(
        id: id ?? this.id,
        parentId: id ?? this.parentId,
        index: index ?? this.index,
        title: title ?? this.title,
        email: title ?? this.email,
        description: description ?? this.description,
        created_at: date ?? this.created_at,
        updated_at: date ?? this.updated_at,
      );

  factory CardData.fromRawJson(String str) => CardData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardData.fromJson(Map<String, dynamic> json) => CardData(
    id: json["id"],
    parentId: json["parentId"],
    index: json["index"],
    title: json["title"],
    email: json["email"],
    description: json["description"],
    created_at: json["created_at"] is String ? DateTime.parse(json["created_at"]) : (json["created_at"] as Timestamp).toDate(),
    updated_at: json["updated_at"] is String ? DateTime.parse(json["updated_at"]) : (json["updated_at"] as Timestamp).toDate(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "index": index,
    "title": title,
    "email": email,
    "description": description,
    "created_at": created_at.toIso8601String(),
    "updated_at": updated_at?.toIso8601String(),
  };

  Map<String, dynamic> add() => {
    "created_at": FieldValue.serverTimestamp(),
    "updated_at": FieldValue.serverTimestamp(),
    "index": index,
    "email": email,
    "title": title,
    "parentId": parentId,
    "description": description,
    "deleted_at": null,
  };

  Map<String, dynamic> update() => {
    "updated_at": FieldValue.serverTimestamp(),
    "index": index,
    "parentId": parentId,
  };

  Map<String, dynamic> delete() => {
    "deleted_at": FieldValue.serverTimestamp(),
  };
}
