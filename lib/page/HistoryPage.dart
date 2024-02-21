import 'package:flutter/material.dart';
import 'package:testing_it/models/Borrow.dart';
import 'package:testing_it/models/CheckUser.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/widgets/HistoryCard.dart';
import 'package:testing_it/widgets/Loading.dart';
import 'package:testing_it/widgets/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<Borrow>> getHist({String? hist}) async {
    var url = Uri.http('192.168.56.1:3000', "/borrows/hist/${hist}");
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

  late Future<List<Borrow>> _hist;
  late Member info;
  Future<void> getInfo() async {
    var infos = await User.getInfo();
    setState(() {
      info = infos;
    });
    setState(() async {
      _hist = getHist(hist: info.mUser);
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(
        member: info,
      ),
      appBar: AppBar(
        title: const Text("ประวัติการยืม-คืน"),
      ),
      body: FutureBuilder(
        future: _hist,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Load();
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final histy = snapshot.data;
            return ListView.builder(
                itemCount: histy!.length,
                itemBuilder: (context, index) {
                  Borrow _hist = histy[index];
                  return HistoryCard(
                    history: _hist,
                  );
                });
          } else {
            return const Center(
              child: Text("ไม่มีประวัติการยืมคืน!"),
            );
          }
        },
      ),
    );
  }
}
