import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/controlller_local.dart';
import 'package:work_witness/src/controller/models/project.dart';
import 'package:work_witness/src/controller/models/project_project_type.dart';
import 'package:work_witness/src/controller/models/project_report.dart';
import 'package:work_witness/src/controller/models/project_report_photo.dart';
import 'package:work_witness/src/controller/models/project_report_question.dart';
import 'package:work_witness/src/controller/models/project_type_question.dart';
import 'package:work_witness/src/screens/project_report_photo_camara_screen.dart';
import 'package:work_witness/src/widgets/button-circular.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';
import 'package:camera/camera.dart';

class ProjectReportScreen extends StatefulWidget {
  final ControllerLocal controllerLocal;
  final Project project;
  final ProjectReport projectReport;

  ProjectReportScreen({
    @required this.controllerLocal,
    @required this.project,
    @required this.projectReport,
  });

  @override
  _ProjectReportScreenState createState() => _ProjectReportScreenState();
}

class _ProjectReportScreenState extends State<ProjectReportScreen> {
  String description = '';
  bool loading = false;
  bool loadingCamara = false;
  bool loadingSave = false;
  bool showPhotos = false;
  bool hasPhoto = false;
  List<ProjectProjectType> projectProjectTypes = [];
  bool selectProjectType = false;

  void loadData() {
    loading = true;
    if (widget.projectReport.projectReportQuestions.length <= 0) {
      widget.projectReport.projectReportQuestions =
          List<ProjectReportQuestion>();
      Controller.projectTypeQuetions(widget.projectReport.idProjectType)
          .then((List<ProjectTypeQuestion> _projectTypeQuestions) {
        setState(() {
          widget.projectReport.projectReportQuestions.add(
            ProjectReportQuestion(
              id: null,
              idProjectReport: widget.projectReport.id,
              idProjectTypeQuestion: null,
              question: 'description',
              value: widget.projectReport.description,
            ),
          );
          _projectTypeQuestions
              .forEach((p) => widget.projectReport.projectReportQuestions.add(
                    ProjectReportQuestion(
                      id: null,
                      idProjectReport: widget.projectReport.id,
                      idProjectTypeQuestion: p.id,
                      question: p.question,
                      value: '',
                    ),
                  ));
          loading = false;
        });
      });
    } else {
      widget.projectReport.projectReportQuestions.insert(
        0,
        ProjectReportQuestion(
          id: null,
          idProjectReport: widget.projectReport.id,
          idProjectTypeQuestion: null,
          question: 'description',
          value: widget.projectReport.description,
        ),
      );
      loading = false;
    }
  }

