import 'package:flutter/material.dart';
import 'package:testing_it/models/CheckUser.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/page/BorrowPage.dart';
import 'package:testing_it/page/HistoryList.dart';
import 'package:testing_it/page/HistoryPage.dart';
import 'package:testing_it/page/ManageAdmin.dart';
import 'package:testing_it/page/ManageUser.dart';
import 'package:testing_it/page/check_login.dart';
import 'package:testing_it/page/home.dart';

class Navbar extends StatelessWidget {
  Member member;
  Navbar({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(children: [
          Container(
            height: 100,
            child: UserAccountsDrawerHeader(
                onDetailsPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Placeholder()));
                },
                margin: EdgeInsets.zero,
                accountName: Text("${member.mName}"),
                accountEmail: Column(
                  children: [Text("${member.mUser}"), Text("${member.mPhone}")],
                )),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("หน้าแรก"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("ประวัติการยืม-คืน"),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HistoryPage()));
            },
          ),
          member.mRole != "user"
              ? ListTile(
                  leading: const Icon(Icons.menu_book_rounded),
                  title: const Text("จัดการการยืม-คืน"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BorrowPage()));
                  },
                )
              : const SizedBox(),
          member.mRole != "user"
              ? ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text("จัดการสมาชิก"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ManageUser()));
                  },
                )
              : const SizedBox(),
          member.mRole != "user"
              ? ListTile(
                  leading: Icon(Icons.manage_history_sharp),
                  title: Text("ประวัติการยืม-คืน ทั้งหมด"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HistoryList()));
                  },
                )
              : const SizedBox(),
          member.mRole == "librarian"
              ? ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text("จัดการผู้ดูแลระบบ"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ManageAdmin()));
                  },
                )
              : const SizedBox(),
          const Divider(),
          ListTile(
            iconColor: Colors.redAccent,
            textColor: Colors.redAccent,
            leading: const Icon(Icons.logout_sharp),
            title: const Text("ออกจากระบบ"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text("ออกจากระบบ?"),
                        content: Text("คุณต้องการออกจากระบบหรือไม่?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("ยกเลิก")),
                          TextButton(
                              onPressed: () async {
                                await User.setLogin(false);
                                await User.setInfo(null);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckLogin()));
                              },
                              child: Text(
                                "ตกลง",
                                style: TextStyle(color: Colors.redAccent),
                              )),
                        ],
                      ));
            },
          ),
        ]),
      ),
    );
  }
}
