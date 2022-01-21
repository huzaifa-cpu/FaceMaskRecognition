import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mask_recognition_app/main.dart';
import 'package:mask_recognition_app/widgets/detection_widget.dart';
import 'package:tflite/tflite.dart';

class Detection extends StatefulWidget {
  @override
  _DetectionState createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {
  CameraImage cameraImage;
  CameraController cameraController;
  bool isLoading = true;
  bool mask = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCamera();
      loadModel();
      isLoading = false;
    });
  }

  // ---------------------------------------------
  loadCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController.startImageStream((image) {
            cameraImage = image;
            runModel();
          });
        });
      }
    });
  }

  List<dynamic> _prediction;

  runModel() async {
    if (cameraImage != null) {
      await Tflite.runModelOnFrame(
        bytesList: cameraImage.planes.map((e) {
          return e.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.7,
        asynch: true,
      ).then((List<dynamic> recognitions) {
        // String _label = recognitions[0]['label'] as String;
        setState(() {
          _prediction = recognitions;
        });
        // if (_label == '1 Mask') {
        //   double _confidence = recognitions[0]['confidence'] as double;
        //   setState(() {
        //     _prediction = [
        //       {'label': '1 Mask', 'confidence': _confidence}
        //     ];
        //   });
        // } else {
        //   double _confidence = recognitions[0]['confidence'] as double;
        //   setState(() {
        //     _prediction = [
        //       {'label': '0 NoMask', 'confidence': _confidence}
        //     ];
        //   });
        // }
      });
    }
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  // -----------------------------
  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = cameraController.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    if (newDescription != null) {
      _initCamera(newDescription);
    } else {
      print('Asked camera not available');
    }
  }

  // init camera
  Future<void> _initCamera(CameraDescription description) async {
    cameraController = CameraController(description, ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController.startImageStream((image) {
            cameraImage = image;
            runModel();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //THEME
    var theme = Theme.of(context);
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.primaryColorLight,
              child: Icon(Icons.flip_camera_ios_outlined),
              onPressed: () {
                _toggleCameraLens();
              },
            ),
            body: Stack(
              children: <Widget>[
                !cameraController.value.isInitialized
                    ? Container()
                    : Container(
                        height: height,
                        width: width,
                        child: AspectRatio(
                          aspectRatio: cameraController.value.aspectRatio,
                          child: CameraPreview(cameraController),
                        ),
                      ),
                DetectionWidget(
                  entities: _prediction,
                )
              ],
            ),
          );
  }
}
