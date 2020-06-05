import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:work_witness/src/controller/models/localitation.dart';
import 'package:work_witness/src/controller/models/project_report.dart';
import 'package:work_witness/src/controller/models/project_report_photo.dart';
import 'package:work_witness/src/screens/project_set_photo.dart';
import 'package:work_witness/src/widgets/button-circular.dart';
import 'package:light/light.dart';

class ProjectReportPhotoCamaraScreen extends StatefulWidget {
  final CameraDescription camera;
  final ProjectReport projectReport;

  ProjectReportPhotoCamaraScreen({
    Key key,
    @required this.camera,
    @required this.projectReport,
  });

  @override
  _ProjectReportPhotoCamaraState createState() =>
      _ProjectReportPhotoCamaraState();
}

class _ProjectReportPhotoCamaraState
    extends State<ProjectReportPhotoCamaraScreen> {
  // Add two variables to the state class to store the CameraController and
  // the Future.
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool loadingCamara = false;
  bool hasLamp = false;
  bool isLamp = false;
  Light _light;
  StreamSubscription _subscription;
  String _luxString = 'Unknown';
  Localitation localitation =
      Localitation(latitude: 0, longitude: 0, register: null);

  void onData(int luxValue) async {
    print("Lux value: $luxValue");
    setState(() {
      _luxString = "$luxValue";
    });
  }

  void stopListening() {
    _subscription.cancel();
    isLamp = false;
  }

  void startListening() {
    _light = new Light();
    try {
      hasLamp = true;
      _subscription = _light.lightSensorStream.listen(onData);
      isLamp = true;
    } on LightException catch (exception) {
      hasLamp = false;
      print(exception);
    }
  }

  Future<void> initPlatformState() async {
    startListening();
    stopListening();
  }

  @override
  void initState() {
    initPlatformState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

    super.initState();
  }

  Future<String> getPhotoPath() async {
    List<Directory> directories =
        await getExternalStorageDirectories(type: StorageDirectory.dcim);
    if (directories.length > 0) {
      return join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        directories[directories.length - 1].path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    } else {
      return join(
        // Store the picture in the temp directory.
        // Find the temp directory using the `path_provider` plugin.
        (await getApplicationDocumentsDirectory()).path,
        '${DateTime.now()}.png',
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future takePhoto() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Construct the path where the image should be saved using the
      // pattern package.
      final path = await getPhotoPath();

      // Attempt to take a picture and log where it's been saved.
      await _controller.takePicture(path);

      // If the picture was taken, display it on a new screen.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProjectSetPhoto(localitation: localitation, imagePath: path),
        ),
      ).then((value) {
        if (value) {
          widget.projectReport.projectReportPhotos.add(
            ProjectReportPhoto(
                id: null,
                idProjectReport: null,
                latitude: localitation.latitude,
                longitude: localitation.longitude,
                photo: path),
          );
          Navigator.of(context).pop(true);
        }
      });
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  turnFlash() {
    if (hasLamp) {
      setState(() {
        if (isLamp) {
          isLamp = false;
          stopListening();
        } else {
          isLamp = true;
          startListening();
        }
      });
    }
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
          leading: /*hasLamp
              ? IconButton(
                  icon: Icon(
                    isLamp ? Icons.flash_off : Icons.flash_on,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    turnFlash();
                  })
              :*/ SizedBox(width: 22),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
          ]),
      body: Container(
        color: Theme.of(context).primaryColorDark,
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.height - 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ButtonCircular(
              loading: loadingCamara,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              icon: Icons.lens,
              buttomSize: 80,
              iconSize: 78,
              loadingSize: 10,
              tap: takePhoto,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
