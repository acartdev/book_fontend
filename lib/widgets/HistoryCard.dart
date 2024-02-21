import 'package:flutter/material.dart';
import 'package:testing_it/models/Borrow.dart';

class HistoryCard extends StatelessWidget {
  Borrow history;
  HistoryCard({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Card(
        color: history.brDateRt == null ? Colors.redAccent : Colors.lightGreen,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                history.brDateRt == null ? "ยังไม่คืน" : "คืนแล้ว",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const Divider(),
              Text(
                "ผู้ยืม : ${history.mUser!.mName}",
                style: TextStyle(color: Colors.white),
              ),
              Text("รหัสหนังสือ : ${history.bId!.bId}",
                  style: TextStyle(color: Colors.white)),
              Text("ชื่อหนังสือ : ${history.bId!.bName}",
                  style: TextStyle(color: Colors.white)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      "วันที่ยืม : ${history.brDateBr.toString().substring(0, 10)}",
                      style: TextStyle(color: Colors.white)),
                  Text("ค่าปรับ : ${history.bFine} บาท",
                      style: TextStyle(color: Colors.white))
                ],
              ),
              Text(
                  "วันที่คืน : ${history.brDateRt == null ? "ไม่ระบุ" : history.brDateRt.toString().substring(0, 10)}",
                  style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }
}
