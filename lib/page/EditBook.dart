import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:testing_it/models/Book.dart';
import 'package:testing_it/page/Home.dart';

class EditBook extends StatefulWidget {
  Book old_book;
  EditBook({super.key, required this.old_book});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final formkey = GlobalKey<FormState>();

  final Book bookModal = Book();

  Future<Map<String, dynamic>> editBook() async {
    var req = await http.patch(
        Uri.parse("http://192.168.56.1:3000/books/${widget.old_book.bId}"),
        body: jsonEncode(bookModal),
        headers: {'Content-Type': 'application/json'});
    return jsonDecode(req.body);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      bookModal.bCategory = widget.old_book.bCategory;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขข้อมูลหนังสือ"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: widget.old_book.bId,
                    validator: (String? bId) {
                      if (bId!.isEmpty) {
                        return "กรุณากรอกรหัสหนังสือ!!";
                      }
                      if (bId.length < 6 || bId.length > 6) {
                        return "รหัสหนังสือไม่ถูกต้อง!!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        label: Text("รหัสหนังสือ"),
                        helperText: "ขึ้นต้นด้วย B ตามด้วยเลขจำนวน 5ตัว"),
                    onSaved: (String? bId) {
                      bookModal.bId = bId;
                    },
                  ),
                  TextFormField(
                    initialValue: widget.old_book.bName,
                    decoration: InputDecoration(label: Text("ชื่อหนังสือ")),
                    validator: (String? bName) {
                      if (bName!.isEmpty) {
                        return "กรุณากรอกชื่อหนังสือ!!";
                      }
                      return null;
                    },
                    onSaved: (String? bName) {
                      bookModal.bName = bName;
                    },
                  ),
                  TextFormField(
                    initialValue: widget.old_book.bWriter,
                    decoration: InputDecoration(label: Text("ชื่อผู้แต่ง")),
                    validator: (String? bName) {
                      if (bName!.isEmpty) {
                        return "กรุณากรอกชื่อผู้แต่ง!!";
                      }
                      return null;
                    },
                    onSaved: (String? bWriter) {
                      bookModal.bWriter = bWriter;
                    },
                  ),
                  TextFormField(
                    initialValue: "${widget.old_book.bPrice}",
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(label: Text("ราคา (บาท)")),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "กรุณากรอกราคาหนังสือ!!";
                      }
                      if (int.tryParse("$value") == null) {
                        return "กรุณากรอกตัวเลข!!";
                      }
                      return null;
                    },
                    onSaved: (String? bPrice) {
                      bookModal.bPrice = int.parse("$bPrice");
                    },
                  ),
                  Column(
                    children: [
                      Text(
                        "หมวดหมู่",
                        style: TextStyle(fontSize: 20),
                      ),
                      RadioListTile(
                          title: Text("วิชาการ"),
                          value: 1,
                          groupValue: bookModal.bCategory,
                          onChanged: (int? bCategory) {
                            setState(() {
                              bookModal.bCategory = bCategory;
                            });
                          }),
                      RadioListTile(
                          title: Text("วรรณากรรม"),
                          value: 2,
                          groupValue: bookModal.bCategory,
                          onChanged: (int? bCategory) {
                            setState(() {
                              bookModal.bCategory = bCategory;
                            });
                          }),
                      RadioListTile(
                          title: Text("เบ็ดเตล็ด"),
                          value: 3,
                          groupValue: bookModal.bCategory,
                          onChanged: (int? bCategory) {
                            setState(() {
                              bookModal.bCategory = bCategory;
                            });
                          }),
                    ],
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                              formkey.currentState?.save();
                              var res = await editBook();
                              if (res['status'] == "Fail") {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                            res['msg'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.redAccent),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("ตกลง"))
                                          ],
                                        ));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                            res['msg'],
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HomePage()));
                                                },
                                                child: Text("ตกลง"))
                                          ],
                                        ));
                              }
                            }
                          },
                          child: Text("แก้ไขข้อมูล")),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("ยกเลิก!"),
                                      content:
                                          Text("ต้องการยกเลิกแก้ไขหรือไม่ ?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("ยกเลิก")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()));
                                            },
                                            child: Text("ตกลง"))
                                      ],
                                    ));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.yellow[800])),
                          child: Text(
                            "ยกเลิก",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )

                  // Function to check if a given string is numeric
                ],
              )),
        ),
      ),
    );
  }
}
