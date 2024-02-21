import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:testing_it/models/User.dart';
import 'package:testing_it/page/EditUser.dart';
import 'package:http/http.dart' as http;

class UserCard extends StatelessWidget {
  VoidCallback refetch;
  String role;
  Member user;
  UserCard(
      {super.key,
      required this.user,
      required this.refetch,
      required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(9),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "ชื่อ-นามสกุล : ${user.mName}",
                style: TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
              Text(
                "ชื่อผู้ใช้ : ${user.mUser}",
              ),
              Text("เบอร์โทร : ${user.mPhone}"),
              Text("รหัสผ่าน : ${user.mPass}"),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditUser(
                                      old_user: user,
                                      role: role,
                                    )));
                      },
                      icon: Icon(
                        Icons.edit_note_sharp,
                        color: Colors.yellow[800],
                      )),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("ลบผู้ใช้?"),
                                  content: Text("ต้องการลบผู้ใช้หรือไม่ ?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ยกเลิก")),
                                    TextButton(
                                        onPressed: () async {
                                          await http.delete(Uri.parse(
                                              "http://172.16.48.64:3000/member/${user.mUser}"));
                                          Navigator.of(context).pop();
                                          refetch();
                                        },
                                        child: Text("ลบ")),
                                  ],
                                ));
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
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
