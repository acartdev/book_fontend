import 'package:flutter/material.dart';
import 'package:testing_it/models/CheckUser.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/widgets/navbar.dart';

class ManageBook extends StatefulWidget {
  const ManageBook({super.key});

  @override
  State<ManageBook> createState() => _ManageBookState();
}

class _ManageBookState extends State<ManageBook> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(
        member: info,
      ),
      appBar: AppBar(
        title: Text("add boox"),
      ),
      body: const Center(
        child: Text("add book"),
      ),
    );
  }
}
