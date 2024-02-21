import 'package:flutter/material.dart';
import 'package:testing_it/models/CheckUser.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/widgets/Loading.dart';
import 'package:testing_it/widgets/UserCard.dart';
import 'package:testing_it/widgets/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  Future<List<Member>> getMember() async {
    var url = Uri.http('192.168.56.1:3000', "/member");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Member> users =
          jsonData.map((dynamic json) => Member.fromJson(json)).toList();
      return users;
    } else {
      throw Exception("เกิดข้อผิดพลาดในการดึงข้อมูล");
    }
  }

  late Future<List<Member>> _member;
  void refetch() {
    setState(() {
      _member = getMember();
    });
  }

  late Member info;
  Future<void> getInfo() async {
    var infos = await User.getInfo();
    setState(() {
      info = infos;
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
    setState(() {
      _member = getMember();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Navbar(
          member: info,
        ),
        appBar: AppBar(
          title: Text("จัดการผู้ใช้งาน"),
        ),
        body: FutureBuilder(
          future: _member,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Load();
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final _user = snapshot.data;
              return ListView.builder(
                  itemCount: _user!.length,
                  itemBuilder: (context, index) {
                    Member? users = _user[index];
                    return UserCard(
                      role: "user",
                      refetch: refetch,
                      user: users,
                    );
                  });
            } else {
              return const Center(
                child: Text("ไม่มีข้อมูลผู้ใช้งาน!"),
              );
            }
          },
        ));
  }
}
