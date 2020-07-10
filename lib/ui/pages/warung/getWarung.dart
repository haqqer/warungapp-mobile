import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:warungapp/data/endpoint.dart';
import 'package:warungapp/models/Comment.dart';
import 'package:warungapp/models/Food.dart';
import 'package:warungapp/models/Warung.dart';
import 'package:warungapp/services/comment_service.dart';
import 'package:warungapp/services/warung_service.dart';
import 'package:warungapp/ui/pages/food/createFood.dart';

class GetWarungPage extends StatefulWidget {
  final int warungId;
  GetWarungPage({ this.warungId });
  @override
  _GetWarungPageState createState() => _GetWarungPageState();
}

class _GetWarungPageState extends State<GetWarungPage> {
  Warung warung;
  Comment comment;
  List<WarungPhoto> _photos = [];
  TextEditingController commentController = TextEditingController();
  int _rating = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataWarung();
  }

  getDataWarung() async {
    final result = await getWarungById(widget.warungId);
    setState(() {
      warung = result;
      _photos = warung.photos;
    });
  }

  sendComment(String userComment, int score,) async {
    comment = Comment(warungId: widget.warungId, comment: userComment, score: score);
    final result = await postComment(comment);
    print(result);
    getDataWarung();
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetWarungPage(warungId: widget.warungId)), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // List<Food> _foods = widget.warung.foods;

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: warung == null ? Center(child: CircularProgressIndicator()) : Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Stack(
                  alignment: Alignment.topLeft,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        child: _photos.length > 0 ? Image.network(UPLOAD +'/'+_photos[0].path, fit: BoxFit.fitWidth, alignment: FractionalOffset.center) : Text('gambar Kosong'),
                      ),
                      IconButton(icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 30), onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/warung', (route) => false))
                    ],
                  )
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(warung.name, style: Theme.of(context).textTheme.headline5),
                      SizedBox(height: 8),
                      RatingBar(
                        initialRating: warung.average != null ? warung.average : 0,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating.toInt();
                          });
                        },                                  
                      ),
                      SizedBox(height: 16.0),
                      TabBar(
                        indicatorColor: Colors.black54,
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
                            ListView(
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.description),
                                  title: Text(warung.description),
                                ),
                                ListTile(
                                  leading: Icon(Icons.place),
                                  title: Text(warung.address),
                                ),
                              ],
                            ),
                            warung.foods.length > 0 ? ListView.builder(
                              itemCount: warung.foods.length,
                              itemBuilder: (context, index) {
                                print(UPLOAD+'/'+warung.foods[index].photos[0].path);
                                return Card(
                                  elevation: 1,
                                  child: Container(
                                    height: 75,
                                    padding: EdgeInsets.all(8.0),                                    
                                    child: Row(
                                      children: <Widget>[
                                        // Image.network(UPLOAD+'/'+warung.foods[index].photos[0].path, width: 20),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: warung.photos.length > 0  ? Image.network(
                                            UPLOAD+'/'+warung.foods[index].photos[0].path,
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
                                              Text(warung.foods[index].name, style: Theme.of(context).textTheme.subtitle2),
                                              SizedBox(height: 8),
                                              Text(warung.foods[index].price.toString(), style: Theme.of(context).textTheme.bodyText2),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ) :  Text('Kosong'),
                            Column(
                              children: <Widget>[
                                RatingBar(
                                  initialRating: _rating.toDouble(),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _rating = rating.toInt();
                                    });
                                  },                                  
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 9,
                                      child: TextField(
                                        controller: commentController,
                                        decoration: InputDecoration(
                                          hintText: 'Comment'
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(icon: Icon(Icons.send), onPressed: () {
                                        sendComment(commentController.text, _rating);
                                        commentController.text = '';
                                        _rating = 0;
                                      }))
                                  ],
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 175,
                                  child: warung.comments.length > 0 ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: warung.comments.length,
                                      itemBuilder: (context, index) {
                                        return Card(                                 
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            width: MediaQuery.of(context).size.width,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                RatingBar(
                                                  itemSize: 16.0,
                                                  initialRating: warung.comments[index].score.toDouble(),
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (context, _) => Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                    // setState(() {
                                                    //   _rating = rating.toInt();
                                                    // });
                                                  },                                  
                                                ),
                                                SizedBox(height: 5),
                                                Text(warung.comments[index].comment),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ) :  Text('Kosong'),
                                ),
                              ],
                            )
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