  Widget hoursMinutes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        !loading
            ? Container(
                width: 100,
                color: Colors.white,
                child: TextFormField(
                  initialValue: widget.projectReport.hours > 0
                      ? widget.projectReport.hours.toString()
                      : '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'hours',
                  ),
                  onChanged: (String value) {
                    widget.projectReport.hours = int.parse(value);
                  },
                  textAlign: TextAlign.right,
                  enabled: !widget.projectReport.isSended,
                ),
              )
            : Container(),
        SizedBox(width: 20),
        !loading
            ? Container(
                width: 110,
                color: Colors.white,
                child: TextFormField(
                  initialValue: widget.projectReport.minutes > 0
                      ? widget.projectReport.minutes.toString()
                      : '',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'minutes',
                  ),
                  onChanged: (String value) {
                    widget.projectReport.minutes = int.parse(value);
                  },
                  textAlign: TextAlign.right,
                  enabled: !widget.projectReport.isSended,
                ),
              )
            : Container(),
      ],
    );
  }

  Widget content() {
    double _botonSize = 60;
    double _iconSize = 40;
    bool _isTablet = false; 
    if (MediaQuery.of(context).size.width>700&&MediaQuery.of(context).size.height>700) {
      _isTablet = true;
      _botonSize = 100;
      _iconSize = 60;
    }
    return Container(
            child: !showPhotos
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget
                                .projectReport.projectReportQuestions.length,
                            itemBuilder: (BuildContext context, int i) {
                              Widget questionBox = QuestionBox(
                                  projectReport: widget.projectReport,
                                  projectReportQuestion: widget
                                      .projectReport.projectReportQuestions[i]);
                              if (i == 0) {
                                return Column(children: <Widget>[
                                  SizedBox(height: 10),
                                  hoursMinutes(),
                                  questionBox,
                                ]);
                              }
                              if ((i + 1) ==
                                  widget.projectReport.projectReportQuestions
                                      .length) {
                                return Column(
                                  children: <Widget>[
                                    questionBox,
                                    SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                );
                              } else {
                                return questionBox;
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showPhotos = !showPhotos;
                            });
                          },
                          child: Container(
                            color: Colors.lightBlue[700],
                            child: ButtonCircular(
                              loading: loadingCamara,
                              color: Colors.lightBlue[800],
                              textColor:
                                  Theme.of(context).textTheme.bodyText1.color,
                              icon: !showPhotos
                                  ? Icons.camera_alt
                                  : Icons.arrow_back_ios,
                              buttomSize: _botonSize,
                              iconSize: _iconSize,
                              loadingSize: _iconSize,
                              tap: () {
                                setState(() {
                                  showPhotos = !showPhotos;
                                });
                              },
                            ),
                          ),
                        )
                      ])
                : Row(children: <Widget>[
                    Container(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showPhotos = !showPhotos;
                          });
                        },
                        child: Container(
                          color: Colors.lightBlue[700],
                          child: ButtonCircular(
                            loading: loadingCamara,
                            color: Colors.lightBlue[800],
                            textColor:
                                Theme.of(context).textTheme.bodyText1.color,
                            icon: !showPhotos
                                ? Icons.camera_alt
                                : Icons.arrow_back_ios,
                            buttomSize: _botonSize,
                            iconSize: _iconSize,
                            loadingSize: _iconSize,
                            tap: () {
                              setState(() {
                                showPhotos = !showPhotos;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ProjectReportPhotoScreen(
                          projectReport: widget.projectReport,
                          tookPhoto: (bool result) {
                            setState(() {
                              hasPhoto = result;
                            });
                          }),
                    ),
                  ]),
          );
  }

  Widget contentLandScapeTablet() {
    return Container(
      color: Colors.white70,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height - 80,
          width: (MediaQuery.of(context).size.width / 2) - 60,
          child: ListView.builder(
                    itemCount: widget
                        .projectReport.projectReportQuestions.length,
                    itemBuilder: (BuildContext context, int i) {
                      Widget questionBox = QuestionBox(
                          projectReport: widget.projectReport,
                          projectReportQuestion: widget
                              .projectReport.projectReportQuestions[i]);
                      if (i == 0) {
                        return Column(children: <Widget>[
                          SizedBox(height: 10),
                          hoursMinutes(),
                          questionBox,
                        ]);
                      }
                      if ((i + 1) ==
                          widget.projectReport.projectReportQuestions
                              .length) {
                        return Column(
                          children: <Widget>[
                            questionBox,
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        );
                      } else {
                        return questionBox;
                      }
                    },
                  ),
        ),
        SizedBox(width: 10),
        Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height - 80,
          width: (MediaQuery.of(context).size.width / 2) - 70,
          child: ProjectReportPhotoScreen(
              projectReport: widget.projectReport,
              tookPhoto: (bool result) {
                setState(() {
                  hasPhoto = result;
                });
              }),
        ),
      ],),
    );
  }

  Widget contentResponsive() {
    if(!selectProjectType) {
      if (MediaQuery.of(context).orientation == Orientation.landscape && MediaQuery.of(context).size.height>700) {
        return Container(
          padding: EdgeInsets.only(top:60, left: 40, right: 40, bottom: 120),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: contentLandScapeTablet()
        );
      } else {
        return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.only(left: 10),
                        child: content(),
                      ),
                    )
                  ],
                );
      }
    } else {
      return getListProjectType();
    }
  }

  void onSave() {
    var projectReportQuestion = widget.projectReport.projectReportQuestions.firstWhere((e) => e.idProjectTypeQuestion == null);
    widget.projectReport.description = projectReportQuestion.value;
    widget.projectReport.projectReportQuestions.remove(projectReportQuestion);
    setState(() {
      loading = true;
    });
    if (widget.projectReport.id == null) {
      widget.controllerLocal
          .insertProjectReport(widget.projectReport)
          .then((value) {
        loading = false;
        Navigator.of(context).pop();
      });
    } else {
      widget.controllerLocal
          .updateProjectReport(widget.projectReport)
          .then((value) {
        loading = false;
        Navigator.of(context).pop();
      });
    }
  }

  Widget body() {
    return !loading ? contentResponsive() : LoadingIndicator(size: 40);
  }

  Widget getListProjectType() {
    return !loading
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 20, bottom: 10, left: 24),
                  child: Text('Select the Custom Form',
                      style: Theme.of(context).textTheme.headline2),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 0, bottom: 10, left: 25, right: 25),
                    color: Colors.white,
                    child: ListView.builder(
                        itemCount: projectProjectTypes.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                widget.projectReport.idProjectType =
                                    projectProjectTypes[i].idProjectType;
                                selectProjectType = false;
                              });
                              loadData();
                            },
                            title: Text(projectProjectTypes[i].name),
                          );
                        }),
                  ),
                )
              ],
            ),
          )
        : LoadingIndicator(size: 40);
  }

  readProjectTypes() {
    if (widget.projectReport.idProjectType == 0) {
      setState(() {
        loading = true;
      });
      Controller.listProjectProjectTypes(widget.project.id)
          .then((List<ProjectProjectType> _projectProjectTypes) {
        setState(() {
          projectProjectTypes = _projectProjectTypes;
          selectProjectType = true;
          loading = false;
        });
      });
    } else {
      loadData();
      setState(() {
        selectProjectType = false;
      });
    }
  }

  @override
  void initState() {
    readProjectTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool smallScreen = false;
    if (MediaQuery.of(context).orientation == Orientation.landscape &&
        MediaQuery.of(context).size.height > 600.0) {
      smallScreen = true;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
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
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: smallScreen
          ? SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: body(),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              child: body(),
            ),
      floatingActionButton:
          !widget.projectReport.isSended && !showPhotos && !selectProjectType
              ? Container(
                  height: MediaQuery.of(context).size.height - 80,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ButtonCircular(
                        loading: false,
                        color: Colors.blue,
                        textColor: Theme.of(context).textTheme.bodyText1.color,
                        icon: Icons.check,
                        buttomSize: 70,
                        iconSize: 50,
                        loadingSize: 30,
                        tap: onSave,
                      ),
                    ],
                  ),
                )
              : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class QuestionBox extends StatelessWidget {
  final ProjectReport projectReport;
  final ProjectReportQuestion projectReportQuestion;

  QuestionBox({
    @required this.projectReport,
    @required this.projectReportQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: TextFormField(
        //key: UniqueKey(),
        initialValue: projectReportQuestion.value,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: projectReportQuestion.question,
        ),
        onChanged: (String value) {
          projectReportQuestion.value = value;
        },
        enabled: !projectReport.isSended,
      ),
    );
  }
}

