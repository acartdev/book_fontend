import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testing_it/models/Book.dart';
import 'package:testing_it/models/CheckUser.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/page/AddBook.dart';
import 'package:testing_it/widgets/BookCard.dart';
import 'package:testing_it/widgets/Loading.dart';
import 'package:testing_it/widgets/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _query;
  Future<List<Book>> getBook({String? query}) async {
    var url = Uri.http('192.168.56.1:3000',
        "/books${query == null ? "" : "/search?search=${_query}"}");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final List<Book> users =
          jsonData.map((dynamic json) => Book.fromJson(json)).toList();
      return users;
    } else {
      throw Exception("เกิดข้อผิดพลาดในการดึงข้อมูล");
    }
  }

  late Future<List<Book>> _book;

  late Member info;

  @override
  void initState() {
    super.initState();
    getInfo();
    setState(() {
      _book = getBook();
    });
  }

  Future<void> getInfo() async {
    var infos = await User.getInfo();
    setState(() {
      info = infos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(
        member: info,
      ),
      appBar: AppBar(
        title: Text("หน้าแรก"),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: getBook(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Load();
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final book = snapshot.data;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      _query = value;
                      _book = getBook(query: _query);
                    });
                  },
                  decoration: InputDecoration(label: Text("ค้นหา")),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: book!.length,
                    itemBuilder: (context, index) {
                      Book? books = book[index];

                      return BookCard(
                        m_user: info.mUser!,
                        role: info.mRole!,
                        refetch: getBook,
                        books: books,
                      );
                    }),
              ),
            ]);
          } else {
            return const Center(
              child: Text("ไม่มีข้อมูลหนังสือ!"),
            );
          }
        },
      ),
      floatingActionButton: info.mRole != "user"
          ? FloatingActionButton(
              elevation: 4,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.purpleAccent,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addbook()));
              })
          : const SizedBox(),
    );
  }
}
