import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pembangunan/ui/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pembangunan/ui/pages/login.dart';
import 'package:http/http.dart' as http;

class PembangunanPage extends StatefulWidget {
  @override
  _PembangunanPageState createState() => _PembangunanPageState();
}

class _PembangunanPageState extends State<PembangunanPage> {
  SharedPreferences sharedPreferences;
  Position _position;
  bool _isLoading = false;

  final TextEditingController ketController = new TextEditingController();
  int choice = 2;
  // final TextEditingController passwordController = new TextEditingController();
  final imagePicker = ImagePicker();
  List<File> imageFile = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getCurrentLocation();
    checkLoginStatus();
    // _initializeCamera();
  }

  _openGallery(BuildContext context) async {
    try {
      final pictures = await imagePicker.getImage(source: ImageSource.gallery);
      setState(() {
        print(pictures.path);
        imageFile.add(File((pictures.path)));
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  _openCamera(BuildContext context) async {
    try {
      final pictures = await imagePicker.getImage(source: ImageSource.camera, maxHeight: 640, maxWidth: 480);
      print(pictures.path);
      setState(() {
        print(pictures.path);
        imageFile.add(File((pictures.path)));
      });
      // imageFile.add(File((pictures.path)));
      print('camera');
      print(imageFile);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      Navigator.of(context).pop();    
    }
  }


  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Gallery'),
                onTap: () {
                  _openGallery(context);
                },
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                child: Text('Camera'),
                onTap: () {
                  _openCamera(context);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    final myLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _position = myLocation;
    });
    print(_position);
  }
  
  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('url', 'http://192.168.1.38:8000');
    print('user id');
    print(sharedPreferences.getString('user_id'));
    if(!(await checkExpired())) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()) , (route) => false);
    }
    if(sharedPreferences.getString('token') == null ) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()) , (route) => false);
    }
  }

  sendData(int choice, String desc, Position position) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var jsonResponse = {};
    String url = sharedPreferences.getString('url')+'/api/pembangunan';
    String token = sharedPreferences.getString('token');
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      'Authorization': 'Bearer $token'
    });
    request.fields['pilihan'] = choice.toString();
    request.fields['keterangan'] = desc.toString();
    request.fields['coordinat'] = position.latitude.toString()+','+position.longitude.toString();
    for(var i=0; i<imageFile.length; i++) {
      request.files.add(await http.MultipartFile.fromPath('image[$i]', imageFile[i].path));
    }
    print(request.files);
    // var response = await http.post(url, body: data, headers: {
    //   'Authorization': 'Bearer $token'
    // });
    var response = await request.send();
    print(response.reasonPhrase);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.reasonPhrase);
      print('Response : ${jsonResponse}');
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<bool> checkExpired() async {    
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    String url = sharedPreferences.getString('url')+'/api/auth/me';
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token'
    });
    if(response.statusCode == 401) {
      print('Response ${response.body}');
      print('Expired token');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        title: Text('Survey Pembagunan'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              _showChoiceDialog(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            Container(
              height: 200,
              child: imageFile.length != 0 ? ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: imageFile.length,
                itemBuilder: (BuildContext context, int index) {
                  // return Text('hello world');
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Image.file(File(imageFile[index].path), fit: BoxFit.fitHeight),
                    ),
                  );
                  // return Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Image.file(File(imageFile[index].path), fit: BoxFit.fitWidth, width: 100),
                  // );
                }
              ) : Center(child: Text('Gambar Belum diupload')),
            ) ,
            // imageFile.length != 0 ?
            // Image.file(File(imageFile[0].path), height: 100)
            // Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       fit: BoxFit.fitWidth,
            //       alignment: FractionalOffset.topCenter,
            //       image: FileImage(File(imageFile[0].path))
            //     )
            //   ),
            // )
            // : Text('Gambar Belum diupload'),
            Text('Pilihan'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[                
                  RaisedButton(
                    onPressed: () {
                      print('ya');
                      setState(() {
                        choice = 1;
                      });
                    },
                    child: Icon(Icons.check, color: Colors.white),
                    color: choice != 1 ? Colors.green : Colors.green[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      print('tidak');
                      setState(() {
                        choice = 0;
                      });
                    },
                    child: Icon(Icons.close, color: Colors.white),
                    color: choice != 0 ? Colors.red : Colors.red[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  )
                ],
              ),
            ),             
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                maxLines: 5,
                controller: ketController,
                decoration: InputDecoration(
                  hintText: 'Keterangan',
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _position != null ? 
                  Text('Lat: ${_position.latitude.toString()}, Long: ${_position.longitude.toString()}', style: TextStyle(color: Colors.white)) : 
                  Icon(Icons.my_location, color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () {
                getCurrentLocation();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )
            ),
            SizedBox(height: 40),
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Simpan', style: TextStyle(color: Colors.white, fontSize: 20.0)),
              ),
              color: Colors.red,
              onPressed: () {
                sendData(choice, ketController.text, _position);
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )
            )
          ],
        ),
      ),
    );
  }
}