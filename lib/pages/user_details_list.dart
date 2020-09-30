import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:save_file/pages/update_form.dart';

class UserDataListScreen extends StatefulWidget {
  @override
  _UserDataListScreenState createState() => _UserDataListScreenState();
}

class _UserDataListScreenState extends State<UserDataListScreen> {
  String directory;
  List file = new List();
  @override
  void initState() {
    super.initState();
  }

  // Make New Function
  Future<void> _listofFiles() async {
    setState(() {
      file = io.Directory("/storage/emulated/0/user_data").listSync();
      //use your folder name insted of resume.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User data"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _listofFiles();
        },
        child: FutureBuilder(
          future: _listofFiles(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: file.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => UpdateFormScreen(
                                    file: file[index].toString().substring(
                                        7, file[index].toString().length - 1))),
                            (route) => false);
                      },
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            file[index].toString().substring(
                                37, file[index].toString().length - 1),
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                final dir = Directory(file[index]
                                    .toString()
                                    .substring(
                                        7, file[index].toString().length - 1));
                                dir.deleteSync(recursive: true);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
