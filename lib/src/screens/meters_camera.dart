import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:torch_compat/torch_compat.dart';
import 'package:webnams_app_v3/src/models/dashboard/dashboard_model.dart';
import 'package:webnams_app_v3/src/models/image_model.dart';
import 'package:webnams_app_v3/src/resources/colors.dart';
import 'package:webnams_app_v3/src/resources/db_provider.dart';


// A screen that allows users to take a picture using a given camera.
class MetersCamera extends StatefulWidget {
  final CameraDescription camera;

  const MetersCamera({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  MetersCameraState createState() => MetersCameraState();
}

class MetersCameraState extends State<MetersCamera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  double top;
  double initY;
  double offsetY;
  bool flash;
  Icon flashIcon;

  final dbProvider = DbProvider.instance;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
      enableAudio: false,
    );

    flash = false;
    flashIcon = Icon(Icons.flash_on, color: Color.fromARGB(255, 181, 188, 195),);
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return LayoutBuilder(builder: (context, constraints) {
              return Stack(alignment: Alignment.center, children: [
                CameraPreview(_controller),
                Positioned(
                  top: 0,
                  width: constraints.biggest.width,
                  height: constraints.maxHeight / 2 - 49 - 150,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  height: constraints.maxHeight / 2 - 49 + 150,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight / 2 - 49 - 150,
                  right: 0,
                  width: 20,
                  height: 98,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight / 2 - 49 - 150,
                  left: 0,
                  width: 20,
                  height: 98,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Positioned(
                  top: constraints.maxHeight / 2 - 49 - 150,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 36,
                    height: 97,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 46,
                  child: FlatButton(
                    shape: CircleBorder(
                        side: BorderSide(color: hexToColor('#ffe280'))),
                    onPressed: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Construct the path where the image should be saved using the
                        // pattern package.
                        String filename = "${DateTime.now()}.png";
                        String path = join(
                          // Store the picture in the temp directory.
                          // Find the temp directory using the `path_provider` plugin.
                          (await getApplicationDocumentsDirectory()).path,
                          filename,
                        );

                        // Attempt to take a picture and log where it's been saved.
                        await _controller.takePicture(path);
                        if (await dbProvider.queryImage(
                                Provider.of<DashModel>(context, listen: false)
                                    .selectedMeter
                                    .id) ==
                            null) {
                          Map<String, dynamic> row = {
                            DbProvider.columnMeterId:
                                Provider.of<DashModel>(context, listen: false)
                                    .selectedMeter
                                    .id,
                            DbProvider.columnPath: path,
                          };

                          final id = await dbProvider.insert(row);

                          Provider.of<DashModel>(context, listen: false)
                              .updateSelectedImage(
                                  image: ImageModel.fromJson(row));

                          print("Inserted id is: ${id ?? 999}");
                        } else {
                          Map<String, dynamic> row = {
                            DbProvider.columnMeterId:
                                Provider.of<DashModel>(context, listen: false)
                                    .selectedMeter
                                    .id,
                            DbProvider.columnPath: path,
                          };

                          final id = await dbProvider.update(row);

                          Provider.of<DashModel>(context, listen: false)
                              .updateSelectedImage(
                                  image: ImageModel.fromJson(row));

                          print("Updated id is: ${id ?? 999}");
                        }

                        // If the picture was taken, display it on a new screen.
                        Navigator.pop(context);
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: hexToColor('#ffe280')),
                          borderRadius: BorderRadius.circular(360)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 15,
                  child: FlatButton(
                    shape: CircleBorder(

                    ),
                    onPressed: () async {
                      setState(() {
                        flash = !flash;
                      });
                      if (flash) {
                        setState(() {
                          flashIcon = Icon(Icons.flash_on, color: Color.fromARGB(255, 181, 188, 195),);
                        });
                        _controller.flash(false);
                      } else {
                        setState(() {
                          flashIcon = Icon(Icons.flash_off, color: Color.fromARGB(255, 181, 188, 195),);
                        });
                        _controller.flash(true);
                      }
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 45, 45, 45),
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: flashIcon,
                    ),
                  ),
                )
              ]);
            });
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
