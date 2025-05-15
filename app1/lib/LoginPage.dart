import 'package:app1/Drawer_Menu.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool eyeobs = true;

  void showpassword() {
    setState(() {
      eyeobs = !eyeobs;
    });
  }

  Widget Loco() {
    return Image.asset(
      "images/loco.png",
      fit: BoxFit.cover,
      width: 170,
      height: 170,
    );
  }

  Widget TextShop() {
    return Text(
      'Mantra Shop',
      style: TextStyle(
        color: const Color.fromARGB(255, 7, 39, 65),
        fontSize: 40,
        fontWeight: FontWeight.bold,
        fontFamily: "SourceCodePro",
      ),
    );
  }

  Widget LoginText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.person,
            color: const Color.fromARGB(255, 7, 39, 65),
            size: 25,
          ),
          labelText: 'Username',
        ),
      ),
    );
  }

  Widget PasswordText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        obscureText: eyeobs,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.lock,
            color: const Color.fromARGB(255, 7, 39, 65),
            size: 25,
          ),
          labelText: 'Password',
          suffixIcon: IconButton(
            onPressed: () {
              showpassword();
            },
            icon: Icon(
              eyeobs ? Icons.visibility_off : Icons.visibility,
              color: const Color.fromARGB(255, 7, 39, 65),
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget LoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          MaterialPageRoute route = MaterialPageRoute(
            builder: (c) => Drawer_Menu(),
          );
          Navigator.of(context).push(route);
        },
        child: Text(
          'Log In',
          style: TextStyle(
            color: const Color.fromARGB(255, 7, 39, 65),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget SignUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        ),
        onPressed: () {},
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: const Color.fromARGB(255, 7, 39, 65),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [LoginButton(), SizedBox(width: 10), SignUpButton()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, const Color.fromARGB(255, 101, 59, 131)],
            radius: 1.0,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Loco(),
              SizedBox(height: 20),
              TextShop(),
              SizedBox(height: 20),
              LoginText(),
              SizedBox(height: 20),
              PasswordText(),
              SizedBox(height: 20),
              showButton(),
            ],
          ),
        ),
      ),
    );
  }
}
