import 'package:flutter/material.dart';
import 'package:testing_it/models/Borrow.dart';
import 'package:http/http.dart' as http;
import 'package:testing_it/page/BorrowPage.dart';

class BorrowCard extends StatelessWidget {
  Borrow hist;
  final VoidCallback refetch;
  BorrowCard({super.key, required this.hist, required this.refetch});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ขออนุมัติยืมหนังสือ",
                style: TextStyle(color: Colors.deepPurple, fontSize: 18),
              ),
              const Divider(),
              Text("ชื่อหนังสือ : ${hist.bId!.bName}"),
              Text("รหัสหนังสือ : ${hist.bId!.bId}"),
              Text("ชื่อผู้เขียน : ${hist.bId!.bWriter}"),
              Text("ชื่อผู้ยืม : ${hist.mUser!.mName}"),
              Text("ชื่อผู้ใช้ : ${hist.mUser!.mUser}"),
              Divider(),
              hist.brDateBr != null
                  ? TextButton(
                      onPressed: () async {
                        var url = Uri.http('172.16.48.64:3000',
                            "/borrows/return/${hist.brId}");
                        await http.patch(url);
                        refetch();
                      },
                      child: Text("คืนหนังสือ"))
                  : Row(
                      children: [
                        TextButton(
                            onPressed: () async {
                              var url = Uri.http('172.16.48.64:3000',
                                  "/borrows/borrow/${hist.brId}");
                              await http.patch(url);
                              refetch();
                            },
                            child: const Text("อนุมัติ")),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
