import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:warungapp_mobile/ui/pages/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  signIn(String email, String pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': pass
    };

    var jsonResponse = null;
    String url = sharedPreferences.getString('url')+'/api/auth/login';
    var response = await http.post(url, body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response : ${jsonResponse}');
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['result']['access_token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 160,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Image.asset('assets/icon/warungapp.png', height: 80),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      child: Text('Login'),
                      onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
                        setState(() {
                          _isLoading = true;
                        });
                        signIn(emailController.text, passwordController.text);
                      }
                    )
                  ],
                )
              ],
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height - 250,
            //   color: Theme.of(context).primaryColor,
            //   width: double.infinity,               
            // ),
          ],
        ),
      )
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 150);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    // path.close();
    return path;    
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}