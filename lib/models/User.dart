// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

Member memberFromJson(String str) => Member.fromJson(json.decode(str));

String memberToJson(Member data) => json.encode(data.toJson());

class Member {
  String? mUser;
  String? mName;
  String? mPhone;
  String? mPass;
  String? mRole;

  Member({
    this.mUser,
    this.mName,
    this.mPhone,
    this.mPass,
    this.mRole,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
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
