import 'package:flutter/material.dart';
import 'package:warungapp/data/endpoint.dart';
import 'package:warungapp/models/Warung.dart';
import 'package:warungapp/services/warung_service.dart';
import 'package:warungapp/ui/pages/warung/getWarung.dart';

class ListWarungPage extends StatefulWidget {
  @override
  _ListWarungPageState createState() => _ListWarungPageState();
}

class _ListWarungPageState extends State<ListWarungPage> {
  bool _isLoading = false;
  List<Warung> _warungs = [];
  List<WarungPhoto> _photos = [];
  final url = BASE_URL_DEV;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataWarungs();
  }

  getDataWarungs() async {
    setState(() {
      _isLoading = true;
    });    
    final result = await getWarungs();
    setState(() {
      _warungs = result;
      print(_warungs);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: TextField(
            autofocus: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Cari'
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
              shrinkWrap: true,
              itemCount: _warungs.length,
              itemBuilder: (BuildContext context, int index) {
                _photos = _warungs[index].photos;
                print(_photos);
                return Card(
                  child: ListTile(
                    leading: _photos.length > 0 ? Image.network(UPLOAD+'/'+_photos[0].path, fit: BoxFit.fitWidth, alignment: FractionalOffset.center) : Text('gambar'),
                    title: Text(_warungs[index].name), 
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GetWarungPage(warungId: _warungs[index].id)));
                    },
                    trailing: Icon(Icons.menu),
                  )
                );                
              }
            )  
          )
        )
      ),
    );
  }
}