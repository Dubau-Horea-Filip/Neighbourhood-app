// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neighborhood_app/Widgets/text_box.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController controllerName;
  late TextEditingController controllerEmail;
  late TextEditingController controllerPassword;
  late TextEditingController controllerPassword2;

  @override
  void initState() {
    controllerName = TextEditingController();
    controllerEmail = TextEditingController();
    controllerPassword = TextEditingController();
    controllerPassword2 = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(255, 104, 26, 26),
        title: const Text("sign up"),
      ),
      //backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      body: Center(
        child: ListView(
          children: [
            TextBox(controllerName, "Name"),
            TextBox(controllerEmail, "Email"),
            TextBox(controllerPassword, "password"),
            TextBox(controllerPassword2, "password2"),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () async {
                    String name = controllerName.text;
                    String email = controllerEmail.text;
                    String pass = controllerPassword.text;
                    String pass2 = controllerPassword2.text;
                    if (name.isNotEmpty &&
                        pass.isNotEmpty &&
                        email.isNotEmpty &&
                        pass2.isNotEmpty) {
                      if (await ceckIFExist(email)) {
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                                  content: Text(
                                      "User with this Email already Exists"),
                                ));
                      } else if (pass == pass2) {
                        sign_up(context, name, pass, email);
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                                  //title: Text("opa"),
                                  content: Text("Password Should match"),
                                ));
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                //title: Text("opa"),
                                content: Text("All filds shoud be filled"),
                              ));
                    }
                  },
                  child: const Text("create account")),
            )
          ],
        ),
      ),
    );
  }

  sign_up(BuildContext context, n, p, String email) {
    //Navigator.pop(context);
    addUser(n, email, p);
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              //title: Text("opa"),
              content: const Text("Account Created"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Text("ok", style: TextStyle(color: Colors.red)))
              ],
            ));
  }

  void addUser(String name, String email, String password) async {
    const url = 'http://localhost:8080/api/friends/add';
    final headers = <String, String>{'Content-Type': 'application/json'};
    final body = json.encode(<String, String>{
      'name': name,
      'email': email,
      'password': password,
    });
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
    }
  }

  Future<bool> ceckIFExist(String email) async {
    const url = 'http://localhost:8080/api/friends/userL';
    final uri = Uri.parse(url).replace(queryParameters: {'UserEmail': email});
    final response = await http.get(uri);
    final body = response.body;
    if (body.isNotEmpty && response.statusCode == 200) {
      return true;
    }
    return false; // not exists
  }
}
