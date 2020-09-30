import 'dart:io';

import 'package:flutter/material.dart';
import 'package:save_file/pages/update_form.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  List file = new List();
  Future<void> _listofFiles() async {
    setState(() {
      file = Directory("/storage/emulated/0/user_data").listSync();
      //use your folder name insted of resume.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 300.0,
        child: FutureBuilder(
          future: _listofFiles(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (file.length == 0) {
              return Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )),
                  Center(
                      child: Text(
                    "No Data Available",
                    style: TextStyle(fontSize: 18.0),
                  )),
                ],
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: file.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(
                              //         builder: (context) => UpdateFormScreen(
                              //             file: file[index]
                              //                 .toString()
                              //                 .substring(
                              //                     7,
                              //                     file[index]
                              //                             .toString()
                              //                             .length -
                              //                         1))));
                            },
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                  file[index].toString().substring(
                                      37, file[index].toString().length - 1),
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    // final dir = Directory(file[index]
                                    //     .toString()
                                    //     .substring(7,
                                    //         file[index].toString().length - 1));
                                    // dir.deleteSync(recursive: true);
                                    // setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
