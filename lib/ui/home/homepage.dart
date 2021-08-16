import 'package:flutter/material.dart';
import 'package:movies_record/data/db/database_helper.dart';
import 'package:movies_record/ui/add_movie/add_movie.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  var start = 0;
  static const int limit = 3;
  List<Map<String, dynamic>> movies = [];
  final PagingController<int, Map<String, dynamic>> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    /*Future.delayed(Duration.zero).then((value) {
      getMovies();
    });*/
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await dbHelper.getMovies(start: pageKey, limit: limit);
      final isLastPage = newItems.length < limit;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  /*getMovies() async {
    var result = await dbHelper.getMovies(start: start, limit: limit);
    if (result.length > 0) {
      setState(() {
        movies.addAll(result);
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Movies"),
        ),
        floatingActionButton: CircleAvatar(
          backgroundColor: Colors.black54,
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return AddMovie();
              }));
              if (result != null) {
                if (result is bool && result == true && movies.length == 0) {
                  //getMovies();
                  _pagingController.refresh();
                }
              }
            },
          ),
        ),
        body: Container(
            child: PagedListView<int, Map<String, dynamic>>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
              itemBuilder: (context, item, index) {
            return Column(
              children: <Widget>[
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.none,
                    child: Container(
                      height: 200,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.file(
                          File(item[DatabaseHelper.columnPoster]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                Text(
                  item[DatabaseHelper.columnMovieName],
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                RichText(
                    text: TextSpan(
                        text: "Directed by: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        children: <TextSpan>[
                      TextSpan(
                          text: item[DatabaseHelper.columnDirector],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black54,
                          ))
                    ])),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var result = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddMovie(
                            movie: item,
                          );
                        }));
                        if (result != null &&
                            result is bool &&
                            result == true) {
                          _pagingController.refresh();
                        }
                      },
                      child: Text(
                        "Edit",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        child: Text("|")),
                    GestureDetector(
                      onTap: () {
                        dbHelper.delete(item[DatabaseHelper.columnId]);
                        _pagingController.refresh();
                      },
                      child:
                          Text("Delete", style: TextStyle(color: Colors.blue)),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                )
              ],
            );
          }, noItemsFoundIndicatorBuilder: (context) {
            return Center(
              child: Text("No data found"),
            );
          }),
        )));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