class ProjectReportPhotoScreen extends StatefulWidget {
  final ProjectReport projectReport;
  final Function(bool) tookPhoto;

  ProjectReportPhotoScreen(
      {@required this.projectReport, @required this.tookPhoto});

  @override
  _ProjectReportPhotoScreenState createState() =>
      _ProjectReportPhotoScreenState();
}

class _ProjectReportPhotoScreenState extends State<ProjectReportPhotoScreen> {
  bool loadingPicker = false;
  bool loadingCamara = false;
  bool showCamara = true;
  var cameras;
  CameraDescription firstCamera;

  void addPhoto(
      double latitude, double longitude, String photo, Function callBack) {
    setState(() {
      widget.projectReport.projectReportPhotos.add(
        ProjectReportPhoto(
          id: null,
          idProjectReport: widget.projectReport.id,
          latitude: latitude,
          longitude: longitude,
          photo: photo,
        ),
      );
    });
    callBack();
  }

  void takePhoto() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => ProjectReportPhotoCamaraScreen(
                projectReport: widget.projectReport,
                camera: firstCamera,
              )),
    ).then((value) {
      widget.tookPhoto(value);
    });
  }

  Future getCameras() async {
    setState(() {
      loadingCamara = true;
    });
    try {
      final _cameras = await availableCameras();
      if (_cameras.length > 0) {
        cameras = _cameras;
        firstCamera = _cameras.first;
        setState(() {
          loadingCamara = false;
          showCamara = true;
        });
      } else {
        setState(() {
          loadingCamara = false;
          showCamara = false;
        });
      }
    } catch(ex) {
      setState(() {
        loadingCamara = false;
        showCamara = false;
      });
    } 
  }

  void deleteProjectReportPhotoConfirm(ProjectReportPhoto projectReportPhotos) {
    if (Platform.isIOS) {
      showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text('Remove photo?'),
          content: Text('Are you sure?'),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            CupertinoDialogAction(
              child: Text('Yes'),
              onPressed: () {
                deleteProjectReportPhoto(projectReportPhotos);
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
          title: Text('Are you sure?'),
          content: Text('Are you sure?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                deleteProjectReportPhoto(projectReportPhotos);
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

  void deleteProjectReportPhoto(ProjectReportPhoto projectReportPhotos) {
    setState(() {
      projectReportPhotos.disabled = true;
    });
  }

  @override
  void initState() {
    getCameras();
    super.initState();
  }

  Widget photo(int i) {
    //var _url = Endpoints.url(EndpointsEnum.getProjectReportPhoto);
    return Image.file(
      File(widget.projectReport.projectReportPhotos[i].photo),
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fitWidth,
    );
  }

  Widget contentTakePic() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Expanded(
          child: Container(
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.all(6),
            child: showCamara ? ListView.builder(
                    itemCount: widget.projectReport.projectReportPhotos.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (!widget
                          .projectReport.projectReportPhotos[index].disabled) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          child: Stack(
                            children: <Widget>[
                              photo(index),
                              Container(
                                margin:
                                    EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Latitude: ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        backgroundColor: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    Text(
                                      widget.projectReport
                                          .projectReportPhotos[index].latitude
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        backgroundColor: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    Text(
                                      'longitude: ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        backgroundColor: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                    Text(
                                      widget.projectReport
                                          .projectReportPhotos[index].longitude
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        backgroundColor: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: !widget.projectReport.isSended
                                    ? IconButton(
                                        icon: Icon(Icons.delete_forever,
                                            color: Colors.white, size: 34),
                                        onPressed: () {
                                          deleteProjectReportPhotoConfirm(widget
                                              .projectReport
                                              .projectReportPhotos[index]);
                                        },
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ): Center(child: Text('No camera available!'),),
          ),
        ),
        !widget.projectReport.isSended&&showCamara
        ? Container(
          color: Colors.blue[300],
          padding: EdgeInsets.only(top:20, bottom: 20),
          width: double.infinity,
          child: ButtonCircular(
              loading: loadingCamara,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              icon: Icons.camera,
              buttomSize: 80,
              iconSize: 48,
              loadingSize: 10,
              tap: takePhoto,
            ),
        )
        : Container()
      ],),
    );
  }

  @override
  Widget build(BuildContext context) {
    return contentTakePic();
  }
}
