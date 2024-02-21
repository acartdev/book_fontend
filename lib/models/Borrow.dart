// To parse this JSON data, do
//
//     final borrow = borrowFromJson(jsonString);

import 'dart:convert';

Borrow borrowFromJson(String str) => Borrow.fromJson(json.decode(str));

String borrowToJson(Borrow data) => json.encode(data.toJson());

class Borrow {
  int? brId;
  DateTime? brDateBr;
  DateTime? brDateRt;
  int? bFine;
  BId? bId;
  MUser? mUser;

  Borrow({
    this.brId,
    this.brDateBr,
    this.brDateRt,
    this.bFine,
    this.bId,
    this.mUser,
  });

  factory Borrow.fromJson(Map<String, dynamic> json) => Borrow(
        brId: json["br_id"],
        brDateBr: json["br_date_br"] == null
            ? null
            : DateTime.parse(json["br_date_br"]),
        brDateRt: json["br_date_rt"] == null
            ? null
            : DateTime.parse(json["br_date_rt"]),
        bFine: json["b_fine"],
        bId: json["b_id"] == null ? null : BId.fromJson(json["b_id"]),
        mUser: json["m_user"] == null ? null : MUser.fromJson(json["m_user"]),
      );

  Map<String, dynamic> toJson() => {
        "br_id": brId,
        "br_date_br":
            "${brDateBr!.year.toString().padLeft(4, '0')}-${brDateBr!.month.toString().padLeft(2, '0')}-${brDateBr!.day.toString().padLeft(2, '0')}",
        "br_date_rt":
            "${brDateRt!.year.toString().padLeft(4, '0')}-${brDateRt!.month.toString().padLeft(2, '0')}-${brDateRt!.day.toString().padLeft(2, '0')}",
        "b_fine": bFine,
        "b_id": bId?.toJson(),
        "m_user": mUser?.toJson(),
      };
}

class BId {
  String? bId;
  String? bName;
  int? bCategory;
  String? bWriter;
  int? bPrice;

  BId({
    this.bId,
    this.bName,
    this.bCategory,
    this.bWriter,
    this.bPrice,
  });

  factory BId.fromJson(Map<String, dynamic> json) => BId(
        bId: json["b_id"],
        bName: json["b_name"],
        bCategory: json["b_category"],
        bWriter: json["b_writer"],
        bPrice: json["b_price"],
      );

  Map<String, dynamic> toJson() => {
        "b_id": bId,
        "b_name": bName,
        "b_category": bCategory,
        "b_writer": bWriter,
        "b_price": bPrice,
      };
}

class MUser {
  String? mUser;
  String? mName;
  String? mPhone;
  String? mPass;
  String? mRole;

  MUser({
    this.mUser,
    this.mName,
    this.mPhone,
    this.mPass,
    this.mRole,
  });

  factory MUser.fromJson(Map<String, dynamic> json) => MUser(
        mUser: json["m_user"],
        mName: json["m_name"],
        mPhone: json["m_phone"],
        mPass: json["m_pass"],
        mRole: json["m_role"],
      );

  Map<String, dynamic> toJson() => {
        "m_user": mUser,
        "m_name": mName,
        "m_phone": mPhone,
        "m_pass": mPass,
        "m_role": mRole,
      };
}
