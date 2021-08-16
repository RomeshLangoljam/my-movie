import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movies_record/data/db/database_helper.dart';
import 'package:movies_record/data/model/movie.dart';
import 'package:movies_record/ui/widgets/form_field_with_label.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:path_provider/path_provider.dart';

class AddMovie extends StatefulWidget {
  Map<String, dynamic>? movie;

  AddMovie({Key? key, this.movie}) : super(key: key);

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  TextEditingController _movieNameController = TextEditingController();
  TextEditingController _directorController = TextEditingController();

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      if (widget.movie != null) {
        setState(() {
          _movieNameController.text =
          widget.movie![DatabaseHelper.columnMovieName];
          _directorController.text = widget.movie![DatabaseHelper.columnDirector];
          _imagePath = widget.movie![DatabaseHelper.columnPoster];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? "Add Movie" : "Edit Movie"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormFieldWithLabel(
                  label: "Movie Name",
                  controller: _movieNameController,
                ),
                SizedBox(
                  height: 8,
                ),
                FormFieldWithLabel(
                  label: "Director",
                  controller: _directorController,
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: 100,
                  height: 150,
                  color: Colors.grey.shade50,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.none,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: _imagePath == null
                          ? IconButton(
                              onPressed: () async {
                                var result = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (result != null) {
                                  var directory =
                                      await getApplicationDocumentsDirectory();
                                  String path = directory.path;
                                  var imageFile = File(result.path);
                                  final File newImage = await imageFile.copy(
                                      '$path/${DateTime.now().microsecond.toString()}.png');
                                  setState(() {
                                    _imagePath = newImage.path;
                                  });
                                }
                              },
                              icon: Icon(Icons.add))
                          : Image.file(
                              File(_imagePath!),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      if (validate()) {
                        if (widget.movie == null) {
                          Map<String, dynamic> row = {
                            DatabaseHelper.columnMovieName:
                            _movieNameController.text.toString(),
                            DatabaseHelper.columnDirector:
                            _directorController.text.toString(),
                            DatabaseHelper.columnPoster: _imagePath
                          };
                          var id = await dbHelper.insertMovies(row);
                          showToast("Movie inserted!");
                          if (id != null) {
                            setState(() {
                              _imagePath = null;
                              _directorController.text = "";
                              _movieNameController.text = "";
                            });
                          }
                          Navigator.pop(context, true);
                          print("inserted $id");
                        }
                        else {
                          Map<String, dynamic> row = {
                            DatabaseHelper.columnMovieName:
                            _movieNameController.text.toString(),
                            DatabaseHelper.columnDirector:
                            _directorController.text.toString(),
                            DatabaseHelper.columnPoster: _imagePath,
                            DatabaseHelper.columnId: widget.movie![DatabaseHelper.columnId]
                          };
                          var id = dbHelper.update(row);
                          showToast("Movie updated!");
                          if (id != null) {
                            setState(() {
                              _imagePath = null;
                              _directorController.text = "";
                              _movieNameController.text = "";
                            });
                          }
                          Navigator.pop(context, true);
                        }
                      }
                    },
                    child: Text(
                        widget.movie == null ? "Add Movie" : "Update Movie"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (_movieNameController.text.isEmpty) {
      showToast("Movie name can't be empty");
      return false;
    } else if (_directorController.text.isEmpty) {
      showToast("Director name can't be empty");
      return false;
    } else if ((_imagePath ?? "").isEmpty) {
      showToast("Upload a movie poster");
      return false;
    }
    return true;
  }

  showToast(String text) {
    Fluttertoast.showToast(
        msg: "$text",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
