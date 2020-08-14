import 'package:comet_internet_speed_test/components/errorMsg.dart';
import 'package:comet_internet_speed_test/components/speedLabels.dart';
import 'package:comet_internet_speed_test/constants/alertStyle.dart';
import 'package:comet_internet_speed_test/constants/btnStyle.dart';
import 'package:comet_internet_speed_test/constants/palette.dart';
import 'package:comet_internet_speed_test/constants/testServer.dart';
import 'package:flutter/material.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:internet_speed_test/callbacks_enum.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:comet_internet_speed_test/components/progressBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final internetSpeedTest = InternetSpeedTest();
  final ProgressBar progressBar = ProgressBar();
  double downloadRate = 0;
  double uploadRate = 0;
  String downloadProgress = '0';
  String uploadProgress = '0';
  double displayRate = 0;
  String displayRateTxt = '0.0';
  double displayPer = 0;
  String unitText = 'Mb/s';

  // Using a flag to prevent the user from interrupting running tests
  bool isTesting = false;

  void protectGauge(double rate) {
    // this function prevents the needle from exceeding the maximum limit of the gauge
    if (rate > 150) {
      displayRateTxt = rate.toStringAsFixed(2);
    } else {
      displayRate = rate;
      displayRateTxt = displayRate.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCol,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: progressBar.showBar(displayPer),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showLabel('Download', downloadRate, unitText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showLabel('Upload', uploadRate, unitText),
              ],
            ),
            SfRadialGauge(
                title: GaugeTitle(
                    text: ' ',
                    textStyle: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                axes: <RadialAxis>[
                  RadialAxis(
                      minimum: 0,
                      maximum: 150,
                      axisLabelStyle: GaugeTextStyle(
                        color: txtCol,
                      ),
                      ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0,
                            endValue: 50,
                            color: gaugeRange1,
                            startWidth: 10,
                            endWidth: 10),
                        GaugeRange(
                            startValue: 50,
                            endValue: 100,
                            color: gaugeRange2,
                            startWidth: 10,
                            endWidth: 10),
                        GaugeRange(
                            startValue: 100,
                            endValue: 150,
                            color: gaugeRange1,
                            startWidth: 10,
                            endWidth: 10)
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: displayRate,
                          enableAnimation: true,
                          needleColor: needleCol,
                        )
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                              child: Text(
                                displayRate.toStringAsFixed(2) + ' ' + unitText,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: txtCol,
                                ),
                              ),
                            ),
                            angle: 90,
                            positionFactor: 0.5)
                      ])
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: btnInk,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0.0),
                  color: Colors.red,
                  textColor: txtCol,
                  onPressed: () {
                    if (!isTesting) {
                      setState(() {
                        isTesting = true;
                      });
                      internetSpeedTest.startDownloadTesting(
                        onDone: (double transferRate, SpeedUnit unit) {
                          setState(() {
                            downloadRate = transferRate;
                            protectGauge(downloadRate);
                            unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                            downloadProgress = '100';
                            displayPer = 100.0;
                          });
                          internetSpeedTest.startUploadTesting(
                            onDone: (double transferRate, SpeedUnit unit) {
                              setState(() {
                                uploadRate = transferRate;
                                uploadRate = uploadRate * 10;
                                protectGauge(uploadRate);
                                unitText =
                                    unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                                uploadProgress = '100';
                                displayPer = 100.0;
                                isTesting = false;
                                // Display speed test results
                                Alert(
                                  context: context,
                                  style: alertStyle,
                                  type: AlertType.info,
                                  title: "TEST RESULTS",
                                  desc: 'Download Speed: ' +
                                      downloadRate.toStringAsFixed(2) +
                                      ' $unitText\nUpload Speed: ' +
                                      uploadRate.toStringAsFixed(2) +
                                      ' $unitText',
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: Color.fromRGBO(114, 137, 218, 1.0),
                                      radius: BorderRadius.circular(0.0),
                                    ),
                                  ],
                                ).show();
                              });
                            },
                            onProgress: (double percent, double transferRate,
                                SpeedUnit unit) {
                              setState(() {
                                uploadRate = transferRate;
                                uploadRate = uploadRate * 10;
                                protectGauge(uploadRate);
                                unitText =
                                    unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                                uploadProgress = percent.toStringAsFixed(2);
                                displayPer = percent;
                              });
                            },
                            onError:
                                (String errorMessage, String speedTestError) {
                              showError(
                                  'Upload test failed! Please check your internet connection.');
                              setState(() {
                                isTesting = false;
                              });
                            },
                            testServer: uploadServer,
                            fileSize: 20000000,
                          );
                        },
                        onProgress: (double percent, double transferRate,
                            SpeedUnit unit) {
                          setState(() {
                            downloadRate = transferRate;
                            protectGauge(downloadRate);
                            unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                            downloadProgress = percent.toStringAsFixed(2);
                            displayPer = percent;
                          });
                        },
                        onError: (String errorMessage, String speedTestError) {
                          showError(
                              'Download test failed! Please check your internet connection.');
                          setState(() {
                            isTesting = false;
                          });
                        },
                        testServer: downloadServer,
                        fileSize: 20000000,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
