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
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataWarungs();
  }

  getDataWarungs([String name]) async {
    setState(() {
      _isLoading = true;
    });    
    final result = await getWarungsFilter(name);
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                child: Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(icon: Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 30), onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      child: TextField(
                        autofocus: true,
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.black26,
                          hintText: 'Cari'
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(icon: Icon(Icons.search, color: Colors.black, size: 25), onPressed: () {
                        // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        getDataWarungs(searchController.text);
                      }),
                    ),
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 8.0),
                height: MediaQuery.of(context).size.height,
                child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _warungs.length,
                  itemBuilder: (BuildContext context, int index) {
                    _photos = _warungs[index].photos;
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetWarungPage(warungId: _warungs[index].id)), (route) => false);
                      },
                      child: Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: _warungs[index].photos.length > 0  ? Image.network(
                                  UPLOAD+'/'+_warungs[index].photos[0].path,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  height: MediaQuery.of(context).size.width * 0.2,
                                  fit: BoxFit.fill, alignment: FractionalOffset.center
                                ) : Icon(Icons.camera_alt, size: MediaQuery.of(context).size.width * 0.2),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_warungs[index].name, style: Theme.of(context).textTheme.subtitle2),
                                    SizedBox(height: 8),
                                    Text(_warungs[index].description, style: Theme.of(context).textTheme.bodyText2),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                )  
              ),
            ],
          )
        )
      ),
    );
  }
}