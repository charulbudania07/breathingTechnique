import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhythmicbreathingtechnique/CirclePainter.dart';
import 'package:rhythmicbreathingtechnique/CircleRedPainter.dart';
import 'package:rhythmicbreathingtechnique/Constants.dart';
import 'package:rhythmicbreathingtechnique/OpenPainter.dart';

import 'package:rhythmicbreathingtechnique/model/RhythmicModel.dart';
import 'package:rhythmicbreathingtechnique/provider/RhythmicBreathingProvider.dart';

import 'BackgroundCirclePainter.dart';

class RhythmicBreathingTechniqueTesting2 extends StatefulWidget {
  const RhythmicBreathingTechniqueTesting2({Key? key}) : super(key: key);

  @override
  _RhythmicBreathingTechniqueState createState() =>
      _RhythmicBreathingTechniqueState();
}

class _RhythmicBreathingTechniqueState
    extends State<RhythmicBreathingTechniqueTesting2>
    with TickerProviderStateMixin {
  late RhythmicBreathingProvider _provider;
  late ConfettiController _controllerCenter;
  final List<double> sizes = [150, 250, 250, 150, 150];
  final List<double> centerCircleSizes = [40, 90, 90, 40, 40];
  final List<int> duration = [0, 4, 2, 4, 2];
  final List<String> textArray = [
    "",
    "Breathe in",
    "Hold",
    "Breathe out",
    "Hold",
  ];
  final List<String> tempTextArray = [
"",
    "Inhale",
    "Hold",
    "Exhale",
    "Hold",
  ];
  List<String> selectedItems = [];
  Map<String, bool> values = {
    'calm  :': false,
    'energetic :': false,
    'relaxed :': false,
    'focused :': false,
  };
  var _radioSelected;
  String _radioVal = "";
  int iteration = 0;
  int? cycle;
  int sum = 0;
  late Animation<double> animationRotation;
  late Animation<double> animationRotation2;
  late AnimationController controller;
  late AnimationController animation;

  late double dotRadius = 14.0;
  int total = 0;
  int effective = 0;
  int notEffective = 0;
  int timerMaxSeconds = 96;
  int currentSeconds = 0;
  bool isAnimation = false;
  bool isCircleAnimation = true;
  bool isshowQuestion = false;
  bool isConfetti = false;
  bool isRestart = false;
  late CircleRedPainter _circleRedPainter;

  Timer? time;

  startTimer() {
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _provider = RhythmicBreathingProvider();
    for (int i = 0; i < duration.length; i++) {
      sum = sum + duration[i];
    }
    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(seconds: sum),
        vsync: this);

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    ); animationRotation2 = Tween(begin: 0.0, end: 1.0).animate(
      AnimationController(vsync: this, duration: Duration(milliseconds: 100)),
    );
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (math.pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * math.cos(step),
          halfWidth + externalRadius * math.sin(step));
      path.lineTo(
          halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * math.sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }


  Future<void> run(int cycle) async {
    while (cycle <= 10) {
      for (int i = 0; i < sizes.length; i++) {
        if (iteration + 1 < sizes.length) {
          setState(() {
            iteration += 1;
          });
          await Future.delayed(Duration(seconds: duration[iteration]), () {});
        }
      }
      setState(() {
        cycle += 1;
        iteration = 0;
      });
      if (cycle == 8) {
        setState(() {
          controller.stop();
          isAnimation = false;
          isConfetti = true;
          isCircleAnimation = false;
          questionFunction();
        });
      }
    }
  }

  questionFunction() {
    _controllerCenter.play();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isshowQuestion = true;
        isConfetti = false;
        isCircleAnimation = false;
      });
    });
  }

  Widget circleAnimation() {
    return Opacity(opacity: isCircleAnimation ? 1 : 0,child:

      Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      height: 400,
      width: 400,
      color: const Color(0xff00BBA6),
      padding: EdgeInsets.all(10),

      child:
          AnimatedOpacity(
            opacity: isCircleAnimation ? 1 : 0,
            duration: const Duration(seconds: 1),
            child: Stack(
                children: [
              Positioned(
                  top: 350,
                  left: 20,
                  right: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You have ${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')} seconds remaining",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              Center(
                child: AnimatedContainer(
                  duration: Duration(seconds: duration[iteration]),
                  width: sizes[iteration],
                  height: sizes[iteration],
                  child: CustomPaint(
                    painter: BackgroundCirclePainter(
                        text: textArray[iteration],
                        breatheIn: double.parse(duration[1].toString()),
                        breatheOut: double.parse(duration[3].toString()),
                        hold1: double.parse(duration[2].toString()),
                        hold2: double.parse(duration[4].toString()),
                        progress: controller.value),
                    child:
                    Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:CustomPaint(painter:OpenPainter()
                        //  child:  Dot(radius: 10.0,color: Colors.yellow,),
                      ),
                  ),
                ),
              )),
                  RotationTransition(
                    turns: animationRotation2,
                    child: Transform.translate(
                        child: Dot(
                          radius: 10,
                          color: Colors.white,

                        ),
                        offset: Offset(
                          dotRadius * 9.5* math.cos(0.0 + 3 * math.pi / 2),
                          //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                          dotRadius * 9.5* math.sin(0.0 +3 * math.pi / 2),
                        )),

                  ),
                  RotationTransition(
                    turns: animationRotation,
                    child: Transform.translate(
                        child: Dot(
                          radius: 20,
                          color: Colors.pinkAccent,

                        ),
                        offset: Offset(
                          dotRadius * 9.5* math.cos(0.0 + 3 * math.pi / 2),
                          //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                          dotRadius * 9.5* math.sin(0.0 +3 * math.pi / 2),
                        )),

                  ),

            ]),
          ),
      ));

  }
  Widget circleAnimationWithBackground() {
    return
      Opacity(opacity: isCircleAnimation ? 1 : 0,child:

      Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      height: 550,
      width: 550,
     decoration: const BoxDecoration(image: DecorationImage(
         image: AssetImage("assets/images/natureimg.jpg"),
        fit: BoxFit.cover,
      ),
    ),
      padding: EdgeInsets.all(10),

      child:
      AnimatedOpacity(
        opacity: isCircleAnimation ? 1 : 0,
        duration: const Duration(seconds: 1),
        child: Stack(
            children: [
              Positioned(
                  top: 350,
                  left: 20,
                  right: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You have ${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')} seconds remaining",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
              Center(
                  child: AnimatedContainer(
                    duration: Duration(seconds: duration[iteration]),
                    width: sizes[iteration],
                    height: sizes[iteration],
                    child: CustomPaint(
                      painter: BackgroundCirclePainter(
                          text: textArray[iteration],
                          breatheIn: double.parse(duration[1].toString()),
                          breatheOut: double.parse(duration[3].toString()),
                          hold1: double.parse(duration[2].toString()),
                          hold2: double.parse(duration[4].toString()),
                          progress: controller.value),
                      child:
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:CustomPaint(painter:OpenPainter()
                          //  child:  Dot(radius: 10.0,color: Colors.yellow,),
                        ),
                      ),
                    ),
                  )),
              RotationTransition(
                turns: animationRotation2,
                child: Transform.translate(
                    child: Dot(
                      radius: 10,
                      color: Colors.white,

                    ),
                    offset: Offset(
                      dotRadius * 9.5* math.cos(0.0 + 3 * math.pi / 2),
                      //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                      dotRadius * 9.5* math.sin(0.0 +3 * math.pi / 2),
                    )),

              ),
              RotationTransition(
                turns: animationRotation,
                child: Transform.translate(
                    child: Dot(
                      radius: 20,
                      color: Colors.blue,

                    ),
                    offset: Offset(
                      dotRadius * 9.5* math.cos(0.0 + 3 * math.pi / 2),
                      //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                      dotRadius * 9.5* math.sin(0.0 +3 * math.pi / 2),
                    )),

              ),

            ]),
      ),


    ));
  }


  Widget confettiWidget() {
    return AnimatedOpacity(
      opacity: isConfetti ? 1 : 0,
      duration: const Duration(seconds: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
            createParticlePath: drawStar,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Hooray!! You have successfully completed rhythmic breathing techniques",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget questionAnswer() {
    return AnimatedOpacity(
      opacity: isshowQuestion ? 1.0 : 0.0,
      duration: const Duration(seconds: 3),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 50.0, right: 50.0, bottom: 30.0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
              child: Row(
                children: const [
                  Text("Are you feeling better?  Are you more",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: values.keys.map((String key) {
                  return Row(
                    children: [
                      Text(
                        key,
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          value: values[key],
                          onChanged: (value) {
                            setState(() {
                              values[key] = value!;
                              selectedItems.clear();
                              values.forEach((key, value) {
                                if (value) {
                                  selectedItems.add(key);
                                }
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: const [
                  Text("Was this practice effective?",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            ),
            Row(
              children: [
                const Text('Yes :', style: TextStyle(color: Colors.white)),
                const Spacer(),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: Radio(
                    value: 1,
                    groupValue: _radioSelected,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        _radioSelected = value;
                        _radioVal = 'yes';
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('No :', style: TextStyle(color: Colors.white)),
                const Spacer(),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: Radio(
                    value: 2,
                    groupValue: _radioSelected,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        _radioSelected = value;
                        _radioVal = 'no';
                      });
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                width: 150.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff726094), // background
                    ),
                    onPressed: () {
                      setState(() {
                        isshowQuestion = false;
                        isConfetti = false;
                        isCircleAnimation = false;
                        isRestart = true;
                      });
                      RhythmicModel rhythmicModel = RhythmicModel(
                          techniqueId: Constants.techniqueId,
                          techniqueName: Constants.techniqueName,
                          createdAt: Constants.createdAt,
                          questions: [
                            Question(
                                id: Constants.questionId1,
                                question: Constants.question1,
                                options: Constants.option1,
                                answer: selectedItems),
                            Question(
                                id: Constants.questionId2,
                                question: Constants.question2,
                                options: Constants.option2,
                                answer: [_radioVal])
                          ]);
                      _provider.postData(rhythmicModel);
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget startAgain() {
    return AnimatedOpacity(
      opacity: isRestart ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _provider.totalData!.isEmpty
                    ? Text(" People found this technique effective")
                    : Text(
                        _provider.effectiveData!.length.toString() +
                            "/" +
                            _provider.totalData!.length.toString() +
                            " people found this technique effective",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Press Start to practice Again",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RhythmicBreathingProvider>(
          create: (context) => _provider,
          child: Consumer<RhythmicBreathingProvider>(
            builder: (context, provider, child) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.repeated,
                        colors: [
                      Color(0xff30818c),
                      Color(0xff656692),
                      Color(0xffc53b79),
                    ])),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Rhythmic Breathing Technique",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Press Start to practice",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                          child: Container(
                        height: 400.0,
                        width: 400.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.black,
                            border: Border.all(color: Colors.pink)),
                        child: Stack(
                          children: [
                            startAgain(),
                            questionAnswer(),
                            confettiWidget(),
                            circleAnimation(),
                          // circleAnimationWithBackground()
                          ],
                        ),
                      )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 150.0,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff726094), // background
                                ),
                                onPressed: () {
                                  if (!isAnimation) {
                                    setState(() {
                                      isAnimation = true;
                                      isCircleAnimation = true;
                                      isConfetti = false;
                                      isRestart = false;
                                      isshowQuestion = false;
                                      startTimer();
                                      cycle = 0;
                                      iteration = 0;
                                      controller.reset();
                                      controller.repeat();
                                      run(cycle!);
                                    });
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "START",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}

class Dot extends StatelessWidget {
  final double? radius;
  final Color? color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class CirclesPainter2 extends CustomPainter {
  CirclesPainter2(
      {required this.circles,
      required this.progress,
      required this.showDots,
      required this.showPath});

  final double circles, progress;
  bool showDots, showPath;

  var myPaint = Paint()
    ..color = Colors.purple
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  double radius = 80;

  @override
  void paint(Canvas canvas, Size size) {
    var path = createPath();
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * progress,
      );
      if (showPath) {
        canvas.drawPath(extractPath, myPaint);
      }
      if (showDots) {
        try {
          var metric = extractPath.computeMetrics().last;
          final offset = metric.getTangentForOffset(metric.length)?.position;
          canvas.drawCircle(offset!, 8.0, Paint());
        } catch (e) {}
      }
    }
  }

  Path createPath() {
    var path = Path();
    int n = circles.toInt();
    var range = List<int>.generate(n, (i) => i + 1);
    double angle = 2 * math.pi / n;
    for (int i in range) {
      double x = radius * math.cos(i * angle);
      double y = radius * math.sin(i * angle);
      path.addOval(Rect.fromCircle(center: Offset(x, y), radius: radius));
    }
    return path;
  }

  @override
  bool shouldRepaint(CirclesPainter2 oldDelegate) {
    return true;
  }
}
