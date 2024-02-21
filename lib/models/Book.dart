// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  String? bId;
  String? bName;
  int? bCategory;
  String? bWriter;
  int? bPrice;
  String? category;

  Book({
    this.bId,
    this.bName,
    this.bCategory,
    this.bWriter,
    this.bPrice,
    this.category,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        bId: json["b_id"],
        bName: json["b_name"],
        bCategory: json["b_category"],
        bWriter: json["b_writer"],
        bPrice: json["b_price"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "b_id": bId,
        "b_name": bName,
        "b_category": bCategory,
        "b_writer": bWriter,
        "b_price": bPrice,
        "category": category,
      };
}
