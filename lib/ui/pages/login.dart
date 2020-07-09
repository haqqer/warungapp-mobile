import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:warungapp/services/login_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  login(String email, String pass) async {
    final result = await signIn(email, pass);
    if(result) {
      setState(() {
        _isLoading = false;        
      });
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      debugPrint('gagal ambil token');
    }
  }

  // getUser() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String url = sharedPreferences.getString('url')+'/api/auth/me';
  //   String token = sharedPreferences.getString('token');
  //   var jsonResponse = null;
  //   var response = await http.get(url, headers: {
  //     'Authorization': 'Bearer $token'
  //   });
  //   if(response.statusCode == 200) {
  //     jsonResponse = json.decode(response.body)['user'];
  //     sharedPreferences.setString('user_id', jsonResponse['id'].toString());
  //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     print(response.body);
  //   }
  //   // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      color: Colors.blue,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
                      SizedBox(height: 30),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)
                        ),
                        color: Colors.white,
                        child: Text('Login', style: TextStyle(fontSize: 18.0)),
                        onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
                          setState(() {
                            _isLoading = true;
                          });
                          login(emailController.text, passwordController.text);
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
      ),
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