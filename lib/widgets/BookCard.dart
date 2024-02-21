import 'package:flutter/material.dart';
import 'package:testing_it/models/Book.dart';
import 'package:testing_it/page/EditBook.dart';
import 'package:http/http.dart' as http;

class BookCard extends StatelessWidget {
  Book books;
  String m_user;
  String role;
  VoidCallback refetch;
  BookCard(
      {super.key,
      required this.refetch,
      required this.books,
      required this.m_user,
      required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(9),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${books.bName}",
                      style: TextStyle(fontSize: 20, color: Colors.purple),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("ยืมหนังสือ?"),
                                    content: Text("ขออนุมัติยืมหนังสิอ?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("ยกเลิก")),
                                      TextButton(
                                          onPressed: () async {
                                            await http.post(
                                                Uri.parse(
                                                    "http://172.16.48.64:3000/borrows"),
                                                body: {
                                                  "b_id": books.bId,
                                                  "m_user": m_user
                                                });
                                            Navigator.pop(context);
                                          },
                                          child: Text("ยืม")),
                                    ],
                                  ));
                        },
                        icon: Icon(
                          Icons.add_box_outlined,
                          color: Colors.deepPurple,
                        ))
                  ],
                ),
                Text("รหัสหนังสือ : ${books.bId}"),
                Text("หมวดหมู่ : ${books.category}"),
                Text("ราคา : ${books.bPrice} บาท"),
                const Divider(),
                Text("ผู้เขียน : ${books.bWriter}"),
                const Divider(),
                role != "user"
                    ? Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("ลบหนังสือ?"),
                                          content:
                                              Text("ต้องการลบหนังสือหรือไม่ ?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("ยกเลิก")),
                                            TextButton(
                                                onPressed: () async {
                                                  await http.delete(Uri.parse(
                                                      "http://172.16.48.64:3000/books/${books.bId}"));
                                                  Navigator.of(context).pop();
                                                  refetch();
                                                },
                                                child: Text(
                                                  "ลบ",
                                                  style: TextStyle(
                                                      color: Colors.redAccent),
                                                )),
                                          ],
                                        ));
                              },
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.redAccent,
                              )),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditBook(old_book: books)));
                              },
                              icon: Icon(Icons.edit_calendar_rounded,
                                  color: Colors.yellow[800])),
                        ],
                      )
                    : const SizedBox()
              ]),
        ),
      ),
    );
  }
}
