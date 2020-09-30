import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormTextFormField extends StatefulWidget {
  FormTextFormField({
    Key key,
    @required this.controller,
    this.focus,
    @required this.name,
    this.focusnode,
  }) : super(key: key);

  var controller;
  final focusnode;
  final focus;
  final String name;
  @override
  _FormTextFormFieldState createState() => _FormTextFormFieldState();
}

class _FormTextFormFieldState extends State<FormTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusnode,
        onSaved: (newValue) {
          widget.controller = newValue;
        },
        validator: (value) {
          if (widget.name == "Email") {
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(widget.controller.text);

            if (emailValid == false) {
              return "Please enter proper email address";
            }
          } else if (value.isEmpty) {
            return "Please enter ${widget.name}";
          }
        },
        onFieldSubmitted: (value) {
          if (widget.focus == null) {
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            FocusScope.of(context).requestFocus(widget.focus);
          }
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: widget.name.toString(),
            labelStyle: TextStyle(fontSize: 20.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0), gapPadding: 10.0)),
      ),
    );
  }
}
