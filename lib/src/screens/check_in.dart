import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/enums/check_type_enum.dart';
import 'package:work_witness/src/controller/models/localitation.dart';
import 'package:work_witness/src/controller/models/send_check.dart';
import 'package:work_witness/src/controller/utils.dart';
import 'package:work_witness/src/screens/project_reports.dart';
import 'package:work_witness/src/screens/projects.dart';
import 'package:work_witness/src/widgets/button-circular.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';
import 'package:work_witness/src/controller/models/project.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckIn extends StatefulWidget {
  final Project project;
  CheckTypeEnum checkTypeEnum;
  final SendCheck sendCheck;

  CheckIn({
    @required this.project,
    @required this.checkTypeEnum = CheckTypeEnum.CheckIn,
    this.sendCheck,
  });

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  bool blocked = false;
  bool loading = false;
  bool loadingCheck = false;
  Completer<GoogleMapController> _controller = Completer();
  DateTime _now = DateTime.now();
  Localitation _localitation;
  int counter;

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.medium, distanceFilter: 10);
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CameraPosition _kGooglePlex;
  CameraPosition _kLake;

  Set<Circle> checkPointCircle = HashSet<Circle>();
  int circleId_conter = 0;
  String circleId = "circle_id_";

  @override
  void initState() {
    _localitation = Localitation(latitude: 0, longitude: 0, register: null);
    setState(() {
      loading = true;
    });
    counter = 0;
    Controller.getLocalitation().then((Localitation __localitation) {
      if (__localitation == null) {
        setPosition();
      } else {
        if (!__localitation.expired()) {
          _localitation = __localitation;
          setMapItems().then((_) {
            setState(() {
              loading = false;
            });
          });
        } else {
          setPosition();
        }
      }
    });
    super.initState();
  }

  Future<void> setMapItems() async {
    _kGooglePlex = CameraPosition(
      target: LatLng(_localitation.latitude, _localitation.longitude),
      zoom: 16,
    );

    _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(_localitation.latitude, _localitation.longitude),
        tilt: 59.440717697143555,
        zoom: 20);
  }

  setCircleCheckpoint() {
    circleId_conter += 1;
    checkPointCircle.add(
      Circle(
        circleId: CircleId(circleId + circleId_conter.toString()),
        fillColor: Colors.green[99],
        strokeColor: Colors.green,
        strokeWidth: 4,
        consumeTapEvents: true,
        center: LatLng(_localitation.latitude, _localitation.longitude),
        radius: 400,
        onTap: () {},
      ),
    );
  }

  setPosition() {
    StreamSubscription<Position> positionStream = geolocator
    .getPositionStream(locationOptions)
    .listen((Position position) {
      setState(() {
        _localitation = Localitation(
            latitude: position.latitude,
            longitude: position.longitude,
            register: DateTime.now());
        Controller.setLocalitation(_localitation);
        setMapItems().then((_) {
          setState(() {
            loading = false;
          });
        });
      });
    },
    onError: (e) {
      setState(() {
        loading = false;
        blocked = true;
      });
    }
    );
  }

  void check() {
    setState(() {
      loadingCheck = true;
    });
    SendCheck check = SendCheck(
      id: null,
      idCheckType: CheckType.key(widget.checkTypeEnum),
      idProject: widget.project.id,
      idEmployee: widget.project.idEmployee,
      latitude: _localitation.latitude,
      longitude: _localitation.longitude,
      value: _now,
    );
    Controller.check(check).then((bool result) {
      SnackBar snackBar;
      if (result) {
        snackBar = SnackBar(
          content: Text(CheckType.value(widget.checkTypeEnum),
              style: TextStyle(color: Colors.black)),
          backgroundColor: widget.checkTypeEnum == CheckTypeEnum.CheckIn
              ? Colors.green
              : Colors.blue,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        if (isCheckIn()) {
          goProjectReports();
        } else {
          goProjects();
        }
      } else {
        snackBar = SnackBar(
          content: Text('An error ocurred!'),
          backgroundColor: Colors.red,
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  void goProjectReports() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProjectReports(
          project: widget.project,
          isBreakTime: false,
        ),
      ),
    );
  }

  void goProjects() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Projects(),
      ),
    );
  }

  void setTimer() {
    if (!blocked) {
      setState(() {
        _now = DateTime.now();
        if (counter == 300) {
          StreamSubscription<Position> positionStream = geolocator
              .getPositionStream(locationOptions)
          .listen((Position position) {
            _localitation = Localitation(
                latitude: position.latitude,
                longitude: position.longitude,
                register: DateTime.now());
            Controller.setLocalitation(_localitation);
            setState(() {
              loading = false;
            });
          },
          onError: (e) {
            setState(() {
              loading = false;
              blocked = true;
            });
          }
          );
          counter = 0;
        }
        counter += 1;
      });
    }
  }

  Future<bool> callBackPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Projects(),
      ),
    );
  }

  bool isCheckIn() {
    return widget.checkTypeEnum == CheckTypeEnum.CheckIn;
  }

  Widget clock() {
    if (MediaQuery.of(context).size.width > 350) {
      return Text(
        DateFormat.Hms('en_US').format(new DateTime.now()),
        style: TextStyle(
          color: Colors.green[900],
          fontSize: 58,
        ),
      );
    } else {
      return Text(
        DateFormat.Hms('en_US').format(new DateTime.now()),
        style: TextStyle(
          color: Colors.green[900],
          fontSize: 45,
        ),
      );
    }
  }

  Widget _content() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        image: DecorationImage(
          image: AssetImage("assets/images/logo_t.png"),
          fit: BoxFit.none,
        ),
      ),
      child: !loading
          ? Stack(
              children: <Widget>[
                Container(
                  child: GoogleMap(
                    padding: EdgeInsets.only(top: 120, bottom: 100),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: (point) {
/*                         setState(() {
                            checkPointCircle.clear();
                            setCircleCheckpoint();
                          }); */
                    },
                    onCameraMove: null,
                    circles: checkPointCircle,
                  ),
                ),
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  top: 68,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.6),
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.project.employee,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              Text(
                                  DateFormat.yMMMMd('en_US')
                                      .format(new DateTime.now()),
                                  style: Theme.of(context).textTheme.bodyText2),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          CheckType.value(widget.checkTypeEnum),
                          style: TextStyle(
                              color: isCheckIn()
                                  ? Colors.green[900]
                                  : Colors.blue[900],
                              fontSize: 38),
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin:
                              EdgeInsets.only(left: 30, right: 30, bottom: 20),
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 4, bottom: 4),
                          child: clock(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : LoadingIndicator(size: 40),
    );
  }

  Widget _body() {
    if (blocked == true) {
      return blockedBody();
    } else {
      return _content();
    }
  }

  Widget blockedBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Container(
          height: 300,
          width: 300,
          child: Card(
            elevation: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('For this function it is necessary to geolocalisation and have to have permissions for it, Thanks!', style: TextStyle(color: Colors.black87, fontSize: 22), textAlign: TextAlign.center,),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => Projects()));
                  },
                  child: Text('Back', style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).primaryColor,
                ),
            ],) 
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), setTimer);
    return WillPopScope(
      onWillPop: callBackPage,
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text('Work Witness',
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark, fontSize: 22)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Theme.of(context).primaryColorDark,
              size: 28,
            ),
            onPressed: () => callBackPage(),
          ),
        ),
        body: _body(),
        floatingActionButton: !blocked
            ? Container(
                height: MediaQuery.of(context).size.height - 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    !loading
                        ? ButtonCircular(
                            loading: loadingCheck,
                            color: isCheckIn()
                                ? Colors.green.withOpacity(0.7)
                                : Colors.blue.withOpacity(0.7),
                            textColor: isCheckIn()
                                ? Colors.green[200]
                                : Colors.blue[200],
                            icon: Icons.location_searching,
                            buttomSize: 100,
                            iconSize: 60,
                            loadingSize: 40,
                            tap: check,
                          )
                        : Container(),
                  ],
                ),
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
