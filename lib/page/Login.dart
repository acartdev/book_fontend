import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testing_it/models/CheckUser.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/page/Home.dart';

import 'package:testing_it/page/register.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<Member> getMember(String? m_user) async {
    var url = Uri.http('192.168.56.1:3000', "/member/${m_user}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final Member users = Member.fromJson(jsonData);
      return users;
    } else {
      throw Exception("เกิดข้อผิดพลาดในการดึงข้อมูล");
    }
  }

  final formKey = GlobalKey<FormState>();
  Member users = Member();
  Future<Map<String, dynamic>> login() async {
    var req = await http.post(
        Uri.parse("http://192.168.56.1:3000/member/login"),
        body: jsonEncode(users),
        headers: {'Content-Type': 'application/json'});
    return jsonDecode(req.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ยินดีต้อนรับ !',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'ระบบห้องสมุด',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'ศูนย์ความเป็นเลิศทางการอาชีวศึกษา',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset('assets/img/Picture.png'),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "กรุณากรอกชื่อผู้ใช้งาน!";
                        }
                        return null;
                      },
                      onSaved: (String? m_user) {
                        users.mUser = m_user;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ชื่อผู้ใช้ ',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "กรุณากรอกรหัสผ่าน!";
                        }
                        return null;
                      },
                      onSaved: (String? m_pass) {
                        users.mPass = m_pass;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'รหัสผ่าน',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 350,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          var res = await login();
                          if (res['status'] == "Fail") {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("เข้าสุ่ระบบไม่สำเร็จ!"),
                                      content: Text(res['msg']),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          } else {
                            Member mems = await getMember(users.mUser);
                            await User.setLogin(true);
                            await User.setInfo(mems);

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("เข้าสุ่ระบบสำเร็จ!"),
                                      content: Text(res['msg']),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()));
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          }
                        }
                      },
                      child: const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: const Text(
                        "ถ้าคุณยังไม่เป็นสมาชิก กรูณาสมัครสมาชิกก่อนเข้าใช้งาน"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
