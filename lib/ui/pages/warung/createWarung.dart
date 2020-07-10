import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:warungapp/models/Warung.dart';
import 'package:warungapp/provider/provider_auth.dart';
import 'package:warungapp/services/geo_service.dart';
import 'package:warungapp/services/warung_service.dart';

class CreateWarungPage extends StatefulWidget {
  final String address;
  CreateWarungPage({ this.address });
  @override
  _CreateWarungPageState createState() => _CreateWarungPageState();
}

class _CreateWarungPageState extends State<CreateWarungPage> {
  Position currentPosition;
  ProviderAuth state;
  final imagePicker = ImagePicker();
  List<File> imageFile = [];
  Warung warung;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController descController = new TextEditingController();  
  final TextEditingController addressController = new TextEditingController();

  getCurrentLocation() async {
    final myLocation = await getMyLocation();
    setState(() {
      currentPosition = myLocation;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressController.text = widget.address;
    // getCurrentLocation();
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

  sendData(String name, String desc, String address, LatLng coordinat) async {
    warung = Warung(name: name, description: desc, address: address, latitude: coordinat.latitude, longitude: coordinat.longitude);
    final result = await postWarung(warung, imageFile);
    if(result['error'] == true) {
      print('error');
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    state = Provider.of<ProviderAuth>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Warung'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    _showChoiceDialog(context);
                  },
                  child: imageFile.length != 0 ? Image.file(File(imageFile[0].path), fit: BoxFit.fitWidth, alignment: FractionalOffset.center) :  Icon(Icons.camera_alt, size: 48)
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Nama Warung',
                  labelText: 'Nama Warung'
                ),
              ),
              TextField(
                maxLines: 3,
                controller: descController,
                decoration: InputDecoration(
                  hintText: 'Deskripsi Warung',
                  labelText: 'Deskripsi Warung'
                ),
              ),
              TextField(
                maxLines: 3,
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Alamat Warung',
                  labelText: 'Alamat Warung'
                ),
              ),
              RaisedButton(
                
                child: Text('Create'), 
                onPressed: () {
                  sendData(nameController.text, descController.text, addressController.text, state.getPosition);
                }
              ),
              // Container(
              //   child: RaisedButton(child: Text('tambah lokasi'), onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => GetWarungLocationPage()));
              //   }),
              // )
            ],
          ),
        ),
    );
  }
}