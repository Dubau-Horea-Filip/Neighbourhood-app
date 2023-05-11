// ignore_for_file: implementation_imports, file_names
import 'package:neighborhood_app/Widgets/text_box.dart';
import 'package:flutter/material.dart';

class ChangePaswordPage extends StatefulWidget {
  const ChangePaswordPage({super.key});

  @override
  State<ChangePaswordPage> createState() => _ChangePaswordPageState();
}

class _ChangePaswordPageState extends State<ChangePaswordPage> {
  late TextEditingController controllerOldPassword;
  late TextEditingController controllerPassword;
  late TextEditingController controllerPassword2;

  @override
  void initState() {
    controllerOldPassword = TextEditingController();
    controllerPassword = TextEditingController();
    controllerPassword2 = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 26, 26),
        title: const Text("change password"),
      ),
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      body: Center(
        child: ListView(
          children: [
            TextBox(controllerOldPassword, "Old Password"),
            TextBox(controllerPassword, "Enter new password"),
            TextBox(controllerPassword2, "Repete new password"),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () {
                    String name = controllerOldPassword.text;
                    String pass = controllerPassword.text;
                    String pass2 = controllerPassword2.text;
                    if (name.isNotEmpty && pass.isNotEmpty) {
                      if (pass == pass2) {
                        changePassword(context, name, pass);
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
                  child: const Text("update password")),
            )
          ],
        ),
      ),
    );
  }

  changePassword(BuildContext context, n, p) {
    //Navigator.pop(context);
    const oldpasword = "123"; //api call to check password
    if (n != oldpasword) {
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                //title: Text("opa"),
                content: const Text("Password Changed"),
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
  }
}
