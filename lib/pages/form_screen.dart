import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../widget/dialog.dart';
import 'package:save_file/model/qualification.dart';
import 'package:save_file/widget/text_field.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> images = List<String>(); //aditional images
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String directory;
  File _pickedImage; //profile image
  var firstNameController,
      lastNameController,
      emailController,
      addtionalInfo,
      dateCtl;
  String dateOfBirth;
  var lastNameFocus, emailFocus, aditionalInfoFocus, firstNameFocus;
  List<Qualification> _qualification = Qualification.getCompanies();
  List<DropdownMenuItem<Qualification>> _dropdownMenuItems;
  Qualification _selectedQualification;
  @override
  void initState() {
    super.initState();

    _dropdownMenuItems = buildDropdownMenuItems(_qualification);
    _selectedQualification = _dropdownMenuItems[0].value;

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addtionalInfo = TextEditingController();
    emailController = TextEditingController();
    dateCtl = TextEditingController();

    firstNameFocus = FocusNode();
    lastNameFocus = FocusNode();
    emailFocus = FocusNode();
    aditionalInfoFocus = FocusNode();
  }

  List<DropdownMenuItem<Qualification>> buildDropdownMenuItems(
      List qualifications) {
    List<DropdownMenuItem<Qualification>> items = List();
    for (Qualification qualification in qualifications) {
      items.add(
        DropdownMenuItem(
          value: qualification,
          child: Text(qualification.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Qualification selectedQualification) {
    setState(() {
      _selectedQualification = selectedQualification;
    });
  }

  Future<File> writeData(Qualification selectedQualification) async {
    final directory = await ExtStorage.getExternalStorageDirectory();

    Directory _appDocDirFolder = Directory(directory + '/User_data');
    var path = '';
    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      path = _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      path = _appDocDirNewFolder.path;
    }

    final file = File(
        '$path/${(firstNameController.text).trim()} ${lastNameController.text.trim()}.txt');
    return file.writeAsString(
        '${_pickedImage.path}\n${firstNameController.text.trim()}\n${lastNameController.text.trim()}\n${emailController.text.trim()}\n${dateCtl.text.trim()}\n${addtionalInfo.text.trim()}\n${selectedQualification.name}\n$images');
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    addtionalInfo.dispose();
    emailController.dispose();
    dateCtl.dispose();

    firstNameFocus.dispose();
    lastNameFocus.dispose();
    emailFocus.dispose();
    aditionalInfoFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Form"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 100.0,
                    width: 100.0,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.blue),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: _pickedImage == null
                                    ? Center(
                                        child: Text(
                                        "No Image",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white),
                                      ))
                                    : Image(
                                        image: FileImage(_pickedImage),
                                        fit: BoxFit.cover,
                                      ),
                              )),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 5,
                          child: GestureDetector(
                            onTap: () async {
                              final imageSource = await showDialog<ImageSource>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Select the image source"),
                                        actions: <Widget>[
                                          MaterialButton(
                                            child: Text("Camera"),
                                            onPressed: () => Navigator.pop(
                                                context, ImageSource.camera),
                                          ),
                                          MaterialButton(
                                            child: Text("Gallery"),
                                            onPressed: () => Navigator.pop(
                                                context, ImageSource.gallery),
                                          )
                                        ],
                                      ));
                              if (imageSource != null) {
                                final file = await ImagePicker.pickImage(
                                    source: imageSource);
                                if (file != null) {
                                  setState(() => _pickedImage = file);
                                }
                              }
                            },
                            child: Container(
                              height: 30.0,
                              width: 30.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.amber,
                              ),
                              child: Icon(Icons.add),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                FormTextFormField(
                    controller: firstNameController,
                    focusnode: firstNameFocus,
                    focus: lastNameFocus,
                    name: "First Name"),
                FormTextFormField(
                    controller: lastNameController,
                    focusnode: lastNameFocus,
                    focus: emailFocus,
                    name: "Last Name"),
                FormTextFormField(
                    controller: emailController,
                    focusnode: emailFocus,
                    name: "Email"),
                //BirthDate
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            controller: dateCtl,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Date of birth",
                              hintText: "Select your Date of Birth",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  gapPadding: 10.0),
                            ),
                            onTap: () async {
                              DateTime date = DateTime(1900);
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());
                              if (date != null) {
                                dateOfBirth = date.toIso8601String();
                                dateCtl.text = DateFormat.yMMMd().format(date);
                              }
                            }),
                      ),
                      IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime date = DateTime(1900);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());
                            if (date != null) {
                              dateOfBirth = date.toIso8601String();
                              dateCtl.text = DateFormat.yMMMd().format(date);
                            }
                          })
                    ],
                  ),
                ),
                //aditional info
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    focusNode: aditionalInfoFocus,
                    controller: addtionalInfo,
                    onSaved: (newValue) {
                      addtionalInfo = newValue;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText: "Aditional Info",
                        labelStyle: TextStyle(fontSize: 20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            gapPadding: 10.0)),
                  ),
                ),
                //qualification
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Qualification:",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      DropdownButton(
                        value: _selectedQualification,
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                      ),
                    ],
                  ),
                ),
                //aditional images
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: () async {
                      final imageSource = await showDialog<ImageSource>(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Select the image source"),
                                actions: <Widget>[
                                  MaterialButton(
                                    child: Text("Camera"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.camera),
                                  ),
                                  MaterialButton(
                                    child: Text("Gallery"),
                                    onPressed: () => Navigator.pop(
                                        context, ImageSource.gallery),
                                  )
                                ],
                              ));
                      if (imageSource != null) {
                        if (imageSource == ImageSource.camera) {
                          File file =
                              await ImagePicker.pickImage(source: imageSource);
                          if (file != null) {
                            setState(() => images.add(file.path));
                          }
                        } else {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png'],
                          );

                          if (result != null) {
                            List<String> files = result.paths;
                            setState(() => images.addAll(files));
                          }
                        }
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text("Add Additional Images",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ),
                ),
                Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        width: 2,
                        style: BorderStyle.solid,
                        color: Colors.grey,
                      )),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Image.file(File(images[index])),
                            Positioned(
                                right: -10,
                                top: -10,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        images.removeAt(index);
                                      });
                                    }))
                          ],
                        ),
                      );
                    },
                  ),
                ),

                //buttons save and show details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () async {
                          // _formKey.currentState.validate();
                          if (_pickedImage == null) {
                            return showSnackBar('please Add profile image');
                          }
                          if (firstNameController.text == '') {
                            return showSnackBar('please enter first name');
                          }
                          if (lastNameController.text == '') {
                            return showSnackBar('please enter last name');
                          }
                          if (emailController.text == '' ||
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(emailController.text) ==
                                  false) {
                            return showSnackBar('please enter proper email');
                          }
                          if (dateCtl.text == '') {
                            return showSnackBar('please select birth date');
                          }

                          writeData(_selectedQualification).then((value) {
                            firstNameController.clear();
                            lastNameController.clear();
                            emailController.clear();
                            addtionalInfo.clear();
                            dateCtl.clear();
                            images.clear();
                            _selectedQualification =
                                _dropdownMenuItems[0].value;
                            _pickedImage = null;
                            setState(() {});
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Center(
                            child: Text(
                              'Save Details',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          //return buildShowDialog(context);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => UserDataListScreen()));
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return MyDialog();
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Center(
                            child: Text(
                              'Show Details',
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
