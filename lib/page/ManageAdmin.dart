import 'package:flutter/material.dart';
import 'package:testing_it/models/CheckUser.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/page/AddAdmin.dart';
import 'package:testing_it/widgets/Loading.dart';
import 'package:testing_it/widgets/UserCard.dart';
import 'package:testing_it/widgets/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageAdmin extends StatefulWidget {
  const ManageAdmin({super.key});

  @override
  State<ManageAdmin> createState() => _ManageAdminState();
}

class _ManageAdminState extends State<ManageAdmin> {
  Future<List<Member>> getMember() async {
    var url = Uri.http('192.168.56.1:3000', "/member/admin");
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

  void refetch() {
    setState(() {
      _admin = getMember();
    });
  }

  late Member info;
  Future<void> getInfo() async {
    var infos = await User.getInfo();
    setState(() {
      info = infos;
    });
  }

  late Future<List<Member>> _admin;
  @override
  void initState() {
    super.initState();
    getInfo();
    setState(() {
      _admin = getMember();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(
        member: info,
      ),
      appBar: AppBar(
        title: const Text("จัดการผู้ดูแลระบบ"),
      ),
      body: FutureBuilder(
        future: _admin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Load();
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final user = snapshot.data;
            return ListView.builder(
                itemCount: user!.length,
                itemBuilder: (context, index) {
                  Member? users = user[index];
                  return UserCard(
                    role: "admin",
                    refetch: refetch,
                    user: users,
                  );
                });
          } else {
            return Center(
              child: Text("ไม่มีข้อมูลผู้จัดการระบบ!"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddAdmin()));
        },
      ),
    );
  }
}
