import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

import '../Models/user.dart';
import '../Widgets/adaptive_flat_button.dart';


class LoginPage extends StatefulWidget {
  final Function login;


  const LoginPage({Key? key, required this.login}): super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
      bool result = widget.login(_usernameController.text, _passwordController.text);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You logged in successfully"),
          duration: Duration(seconds: 3),
        ));
        Navigator.of(context).pop();

      } else {
        // // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //   content: Text("Failed to login!"),
        //   duration: Duration(seconds: 3),
        // //)
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Login User"),
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
          AdaptiveFlatButton("Login", _submitData)
        ],
      ),
    ));
  }
}