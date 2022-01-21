import 'package:flutter/material.dart';

class DetectionWidget extends StatefulWidget {
  final List<dynamic> _entities;
  final double threshold;

  const DetectionWidget({List<dynamic> entities, this.threshold = 0.5})
      : _entities = entities;

  @override
  State<StatefulWidget> createState() {
    return _DetectionWidgetState();
  }
}

class _DetectionWidgetState extends State<DetectionWidget> {
  String _label = "";
  double _confidence = 0;

  set label(String value) => setState(() {
        _label = value;
      });

  set confidence(double value) => setState(() {
        _confidence = value;
      });

  String get label => _label;

  double get confidence => _confidence;

  String _textDisplay(String label) {
    if (label == '1 Mask') {
      return "Mask ${((confidence) * 100).toStringAsFixed(0)}%";
    }
    return "NoMask ${((confidence) * 100).toStringAsFixed(0)}%";
  }

  Color _textStyleColor(String label) {
    if (label == '1 Mask') return Colors.green;
    return Colors.red;
  }

  Color _changeBorderColor(
    BuildContext context,
    List<dynamic> divisions,
  ) {
    if (divisions == null) {
      return Colors.transparent;
    }

    if (divisions.length == 1) {
      _label = divisions[0]['label'] as String;
      _confidence = divisions[0]['confidence'] as double;
    }

    if (confidence < widget.threshold) {
      return Colors.transparent;
    }

    if (label == '0 NoMask') {
      return Colors.red;
    }

    if (label == '1 Mask') {
      return Colors.green;
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //THEME
    var theme = Theme.of(context);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100,
        ),
        Align(
          child: Container(
            padding: EdgeInsets.all(3),
            color: _textStyleColor(label),
            child: Text(
              _textDisplay(label),
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ),
        Container(
          width: width * 0.7,
          height: height * 0.4,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(
              color: _changeBorderColor(
                context,
                widget._entities,
              ),
              width: 5,
            )),
          ),
        ),
      ],
    );
  }
}
