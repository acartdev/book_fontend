import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/page/ManageAdmin.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final formKey = GlobalKey<FormState>();
  Member users = Member();
  Future<Map<String, dynamic>> addAdmin() async {
    users.mRole = "admin";
    var req = await http.post(Uri.parse("http://192.168.56.1:3000/member"),
        body: jsonEncode(users), headers: {'Content-Type': 'application/json'});
    return jsonDecode(req.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มผู้จัดการระบบ"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
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
                          var res = await addAdmin();
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
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ManageAdmin()));
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(res['msg']),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ManageAdmin()));
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          }
                        }
                      },
                      child: Text("บันทึกข้อมูล")),
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
                                                      ManageAdmin()));
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
