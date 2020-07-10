import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:warungapp/models/Food.dart';
import 'package:warungapp/models/Warung.dart';
import 'package:warungapp/provider/provider_auth.dart';
import 'package:warungapp/services/food_service.dart';
import 'package:warungapp/ui/pages/warung/getWarung.dart';

class CreateFoodPage extends StatefulWidget {
  final Warung warung;
  CreateFoodPage({ this.warung });
  @override
  _CreateFoodPageState createState() => _CreateFoodPageState();
}

class _CreateFoodPageState extends State<CreateFoodPage> {
  ProviderAuth state;
  final imagePicker = ImagePicker();
  List<File> imageFile = [];
  Food food;
  String dropdownValue = 'Makanan';

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController descController = new TextEditingController();  
  final TextEditingController priceController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  sendData(int warungId, String name, String desc, String type, int price) async {
    food = Food(warungId: warungId, name: name, description: desc, type: type, price: price);
    final result = await postFood(food, imageFile);
    if(result['error'] == true) {
      print('error');
    } else {
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetWarungPage(warungId: widget.warung.id)), (route) => false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    state = Provider.of<ProviderAuth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Food'),
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
                  hintText: 'Nama',
                  labelText: 'Nama'
                ),
              ),
              TextField(
                maxLines: 3,
                controller: descController,
                decoration: InputDecoration(
                  hintText: 'Deskripsi',
                  labelText: 'Deskripsi'
                ),
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value;
                  });
                },
                items: <String>['Makanan', 'Minuman'].map<DropdownMenuItem<String>>((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: InputDecoration(
                  hintText: 'Harga',
                  labelText: 'Harga'
                ),
              ),              
              RaisedButton(
                child: Text('Create'), 
                onPressed: () {
                  sendData(widget.warung.id, nameController.text, descController.text, dropdownValue, int.parse(priceController.text));
                }
              ),
            ],
          ),
        ),
    );
  }
}