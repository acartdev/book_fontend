import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/page/Login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  Member users = Member();
  Future<Map<String, dynamic>> addMember() async {
    users.mRole = "user";
    var req = await http.post(Uri.parse("http://192.168.56.1:3000/member"),
        body: jsonEncode(users), headers: {'Content-Type': 'application/json'});
    return jsonDecode(req.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "สมัครสมาชิก",
                      style: TextStyle(color: Colors.deepPurple, fontSize: 32),
                    ),
                    Text(
                      "เพื่อเข้าใช้งานระบบห้องสมุด",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("ชื่อผู้ใช้"),
                ),
                onSaved: (String? value) {
                  users.mUser = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณากรอกชื่อ-นามสกุลผู้ใช้!";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("ชื่่อ-นามสกุล"),
                ),
                onSaved: (String? value) {
                  users.mName = value;
                },
              ),
              const SizedBox(
                height: 20,
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("เบอร์โทร"),
                ),
                onSaved: (String? value) {
                  users.mPhone = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "กรุณากรอกรหัสผ่านให้ครบถ้วน!";
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("รหัสผ่าน"),
                ),
                onSaved: (String? value) {
                  users.mPass = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: MaterialStatePropertyAll(Size(300, 50))),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          var res = await addMember();
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
                                                          RegisterPage()));
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("สมัครสมาชิกสำเร็จ!!"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()));
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          }
                        }
                      },
                      child: Text(
                        "สมัครสมาชิก",
                        style: TextStyle(fontSize: 20),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
