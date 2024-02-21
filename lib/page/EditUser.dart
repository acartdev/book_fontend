import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/page/ManageAdmin.dart';
import 'package:testing_it/page/ManageUser.dart';
import 'package:http/http.dart' as http;

class EditUser extends StatefulWidget {
  Member old_user;
  String role;
  EditUser({super.key, required this.old_user, required this.role});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final formKey = GlobalKey<FormState>();
  final Member users = Member();

  Future<Map<String, dynamic>> editMember() async {
    users.mRole = widget.role;
    var req = await http.patch(
        Uri.parse("http://192.168.56.1:3000/member/${widget.old_user.mUser}"),
        body: jsonEncode(users),
        headers: {'Content-Type': 'application/json'});
    return jsonDecode(req.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขข้อมูลผู้ใช้"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: "${widget.old_user.mUser}",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณากรอกชื่อผู้ใช้!";
                  }
                  if (value.length > 40) {
                    return "ชื่อผู้ใช้ต้องไม่เกิน 40 ตัวอักษร!";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text("ชื่อผู้ใช้"),
                ),
                onSaved: (String? value) {
                  users.mUser = value;
                },
              ),
              TextFormField(
                initialValue: widget.old_user.mName,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณากรอกชื่อ-นามสกุลผู้ใช้!";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  label: Text("ชื่่อ-นามสกุล"),
                ),
                onSaved: (String? value) {
                  users.mName = value;
                },
              ),
              TextFormField(
                initialValue: widget.old_user.mPhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณากรอกเบอร์โทรให้ครบถ้วน!";
                  }
                  if (value.length > 10 || value.length < 10) {
                    return "เบอร์โทรศัพท์ไม่ถูกต้อง";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  label: Text("เบอร์โทร"),
                ),
                onSaved: (String? value) {
                  users.mPhone = value;
                },
              ),
              TextFormField(
                initialValue: widget.old_user.mPass,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณากรอกรหัสผ่านให้ครบถ้วน!";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  label: Text("รหัสผ่าน"),
                ),
                onSaved: (String? value) {
                  users.mPass = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          var res = await editMember();
                          if (res['status'] == "Fail") {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                        res['msg'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.redAccent),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                        res['msg'],
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          widget.role == "user"
                                                              ? ManageUser()
                                                              : ManageAdmin()));
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          }
                        }
                      },
                      child: Text("แก้ไขข้อมูล")),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("ยกเลิก!"),
                                  content: Text("ต้องการยกเลิกแก้ไขหรือไม่ ?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ยกเลิก")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ManageUser()));
                                        },
                                        child: Text("ตกลง"))
                                  ],
                                ));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow[800])),
                      child: Text(
                        "ยกเลิก",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
