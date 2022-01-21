import 'package:flutter/material.dart';
import 'package:mask_recognition_app/screens/classification.dart';
import 'package:mask_recognition_app/screens/detection.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //HEIGHT-WIDTH
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //THEME
    var theme = Theme.of(context);
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: theme.primaryColorLight,
          appBar: AppBar(
            title: Text(
              "Mask Recognition",
              style: TextStyle(fontSize: 20, color: theme.primaryColorLight),
            ),
            centerTitle: true,
            backgroundColor: theme.primaryColorDark,
            bottom: TabBar(indicatorColor: theme.primaryColorDark, tabs: [
              Tab(
                child: Text(
                  "Classification",
                  style:
                      TextStyle(fontSize: 15, color: theme.primaryColorLight),
                ),
              ),
              Tab(
                child: Text(
                  "Detection",
                  style:
                      TextStyle(fontSize: 15, color: theme.primaryColorLight),
                ),
              ),
            ]),
          ),
          body: TabBarView(children: [Classification(), Detection()]),
        ));
  }
}
