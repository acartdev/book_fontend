import 'package:flutter/material.dart';
import 'package:testing_it/models/Borrow.dart';
import 'package:testing_it/models/CheckUser.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/widgets/BorrowCard.dart';
import 'package:testing_it/widgets/Loading.dart';
import 'package:testing_it/widgets/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  Future<List<Borrow>> getHist() async {
    var url = Uri.http('192.168.56.1:3000', "/borrows");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Borrow> users =
          jsonData.map((dynamic json) => Borrow.fromJson(json)).toList();

      return users;
    } else {
      throw Exception("เกิดข้อผิดพลาดในการดึงข้อมูล");
    }
  }

  late Future<List<Borrow>> _borrow;
  void refetch() {
    setState(() {
      _borrow = getHist();
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
      _borrow = getHist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Navbar(
          member: info,
        ),
        appBar: AppBar(
          title: Text("จัดการการยืม-คืน"),
        ),
        body: FutureBuilder(
          future: _borrow,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Load();
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final borrow = snapshot.data;
              return ListView.builder(
                  itemCount: borrow!.length,
                  itemBuilder: (context, index) {
                    Borrow history = borrow[index];
                    return BorrowCard(
                      refetch: refetch,
                      hist: history,
                    );
                  });
            } else {
              return const Center(
                child: Text("ไม่พบข้อมูลการขอยืม-คืน หนังสือ"),
              );
            }
          },
        ));
  }
}
