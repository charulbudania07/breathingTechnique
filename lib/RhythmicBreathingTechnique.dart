import 'dart:async';
import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhythmicbreathingtechnique/CirclePainter.dart';
import 'package:rhythmicbreathingtechnique/CircleRedPainter.dart';
import 'package:rhythmicbreathingtechnique/Constants.dart';
import 'package:rhythmicbreathingtechnique/model/RhythmicModel.dart';
import 'package:rhythmicbreathingtechnique/provider/RhythmicBreathingProvider.dart';

import 'OpenPainter.dart';
import 'ResponsiveCirclePainter.dart';
import 'ResponsiveWidget.dart';

class RhythmicBreathingTechnique extends StatefulWidget {
  const RhythmicBreathingTechnique({Key? key}) : super(key: key);

  @override
  _RhythmicBreathingTechniqueState createState() =>
      _RhythmicBreathingTechniqueState();
}

class _RhythmicBreathingTechniqueState extends State<RhythmicBreathingTechnique>
    with TickerProviderStateMixin {
  late RhythmicBreathingProvider _provider;
  late ConfettiController _controllerCenter;
  final List<double> sizes = [150, 250, 250, 150, 150];
  final List<double> centerCircleSizes = [40, 90, 90, 40, 40];
  final List<int> duration = [0, 4, 4, 4, 4];
  var w; var h;
  bool start = false;
  final List<String> textArray = [
    "",
    "Breathe in",
    "Hold",
    "Breathe out",
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
  void configWidth() {
    if (ResponsiveWidget.isSmallScreen(context)) {
      w = 360.0;
      h = 505.0;
      sizes.clear();
      sizes.add(w * 0.25);
      sizes.add(w * 0.4);
      sizes.add(w * 0.4);
      sizes.add(w * 0.25);
      sizes.add(w * 0.25);
    } else if (ResponsiveWidget.isMediumScreen(context)) {
      w = 768.0;
      h = 505.0;
      sizes.clear();
      sizes.add(h * 0.21);
      sizes.add(h * 0.35);
      sizes.add(h * 0.35);
      sizes.add(h * 0.21);
      sizes.add(h * 0.21);
    } else {
      w = 1025;
      h = 561;

      sizes.clear();
      sizes.add(h * 0.20);
      sizes.add(h * 0.35);
      sizes.add(h * 0.35);
      sizes.add(h * 0.20);
      sizes.add(h * 0.35);
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
  //  print("abc"+ math.cos(0.0 + 3 * math.pi / 2).toString());

    // _circleRedPainter= CircleRedPainter(
    //     text: textArray[iteration],
    //     breatheIn: double.parse(duration[1].toString()),
    //     breatheOut: double.parse(duration[3].toString()),
    //     hold1: double.parse(duration[2].toString()),
    //     hold2: double.parse(duration[4].toString()));
    return AnimatedOpacity(
      opacity: isCircleAnimation ? 1 : 0,
      duration: const Duration(seconds: 1),
      child: Stack(
        children: [
          Positioned(
              top: 350,
              left: 50,
              right: 50,
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


               Center(child:
              Stack(
                children: [
              Center(
              child:AnimatedContainer(
              duration: Duration(seconds: duration[iteration]),
                 width: sizes[iteration],
                 height: sizes[iteration],
                 child: CustomPaint(
                   painter: QuadrantCirclePainter(
                       text: textArray[iteration],
                       breatheIn: double.parse(duration[1].toString()),
                       breatheOut: double.parse(duration[3].toString()),
                       hold1: double.parse(duration[2].toString()),
                       hold2: double.parse(duration[4].toString())),
                 ),


              ),),
]
                ),),

                // RotationTransition(
                //   turns: animationRotation,
                //   child: Transform.translate(
                //       child: Dot(
                //         radius: dotRadius,
                //         color: Colors.red,
                //       ),
                //       offset: Offset(
                //         dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                //         //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                //         dotRadius * 9.5 * math.sin(0.0 +3 * math.pi / 2),
                //       )),
                //
                // )
          /*
          RotationTransition(
            turns: animationRotation,
            child: Transform.translate(
                child: Dot(
                  radius: dotRadius,
                  color: Colors.red,
                ),
                offset: Offset(
                  dotRadius * 9.5 * math.cos(0.0 + 2.5 * math.pi / 2),
                  //dotRadius * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                  dotRadius * 9.5 * math.sin(0.0 +2.5 * math.pi / 2),
                )),

          ),*/
        ],
      ),
    );

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
              padding: const EdgeInsets.only(bottom: 8.0,top: 10.0),
              child: Row(
                children: const [
                  Text("Are you feeling better?  Are you more",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: values.keys.map((String key) {
                  return Row(
                      children: [

                        Text(key,style: TextStyle(color: Colors.white),),
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
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: const [
                  Text("Was this practice effective?",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16)),
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

  Widget Startagain() {
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
               _provider.totalData!.isEmpty ?  Text(" People found this technique effective") :
               Text(
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
    configWidth();
    return Scaffold(
      body:
      ChangeNotifierProvider<RhythmicBreathingProvider>(
          create: (context) => _provider,
          child: Consumer<RhythmicBreathingProvider>(
            builder: (context, provider, child) {
              return 
                SingleChildScrollView(
                  child: Container(
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
                              Startagain(),
                              questionAnswer(),
                              confettiWidget(),
                              // ResponsiveWidget.isSmallScreen(context)
                              //     ?
                              Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0E244A),
                                ),
                                padding: EdgeInsets.only(
                                    top: 5, left: 15.0, right: 15.0, bottom: 5.0),

                                child: Container(
                                  alignment: Alignment.center,
                                  height: 505,
                                  width: 360,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                      //color:Colors.white,
                                      image: const DecorationImage(
                                          image: AssetImage("assets/images/Background.jpg"),
                                          fit: BoxFit.cover),

                                      /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                      border:
                                      Border.all(color: const Color(0xFFCADCD8))),
                                  child: Column(
                                    children: [

                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                              margin:
                                              EdgeInsets.only(right: 20, top: 10),
                                              child: Image.asset(
                                                "assets/images/breath.png",
                                                color: const Color(0xFF264E8F),
                                                height: 50.0,
                                                width: 50.0,
                                              ))
                                        // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 10, top: 25.0),
                                        child: Text(
                                          "RHYTHMIC BREATHING TECHNIQUE",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontFamily: "PlayfairDisplay-Regular.ttf",
                                              color: Color(0xFF264E8F),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                            child: Container(
                                              height: h * 0.55,
                                              width: w * 0.7,
                                              child: Center(
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: CustomPaint(
                                                            painter: OpenPainter(
                                                                height: h * 0.4,
                                                                width: h * 0.4),
                                                            //  child:  Dot(radius: 10.0,color: Colors.yellow,),

                                                            child: AnimatedContainer(
                                                              duration: Duration(
                                                                  seconds: duration[iteration]),
                                                              width: sizes[iteration],
                                                              height: sizes[iteration],
                                                              child: CustomPaint(
                                                                painter: ResponsiveCirclePainter(
                                                                    text: textArray[iteration],
                                                                    breatheIn: double.parse(
                                                                        duration[1].toString()),
                                                                    breatheOut: double.parse(
                                                                        duration[3].toString()),
                                                                    hold1: double.parse(
                                                                        duration[2].toString()),
                                                                    hold2: double.parse(
                                                                        duration[4].toString()),
                                                                    progress: controller.value,  isReset: false),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      RotationTransition(
                                                        turns: animationRotation,
                                                        child: Transform.translate(
                                                            child: Dot(
                                                              radius: 20,
                                                              color: Colors.red,
                                                            ),
                                                            offset: Offset(
                                                              12 *
                                                                  9.5 *
                                                                  math.cos(
                                                                      0.0 + 3 * math.pi / 2),
                                                              //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                              12 *
                                                                  9.5 *
                                                                  math.sin(
                                                                      0.0 + 3 * math.pi / 2),
                                                            )),
                                                      ),
                                                    ],
                                                  )),
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, bottom: 30.0),
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.12,
                                                      padding: EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                          color: Color(0xFF71B9E4),
                                                          borderRadius:
                                                          BorderRadius.circular(3),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xFF1B4F6D),
                                                              width: 1.0)),
                                                      child: Text(
                                                        "Start",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                            "PlayfairDisplay-Regular.ttf",
                                                            color: Color(0xFFFFFFFF),
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (!isAnimation && !start) {
                                                        setState(() {
                                                          isAnimation = true;
                                                          isCircleAnimation = true;
                                                          isConfetti = false;
                                                          startTimer();
                                                          cycle = 0;
                                                          iteration = 0;
                                                          controller.reset();
                                                          controller.repeat();
                                                          run(cycle!);
                                                          start = true;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: Container(
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.12,
                                                      padding:
                                                      const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                          color: Color(0xFF71B9E4),
                                                          borderRadius:
                                                          BorderRadius.circular(3),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xFF1B4F6D),
                                                              width: 1.0)),
                                                      child: Text(
                                                        "Replay",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                            "PlayfairDisplay-Regular.ttf",
                                                            color: Color(0xFFFFFFFF),
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (!isAnimation && start) {
                                                        setState(() {
                                                          isAnimation = true;
                                                          isCircleAnimation = true;
                                                          isConfetti = false;
                                                          startTimer();
                                                          cycle = 0;
                                                          iteration = 0;
                                                          controller.reset();
                                                          controller.repeat();
                                                          run(cycle!);
                                                          start = false;
                                                        });
                                                      }
                                                    },
                                                  )
                                                ],
                                              ),
                                              Container(
                                                width:
                                                MediaQuery.of(context).size.width *
                                                    0.18,
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 12,
                                                    right: 12),
                                                decoration: BoxDecoration(
                                                    color: const Color(0xFFFF9000),
                                                    border: Border.all(
                                                        color: const Color(0xFF71B9E4)),
                                                    borderRadius:
                                                    BorderRadius.circular(3)),
                                                child: Text(
                                                  "${((timerMaxSeconds - currentSeconds)).toString()+":00"//.padLeft(2, '0')
                                                  }",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      letterSpacing: 1.0,
                                                      color: const Color(0xFFFFFFFF),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              )
                                            ])),
                                      ),
                                    ],
                                  ),
                                ),
                                // Stack(
                                //   children: [
                                //     Container(
                                //       alignment: Alignment.center,
                                //       height: 505,
                                //       width: 360,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(2.0),
                                //           //color:Colors.white,
                                //           image: const DecorationImage(
                                //               image: AssetImage("assets/images/Background.jpg"),
                                //               fit: BoxFit.cover),
                                //
                                //           /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                //           border:
                                //           Border.all(color: const Color(0xFFCADCD8))),
                                //       child: Column(
                                //         children: [
                                //
                                //           Align(
                                //               alignment: Alignment.topRight,
                                //               child: Container(
                                //                   margin:
                                //                   EdgeInsets.only(right: 20, top: 10),
                                //                   child: Image.asset(
                                //                     "assets/images/breath.png",
                                //                     color: const Color(0xFF264E8F),
                                //                     height: 50.0,
                                //                     width: 50.0,
                                //                   ))
                                //             // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
                                //           ),
                                //           const Padding(
                                //             padding: EdgeInsets.only(
                                //                 left: 10.0, right: 10, top: 25.0),
                                //             child: Text(
                                //               "RHYTHMIC BREATHING TECHNIQUE",
                                //               textAlign: TextAlign.center,
                                //               style: TextStyle(
                                //                   fontStyle: FontStyle.normal,
                                //                   fontFamily: "PlayfairDisplay-Regular.ttf",
                                //                   color: Color(0xFF264E8F),
                                //                   fontWeight: FontWeight.bold,
                                //                   fontSize: 20),
                                //             ),
                                //           ),
                                //           Padding(
                                //             padding: const EdgeInsets.all(5.0),
                                //             child: Center(
                                //                 child: Container(
                                //                   height: h * 0.55,
                                //                   width: w * 0.7,
                                //                   child: Center(
                                //                       child: Stack(
                                //                         children: [
                                //                           Center(
                                //                             child: Padding(
                                //                               padding: const EdgeInsets.all(8.0),
                                //                               child: CustomPaint(
                                //                                 painter: OpenPainter(
                                //                                     height: h * 0.4,
                                //                                     width: h * 0.4),
                                //                                 //  child:  Dot(radius: 10.0,color: Colors.yellow,),
                                //
                                //                                 child: AnimatedContainer(
                                //                                   duration: Duration(
                                //                                       seconds: duration[iteration]),
                                //                                   width: sizes[iteration],
                                //                                   height: sizes[iteration],
                                //                                   child: CustomPaint(
                                //                                     painter: ResponsiveCirclePainter(
                                //                                         text: textArray[iteration],
                                //                                         breatheIn: double.parse(
                                //                                             duration[1].toString()),
                                //                                         breatheOut: double.parse(
                                //                                             duration[3].toString()),
                                //                                         hold1: double.parse(
                                //                                             duration[2].toString()),
                                //                                         hold2: double.parse(
                                //                                             duration[4].toString()),
                                //                                         progress: controller.value),
                                //                                   ),
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                           RotationTransition(
                                //                             turns: animationRotation,
                                //                             child: Transform.translate(
                                //                                 child: Dot(
                                //                                   radius: 20,
                                //                                   color: Colors.red,
                                //                                 ),
                                //                                 offset: Offset(
                                //                                   12 *
                                //                                       9.5 *
                                //                                       math.cos(
                                //                                           0.0 + 3 * math.pi / 2),
                                //                                   //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                //                                   12 *
                                //                                       9.5 *
                                //                                       math.sin(
                                //                                           0.0 + 3 * math.pi / 2),
                                //                                 )),
                                //                           ),
                                //                         ],
                                //                       )),
                                //                 )),
                                //           ),
                                //           Align(
                                //             alignment: Alignment.bottomCenter,
                                //             child: Padding(
                                //                 padding: const EdgeInsets.only(
                                //                     top: 5.0, bottom: 30.0),
                                //                 child: Column(children: [
                                //                   Row(
                                //                     mainAxisAlignment:
                                //                     MainAxisAlignment.spaceAround,
                                //                     children: [
                                //                       GestureDetector(
                                //                         child: Container(
                                //                           width: MediaQuery.of(context)
                                //                               .size
                                //                               .width *
                                //                               0.12,
                                //                           padding: EdgeInsets.all(8.0),
                                //                           decoration: BoxDecoration(
                                //                               color: Color(0xFF71B9E4),
                                //                               borderRadius:
                                //                               BorderRadius.circular(3),
                                //                               border: Border.all(
                                //                                   color: const Color(
                                //                                       0xFF1B4F6D),
                                //                                   width: 1.0)),
                                //                           child: Text(
                                //                             "Start",
                                //                             textAlign: TextAlign.center,
                                //                             style: const TextStyle(
                                //                                 fontFamily:
                                //                                 "PlayfairDisplay-Regular.ttf",
                                //                                 color: Color(0xFFFFFFFF),
                                //                                 fontSize: 14,
                                //                                 fontWeight:
                                //                                 FontWeight.bold),
                                //                           ),
                                //                         ),
                                //                         onTap: () {
                                //                           if (!isAnimation && !start) {
                                //                             setState(() {
                                //                               isAnimation = true;
                                //                               isCircleAnimation = true;
                                //                               isConfetti = false;
                                //                               startTimer();
                                //                               cycle = 0;
                                //                               iteration = 0;
                                //                               controller.reset();
                                //                               controller.repeat();
                                //                               run(cycle!);
                                //                               start = true;
                                //                             });
                                //                           }
                                //                         },
                                //                       ),
                                //                       GestureDetector(
                                //                         child: Container(
                                //                           width: MediaQuery.of(context)
                                //                               .size
                                //                               .width *
                                //                               0.12,
                                //                           padding:
                                //                           const EdgeInsets.all(8.0),
                                //                           decoration: BoxDecoration(
                                //                               color: Color(0xFF71B9E4),
                                //                               borderRadius:
                                //                               BorderRadius.circular(3),
                                //                               border: Border.all(
                                //                                   color: const Color(
                                //                                       0xFF1B4F6D),
                                //                                   width: 1.0)),
                                //                           child: Text(
                                //                             "Replay",
                                //                             textAlign: TextAlign.center,
                                //                             style: const TextStyle(
                                //                                 fontFamily:
                                //                                 "PlayfairDisplay-Regular.ttf",
                                //                                 color: Color(0xFFFFFFFF),
                                //                                 fontSize: 14,
                                //                                 fontWeight:
                                //                                 FontWeight.bold),
                                //                           ),
                                //                         ),
                                //                         onTap: () {
                                //                           if (!isAnimation && start) {
                                //                             setState(() {
                                //                               isAnimation = true;
                                //                               isCircleAnimation = true;
                                //                               isConfetti = false;
                                //                               startTimer();
                                //                               cycle = 0;
                                //                               iteration = 0;
                                //                               controller.reset();
                                //                               controller.repeat();
                                //                               run(cycle!);
                                //                               start = false;
                                //                             });
                                //                           }
                                //                         },
                                //                       )
                                //                     ],
                                //                   ),
                                //                   Container(
                                //                     width:
                                //                     MediaQuery.of(context).size.width *
                                //                         0.18,
                                //                     padding: const EdgeInsets.only(
                                //                         top: 8,
                                //                         bottom: 8,
                                //                         left: 12,
                                //                         right: 12),
                                //                     decoration: BoxDecoration(
                                //                         color: const Color(0xFFFF9000),
                                //                         border: Border.all(
                                //                             color: const Color(0xFF71B9E4)),
                                //                         borderRadius:
                                //                         BorderRadius.circular(3)),
                                //                     child: Text(
                                //                       "${((timerMaxSeconds - currentSeconds)).toString()+":00"//.padLeft(2, '0')
                                //                       }",
                                //                       textAlign: TextAlign.center,
                                //                       style: const TextStyle(
                                //                           letterSpacing: 1.0,
                                //                           color: const Color(0xFFFFFFFF),
                                //                           fontSize: 14,
                                //                           fontWeight: FontWeight.normal),
                                //                     ),
                                //                   )
                                //                 ])),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   //  confettiWidget()
                                //   ],
                                // )



                              )
                             // circleAnimation(),
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
