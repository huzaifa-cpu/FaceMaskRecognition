import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Classification extends StatefulWidget {
  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadModel();
    });
  }

  //-------------------------------------
  final imagePicker = ImagePicker();
  File imageFile;
  List _predictions = [''];
  //-------------------------------------------
  //GALLERY
  Future<void> _getImageFromGallery() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(image.path);
    });
    detectImage(imageFile);
  }

  //CAMERA
  Future<void> _getImageFromCamera() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(image.path);
    });
    detectImage(imageFile);
  }

  //-------------------------------------------
  detectImage(File image) async {
    var prediction = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2,
      threshold: 0.6,
    );
    setState(() {
      _predictions = prediction;
    });
  }

  //-------------------------------------------
  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  //-------------------------------------------
  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //THEME
    var theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Fltbtn2",
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.primaryColorLight,
            child: Icon(Icons.camera_alt),
            onPressed: _getImageFromCamera,
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: "Fltbtn1",
            backgroundColor: theme.primaryColor,
            foregroundColor: theme.primaryColorLight,
            child: Icon(Icons.photo),
            onPressed: _getImageFromGallery,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: height * 0.45,
                width: width,
                child: imageFile == null
                    ? Text(
                        "No image",
                        style:
                            TextStyle(fontSize: 15, color: theme.primaryColor),
                      )
                    : Text(""),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.primaryColorDark, width: 5),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: imageFile != null
                            ? FileImage(imageFile)
                            : AssetImage(''))),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Text(
                'Prediction',
                style: TextStyle(fontSize: 13, color: theme.primaryColorDark),
              ),
              Container(
                alignment: Alignment.center,
                height: height * 0.07,
                width: width * 0.5,
                child: Text(
                  _predictions[0].toString() == ''
                      ? ''
                      : _predictions[0]['label'].toString().substring(1),
                  style: TextStyle(fontSize: 30, color: theme.primaryColorDark),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.primaryColorDark, width: 2),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                height: height * 0.06,
                width: width * 0.7,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Reset",
                      style: TextStyle(
                          fontSize: 15, color: theme.primaryColorLight),
                    ),
                    color: theme.primaryColorDark,
                    onPressed: () {
                      setState(() {
                        imageFile = null;
                        _predictions = [''];
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
