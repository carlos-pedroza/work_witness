import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/models/localitation.dart';
import 'package:work_witness/src/widgets/button-circular.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';
import 'package:geolocator/geolocator.dart';

class ProjectSetPhoto extends StatefulWidget {
  final Localitation localitation;
  final String imagePath;

  const ProjectSetPhoto({Key key, this.localitation, this.imagePath})
      : super(key: key);

  @override
  _ProjectSetPhotoState createState() => _ProjectSetPhotoState();
}

class _ProjectSetPhotoState extends State<ProjectSetPhoto> {
  bool loading = false;
  String latitude = '';
  String longitude = '';

  Future onBackPage(BuildContext context) async {
    Navigator.of(context).pop(false);
  }

  void setPhoto(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  getPosition() {
    Controller.getLocalitation().then((Localitation _localitation) {
      if (_localitation == null) {
        setPosition();
      } else {
        if (!_localitation.expired()) {
          setState(() {
            latitude = _localitation.latitude.toString();
            longitude = _localitation.longitude.toString();
            widget.localitation.copy(_localitation);
            loading = false;
          });
        } else {
          setPosition();
        }
      }
    });
  }

  void setPosition() {
    setState(() {
      latitude = 'wait..';
      longitude = 'wait..';
      loading = true;
    });
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
    .listen((Position position) {
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        widget.localitation.setLocalitationString(latitude, longitude);
        Controller.setLocalitation(widget.localitation);
        loading = false;
      });
    },onError: (e) {
       Navigator.of(context).pop(false);
    });
  }

  @override
  void initState() {
    getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Work Witness',
            style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              onBackPage(context);
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Image.file(
                File(widget.imagePath),
                fit: BoxFit.contain,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  margin: EdgeInsets.only(top: 0, left: 0, right: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Latitude: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              backgroundColor: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.8),
                            ),
                          ),
                          Text(
                            latitude,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              backgroundColor: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'longitude: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              backgroundColor: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.8),
                            ),
                          ),
                          Text(
                            longitude,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              backgroundColor: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.height - 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ButtonCircular(
              loading: loading,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              icon: Icons.check,
              buttomSize: 80,
              iconSize: 40,
              loadingSize: 10,
              tap: () {
                setPhoto(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
