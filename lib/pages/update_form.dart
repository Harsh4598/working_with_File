import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_file/model/qualification.dart';
import 'package:save_file/widget/text_field.dart';
import 'form_screen.dart';

class UpdateFormScreen extends StatefulWidget {
  final String file;

  const UpdateFormScreen({Key key, this.file}) : super(key: key);
  @override
  _UpdateFormScreenState createState() => _UpdateFormScreenState();
}

class _UpdateFormScreenState extends State<UpdateFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //aditional images
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String directory;
  List<String> contents;
  List<String> detailAddImage = List<String>();
  List file = new List();
  File _pickedImageDeails; //profile image
  var firstNameDeailsController,
      lastNameDeailsController,
      emailDeailsController,
      addtionalInfoDeailsController,
      dateDeailsCtl;
  String dateOfBirth, selectedQualificationDetails;
  var lastNameDeailsFocus,
      emailDeailsFocus,
      aditionalInfoDeailsFocus,
      firstNameDeailsFocus;
  List<Qualification> _qualification = Qualification.getCompanies();
  List<DropdownMenuItem<Qualification>> _dropdownMenuItems;
  Qualification _selectedQualification;
  @override
  void initState() {
    super.initState();
    readCounter();
    firstNameDeailsController = TextEditingController();
    lastNameDeailsController = TextEditingController();
    addtionalInfoDeailsController = TextEditingController();
    emailDeailsController = TextEditingController();
    dateDeailsCtl = TextEditingController();

    firstNameDeailsFocus = FocusNode();
    lastNameDeailsFocus = FocusNode();
    emailDeailsFocus = FocusNode();
    aditionalInfoDeailsFocus = FocusNode();
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
    final file = File(widget.file);
    return file.writeAsString(
        '${_pickedImageDeails.path}\n${firstNameDeailsController.text}\n${lastNameDeailsController.text}\n${emailDeailsController.text}\n${dateDeailsCtl.text}\n${addtionalInfoDeailsController.text}\n${selectedQualification.name}\n$detailAddImage');
  }

  Future<int> readCounter() async {
    try {
      final file = await File(widget.file);

      // Read the file.
      contents = await file.readAsLinesSync();
      _pickedImageDeails = File(contents[0]);
      firstNameDeailsController.text = contents[1];
      lastNameDeailsController.text = contents[2];
      emailDeailsController.text = contents[3];
      dateDeailsCtl.text = contents[4];
      addtionalInfoDeailsController.text = contents[5];
      selectedQualificationDetails = contents[6];
      if (contents[7].isNotEmpty) {
        detailAddImage = (contents[7].split(','));
        detailAddImage[0] = detailAddImage[0].substring(1);
        detailAddImage.last =
            detailAddImage.last.substring(0, detailAddImage.last.length - 1);
      }
    } catch (e) {
      // If encountering an error, return 0.
      return 0;
    }
  }

  Future<void> _listofFiles() async {
    setState(() {
      file = Directory("/storage/emulated/0/user_data").listSync();
      //use your folder name insted of resume.
    });
  }

  @override
  void dispose() {
    super.dispose();
    firstNameDeailsController.dispose();
    lastNameDeailsController.dispose();
    addtionalInfoDeailsController.dispose();
    emailDeailsController.dispose();
    dateDeailsCtl.dispose();

    firstNameDeailsFocus.dispose();
    lastNameDeailsFocus.dispose();
    emailDeailsFocus.dispose();
    aditionalInfoDeailsFocus.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dropdownMenuItems = buildDropdownMenuItems(_qualification);
    if (selectedQualificationDetails == 'Information Technology') {
      _selectedQualification = _dropdownMenuItems[0].value;
    }
    if (selectedQualificationDetails == 'Computer Engineer') {
      _selectedQualification = _dropdownMenuItems[1].value;
    }
    if (selectedQualificationDetails == 'Mechanical Engineer') {
      _selectedQualification = _dropdownMenuItems[2].value;
    }
    if (selectedQualificationDetails == 'Civil Engineer') {
      _selectedQualification = _dropdownMenuItems[3].value;
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());

    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("User Details"),
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
                                child: _pickedImageDeails == null
                                    ? Center(
                                        child: Text(
                                        "No Image",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white),
                                      ))
                                    : Image(
                                        image: FileImage(_pickedImageDeails),
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
                                  setState(() => _pickedImageDeails = file);
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
                    controller: firstNameDeailsController,
                    focusnode: firstNameDeailsFocus,
                    focus: lastNameDeailsFocus,
                    name: "First Name"),
                FormTextFormField(
                    controller: lastNameDeailsController,
                    focusnode: lastNameDeailsFocus,
                    focus: emailDeailsFocus,
                    name: "Last Name"),
                FormTextFormField(
                    controller: emailDeailsController,
                    focusnode: emailDeailsFocus,
                    name: "Email"),
                //BirthDate
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            controller: dateDeailsCtl,
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
                                dateDeailsCtl.text =
                                    DateFormat.yMMMd().format(date);
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
                              dateDeailsCtl.text =
                                  DateFormat.yMMMd().format(date);
                            }
                          })
                    ],
                  ),
                ),
                //aditional info
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    focusNode: aditionalInfoDeailsFocus,
                    controller: addtionalInfoDeailsController,
                    onSaved: (newValue) {
                      addtionalInfoDeailsController = newValue;
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
                            setState(() {
                              detailAddImage.add(file.path);
                              print(detailAddImage);
                            });
                          }
                        } else {
                          FilePickerResult result =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png'],
                          );

                          if (result != null) {
                            List<String> filesPath = result.paths;
                            List<File> files =
                                result.paths.map((path) => File(path)).toList();
                            setState(() {
                              detailAddImage.addAll(filesPath);
                            });
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
                    itemCount: detailAddImage != [] ? detailAddImage.length : 0,
                    itemBuilder: (context, index) {
                      //Asset asset = images[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Image.file(File(detailAddImage[index].trim())),
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
                                        detailAddImage.removeAt(index);
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
                          if (_pickedImageDeails == null) {
                            return showSnackBar('please Add profile image');
                          }
                          if (firstNameDeailsController.text == '') {
                            return showSnackBar('please enter first name');
                          }
                          if (lastNameDeailsController.text == '') {
                            return showSnackBar('please enter last name');
                          }
                          if (emailDeailsController.text == '' ||
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(emailDeailsController.text) ==
                                  false) {
                            return showSnackBar('please enter proper email');
                          }
                          if (dateDeailsCtl.text == '') {
                            return showSnackBar('please select birth date');
                          }

                          writeData(_selectedQualification).then((value) {
                            firstNameDeailsController.clear();
                            lastNameDeailsController.clear();
                            emailDeailsController.clear();
                            addtionalInfoDeailsController.clear();
                            dateDeailsCtl.clear();
                            detailAddImage.clear();
                            _pickedImageDeails = null;
                            setState(() {});
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => FormScreen()));
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Center(
                            child: Text(
                              'Update Details',
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => FormScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Center(
                            child: Text(
                              'Ok',
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
