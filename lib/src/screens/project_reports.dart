import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/controlller_local.dart';
import 'package:work_witness/src/controller/enums/check_type_enum.dart';
import 'package:work_witness/src/controller/models/localitation.dart';
import 'package:work_witness/src/controller/models/project.dart';
import 'package:work_witness/src/controller/models/project_report.dart';
import 'package:work_witness/src/controller/models/project_report_photo.dart';
import 'package:work_witness/src/controller/models/project_report_question.dart';
import 'package:work_witness/src/controller/models/send_check.dart';
import 'package:work_witness/src/screens/check_in.dart';
import 'package:work_witness/src/screens/comments_screen.dart';
import 'package:work_witness/src/screens/project_report_screen.dart';
import 'package:work_witness/src/screens/projects.dart';
import 'package:work_witness/src/widgets/button-circular.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';
import 'package:work_witness/src/widgets/project_report_item.dart';
import 'package:geolocator/geolocator.dart';

class ProjectReports extends StatefulWidget {
  final Project project;
  bool isBreakTime;
  final bool isCheckout;

  ProjectReports({
    @required this.project,
    @required this.isBreakTime,
    @required this.isCheckout,
  });

  @override
  _ProjectReportsState createState() => _ProjectReportsState();
}

class _ProjectReportsState extends State<ProjectReports> {
  ControllerLocal _controllerLocal;
  bool loading = false;
  bool loading2 = false;
  List<ProjectReport> projectReports = List<ProjectReport>();

  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.medium, distanceFilter: 10);

  Future<List<ProjectReportQuestion>> getProjectReportQuestions(
      int idProjectReport) async {
    return _controllerLocal
        .getProjectReportQuestions(idProjectReport)
        .then((value) {
      return value;
    });
  }

  Future<List<ProjectReportPhoto>> getProjectReportPhotos(
      int idProjectReport) async {
    return _controllerLocal
        .getProjectReportPhotos(idProjectReport)
        .then((value) {
      return value;
    });
  }

  Future<ProjectReport> getProjectReportInformation(
      ProjectReport _projectReport) async {
    _projectReport.projectReportQuestions =
        await getProjectReportQuestions(_projectReport.id);
    _projectReport.projectReportPhotos =
        await getProjectReportPhotos(_projectReport.id);
    return _projectReport;
  }

  Future<void> readProjectReports() async {
    setState(() {
      loading = true;
    });
    List<ProjectReport> _projectReports = await _controllerLocal
        .getProjectReports(widget.project.id, widget.project.idEmployee);
    setState(() {
      projectReports = _projectReports;
      loading = false;
    });
  }

  void addReportProject() {
    DateTime _now = DateTime.now();
    var projectReport = ProjectReport(
      id: null,
      idProject: widget.project.id,
      idEmployee: widget.project.idEmployee,
      idProjectType: 0,
      recordDate: _now,
      location: '',
      description: '',
      hours: 0,
      minutes: 0,
      create: _now,
      modify: _now,
      isSended: false,
      closed: false,
      disabled: false,
      projectReportQuestions: List<ProjectReportQuestion>(),
      projectReportPhotos: List<ProjectReportPhoto>(),
    );
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ProjectReportScreen(
              controllerLocal: _controllerLocal,
              project: widget.project,
              projectReport: projectReport,
            ),
          ),
        )
        .then((_) => readProjectReports());
  }

  void showProjectReport(ProjectReport projectReport) {
    getProjectReportInformation(projectReport)
        .then((ProjectReport projectReport) {
      DateTime _now = DateTime.now();
      projectReport.recordDate = _now;
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => ProjectReportScreen(
                controllerLocal: _controllerLocal,
                project: widget.project,
                projectReport: projectReport,
              ),
            ),
          )
          .then((_) => readProjectReports());
    });
  }

  void publishProjectReportConfirm(ProjectReport projectReport) {
    String title = "Do you want to publish the report?";
    String subtitle = "once published it cannot be modified";
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                publishProjectReport(projectReport);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                publishProjectReport(projectReport);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  void publishProjectReport(ProjectReport projectReport) {
    setState(() {
      loading = true;
    });
    Controller.publishProjectReport(projectReport).then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  void deleteConfirm(ProjectReport projectReport) {
    if (projectReport.isSended) {
      String title =
          "it is not possible to delete the report because it has already been published!";
      String subtitle = "cannot delete!";
      if (Platform.isIOS) {
        showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    } else {
      String title = "Are you sure to delete the report?";
      String subtitle = "delete the report";
      if (Platform.isIOS) {
        showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CupertinoDialogAction(
                child: Text('Yes'),
                onPressed: () {
                  delete(projectReport);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  delete(projectReport);
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    }
  }

  void delete(ProjectReport projectReport) async {
    setState(() {
      loading = true;
    });
    var controllerLocal = await ControllerLocal.create();
    controllerLocal.deleteProjectReport(projectReport).then((_) {
      readProjectReports().then((_) {
        setState(() {
          loading = false;
        });
      });
    });
  }

  Widget getProjectReports() {
    bool hasReports = projectReports.length > 0;
    if (!loading) {
      return Container(
        child: hasReports
            ? ListView.builder(
                itemCount: projectReports.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      ProjectReportItem(
                        showProjectReport: showProjectReport,
                        publishProjectReport: (_) {
                          publishProjectReportConfirm(projectReports[index]);
                        },
                        projectReport: projectReports[index],
                        delete: deleteConfirm,
                      ),
                      (index + 1 == projectReports.length)
                          ? SizedBox(height: 100)
                          : Container(),
                    ],
                  );
                },
              )
            : Container(
                child: Center(
                  child: Text('No reports!',
                      style: TextStyle(color: Colors.white54)),
                ),
              ),
      );
    } else {
      return LoadingIndicator(size: 60);
    }
  }

  void projectCheckOutConfirm() {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Are you sure to Checking out?'),
          content: Text('Check out?'),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                proyectCheckOut();
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Are you sure to Checking out?'),
          content: Text('Check out?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                proyectCheckOut();
              },
              child: Text('Yes'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }
  }

  void proyectCheckOut() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => CheckIn(
            project: widget.project, checkTypeEnum: CheckTypeEnum.CheckOut),
      ),
    );
  }

  Future<void> getControllerLocal() async {
    _controllerLocal = await ControllerLocal.create();
    return _controllerLocal;
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    _selectedIndex = index;
    switch (_selectedIndex) {
      case 0:
        if (!widget.isCheckout) {
          projectCheckOutConfirm();
        }
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CommentsScreen(project: widget.project),
          ),
        );
        break;
    }
  }

  Future<Position> setLocalitationGeoposition() async {
    Position _position;
    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      _position = position;
    });
    return _position;
  }

  Future<Localitation> getLocalitation() async {
    Localitation __localitation = await Controller.getLocalitation();
    if (__localitation == null) {
      final position = await setLocalitationGeoposition();
      return Localitation(
        latitude: position.latitude,
        longitude: position.longitude,
        register: DateTime.now(),
      );
    } else {
      if (!__localitation.expired()) {
        return __localitation;
      } else {
        final position = await setLocalitationGeoposition();
        return Localitation(
          latitude: position.latitude,
          longitude: position.longitude,
          register: DateTime.now(),
        );
      }
    }
  }

  Future<void> insertBreakPoint(DateTime _now, CheckTypeEnum _checkType) async {
    Localitation _localitation = await getLocalitation();
    return Controller.check(
      SendCheck(
        id: null,
        idProject: widget.project.id,
        idEmployee: widget.project.idEmployee,
        idCheckType: CheckType.key(_checkType),
        latitude: _localitation.latitude,
        longitude: _localitation.longitude,
        value: _now,
      ),
    );
  }

  void startBreakTime() {
    loading = true;
    var _now = DateTime.now();
    insertBreakPoint(_now, CheckTypeEnum.BreakTimeStart).then((_) {
      setState(() {
        widget.isBreakTime = true;
        loading = false;
      });
    });
  }

  void endBreakTime() {
    loading = true;
    var _now = DateTime.now();
    insertBreakPoint(_now, CheckTypeEnum.BreakTimeEnd).then((_) {
      setState(() {
        widget.isBreakTime = false;
        loading = false;
      });
    });
  }

  Widget content() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: AssetImage("assets/images/logo_t.png"),
          fit: BoxFit.none,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark.withOpacity(0.3),
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.0,
                ),
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.0,
                ),
              ),
            ),
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.project.employee,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(DateFormat.yMMMMd('en_US').format(new DateTime.now()),
                    style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.0,
                ),
              ),
            ),
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
            child: Text(
              widget.project.project,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                getProjectReports(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColorDark.withOpacity(0.8),
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: !widget.isCheckout
                                ? InkWell(
                                    onTap: startBreakTime,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.free_breakfast,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text('break time',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: 10,
                                  ),
                          ),
                          Container(
                            child: !widget.isCheckout
                                ? Row(
                                    children: <Widget>[
                                      Text('work in progress',
                                          style: TextStyle(
                                              color: Colors.green[100],
                                              fontSize: 12)),
                                      SizedBox(width: 10),
                                      Icon(Icons.gps_fixed,
                                          color: Colors.green[100]),
                                    ],
                                  )
                                : Row(
                                    children: <Widget>[
                                      Text('working day end',
                                          style: TextStyle(
                                              color: Colors.blue[100],
                                              fontSize: 12)),
                                      SizedBox(width: 10),
                                      Icon(Icons.gps_off,
                                          color: Colors.blue[100]),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: BottomNavigationBar(
                    backgroundColor: Theme.of(context).primaryColorDark,
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: !widget.isCheckout
                            ? Icon(Icons.gps_off)
                            : Icon(
                                Icons.gps_off,
                                color: Colors.grey[700],
                              ),
                        title: !widget.isCheckout
                            ? Text('check out')
                            : Text('check out',
                                style: TextStyle(color: Colors.grey[700])),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.comment),
                        title: Text('comments'),
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white,
                    onTap: _onItemTapped,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> callBackPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Projects(),
      ),
    );
  }

  Future<void> syncProjectCloud() async {
    Controller.listProjectReports(widget.project.id)
        .then((List<ProjectReport> cloudProjectReports) {
      for (var cloudProjectReport in cloudProjectReports) {
        try {
          var projectReport = projectReports
              .singleWhere((e) => e.idServer == cloudProjectReport.id);
          if (projectReport != null) {
            projectReport.copyCloud(cloudProjectReport);
            _controllerLocal.updateProjectReport(projectReport);
          }
        } catch (e) {
          cloudProjectReport.idServer = cloudProjectReport.id;
          cloudProjectReport.id = null;
          _controllerLocal.insertProjectReport(cloudProjectReport);
        }
      }
    });
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        content(),
        widget.isBreakTime
            ? Container(
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.free_breakfast,
                      size: (MediaQuery.of(context).size.width / 5),
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('BREAK TIME',
                        style: TextStyle(color: Colors.white, fontSize: 42)),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 30, right: 30),
                      child: Text(
                        'Finish',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColorDark,
                      onPressed: endBreakTime,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  void initState() {
    loading = false;
    getControllerLocal().then((_) {
      readProjectReports().then((_) => syncProjectCloud());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: callBackPage,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColorDark,
          title: Text('Work Witness',
              style: TextStyle(color: Colors.white, fontSize: 22)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () => callBackPage(),
          ),
        ),
        body: _body(),
        floatingActionButton: !widget.isBreakTime && !widget.isCheckout
            ? Container(
                height: MediaQuery.of(context).size.height - 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ButtonCircular(
                      loading: loading2,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      icon: Icons.add,
                      buttomSize: 80,
                      iconSize: 48,
                      loadingSize: 10,
                      tap: addReportProject,
                    ),
                  ],
                ),
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
