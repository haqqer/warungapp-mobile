import 'package:flutter/material.dart';
import 'package:warungapp/data/endpoint.dart';
import 'package:warungapp/models/Food.dart';
import 'package:warungapp/models/Warung.dart';
import 'package:warungapp/services/warung_service.dart';
import 'package:warungapp/ui/pages/food/createFood.dart';

class GetWarungPage extends StatefulWidget {
  final int warungId;
  GetWarungPage({ this.warungId });
  @override
  _GetWarungPageState createState() => _GetWarungPageState();
}

class _GetWarungPageState extends State<GetWarungPage> {
  Warung warung = Warung();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  getDataWarung() async {
    final result = await getWarungById(widget.warungId);
    setState(() {
      warung = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<WarungPhoto> _photos = warung.photos;
    // List<Food> _foods = widget.warung.foods;

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  child: Image.network(UPLOAD +'/'+_photos[0].path, fit: BoxFit.fitWidth, alignment: FractionalOffset.center),
                )
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                  child: Column(
                    children: <Widget>[
                      Text(warung.name, style: Theme.of(context).textTheme.headline5),
                      TabBar(
                        tabs: <Widget>[
                          Tab(child: Text('Ringkasan', style: TextStyle(color: Colors.black))),
                          Tab(child: Text('Menu', style: TextStyle(color: Colors.black))),
                          Tab(child: Text('Ulasan', style: TextStyle(color: Colors.black))),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(warung.description),
                                Text(warung.address),
                              ],
                            ),
                            // Text('ringkasan'),
                            warung.foods.length > 0 ? ListView.builder(
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(warung.foods[index].name),
                                );
                              },
                            ) :  Text('Kosong'),
                            Text('Ulasan')
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateFoodPage(warung: warung)));
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}