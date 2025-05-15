import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<SettingPage> {
  final TextEditingController ipController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController databaseController = TextEditingController();

  final FocusNode ipFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode databaseFocusNode = FocusNode();

  void clearInputs() {
    ipController.clear();
    usernameController.clear();
    passwordController.clear();
    databaseController.clear();
    FocusScope.of(context).requestFocus(ipFocusNode); // Refocus on IP field
  }

  @override
  void dispose() {
    ipFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    databaseFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
        ),
        child: const Text(
          "Manage Database",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: ipController,
            focusNode: ipFocusNode,
            textInputAction:
                TextInputAction.next, // Show "Next" button on keyboard
            decoration: const InputDecoration(
              labelText: "IP Address",
              border: OutlineInputBorder(),
            ),
            onEditingComplete: () => usernameFocusNode.requestFocus(),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: usernameController,
            focusNode: usernameFocusNode,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(),
            ),
            onEditingComplete:
                () => FocusScope.of(context).requestFocus(passwordFocusNode),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            obscureText: true,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            onEditingComplete:
                () => FocusScope.of(context).requestFocus(databaseFocusNode),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: databaseController,
            focusNode: databaseFocusNode,
            textInputAction: TextInputAction.done, // Show "Done" on keyboard
            decoration: const InputDecoration(
              labelText: "Database",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text("Confirm"),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton(
                onPressed: clearInputs,
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
