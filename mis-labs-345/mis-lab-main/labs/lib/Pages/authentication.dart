import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

import '../Models/user.dart';
import '../Widgets/adaptive_flat_button.dart';


class AuthenticationPage extends StatefulWidget {
  final Function addItem;


  const AuthenticationPage({Key? key, required this.addItem}): super(key: key);

  @override
  State<StatefulWidget> createState() => AuthenticationPageState();
}

class AuthenticationPageState extends State<AuthenticationPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _validate(String? username, String? password) {
    if (username == null || username.isEmpty) {
      return false;
    }

    if (password == null || password.isEmpty) {
      return false;
    }

    return true;
  }

  void _submitData() {
    if (_validate(_usernameController.text, _passwordController.text)) {
      User newUser = User(id: nanoid(5), username: _usernameController.text,password: _passwordController.text, listItems: []);
      bool result = widget.addItem(newUser);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You Registered successfully"),
          duration: Duration(seconds: 3),
        ));
        Navigator.of(context).pop();

      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to register!"),
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("User Registration"),
        ),
        body: Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: "Username",),
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: "Password"),
            keyboardType: TextInputType.datetime,
            onSubmitted: (_) => _submitData(),
          ),
          AdaptiveFlatButton("Register", _submitData)
        ],
      ),
    ));
  }
}