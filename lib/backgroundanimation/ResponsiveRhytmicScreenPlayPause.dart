import 'dart:async';

import 'package:confetti/confetti.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rhythmicbreathingtechnique/Constants.dart';
import 'package:rhythmicbreathingtechnique/ResponsiveWidget.dart';
import 'package:rhythmicbreathingtechnique/model/RhythmicModel.dart';
import 'package:rhythmicbreathingtechnique/provider/RhythmicBreathingProvider.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../OpenPainter.dart';
import '../RhythmicBreathingTechniqueTesting.dart';
import '../ResponsiveCirclePainter.dart';

class ResponsiveRhythmicPlayPauseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResponsiveRhythmicPlayPauseState();
  }
}

class ResponsiveRhythmicPlayPauseState extends State<ResponsiveRhythmicPlayPauseScreen>
    with TickerProviderStateMixin {
  late RhythmicBreathingProvider _provider;
  bool start = false;
  bool isRestart = false;
  late Animation<double> animationRotation;
  late Animation<double> animationRotation2;
  late AnimationController controller;
  late AnimationController animation;
  late ConfettiController _controllerCenter;
  int sum = 0;
  bool isAnimation = false;
  bool isCircleAnimation = true;
  bool isshowQuestion = false;

  // final List<double> sizes = [10,15,15,10,10];//
  final List<double> sizes = [150, 250, 250, 150, 150];
  final List<double> centerCircleSizes = [40, 90, 90, 40, 40];
  final List<int> duration = [0, 2, 1, 2, 1];
  int iteration = 0;
  var w;
  var h;
  int? cycle;

  final List<String> textArray = [
    "",
    "Breathe in",
    "Hold",
    "Breathe out",
    "Hold",
  ];
  double progress = 0;
  int timerMaxSeconds = 0;
  int currentSeconds = 0;
  Timer? time;
  bool isPause=false;
  bool isConfetti = false;
  List<String> selectedItems = [];
  Map<String, bool> values = {
    'calm  :': false,
    'energetic :': false,
    'relaxed :': false,
    'focused :': false,
  };
  var _radioSelected;
  String _radioVal = "";

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
    timerMaxSeconds=sum*8;
    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(seconds: sum),
        vsync: this);
    //
    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
    // controller.forward();
    // controller.repeat();
    // animationRotation2 = Tween(begin: 0.0, end: 1.0).animate(
    //   AnimationController(vsync: this, duration: Duration(seconds: sum)),
    // );
    // animationRotation = Tween(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(
    //     parent: controller,
    //     curve: const Interval(0.0, 1.0, curve: Curves.linear),
    //   ),
    // );
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));
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
          isConfetti = true;
          isAnimation = false;
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

  @override
  Widget build(BuildContext context) {
    configWidth();

    return Scaffold(
        backgroundColor:const Color(0xFFE5E3E3),
        body: ChangeNotifierProvider<RhythmicBreathingProvider>(
            create: (context) => _provider,
            child: Consumer<RhythmicBreathingProvider>(
              builder: (context, provider, child) {
                return ResponsiveWidget.isSmallScreen(context)
                    ? Container(
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
                                  image: AssetImage(
                                      "assets/images/Background.jpg"),
                                  fit: BoxFit.cover),

                              /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                              border:
                                  Border.all(color: const Color(0xFFCADCD8))),
                          child: Column(
                            children: [
//
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(right: 20, top: 10),
                                      child: Image.asset(
                                        "assets/images/BreathTechnologies_Logo_White.png",

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
                              //breathing animation

                              isCircleAnimation ?
                              AnimatedOpacity(opacity: isCircleAnimation && !isPause?1:0,
                                     duration:const Duration(seconds: 1),
                                   child:Column(
                                    children: [
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
                                                          padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                          child: CustomPaint(
                                                            painter: OpenPainter(
                                                                height: h * 0.4,
                                                                width: h * 0.4),
                                                            //  child:  Dot(radius: 10.0,color: Colors.yellow,),

                                                            child: AnimatedContainer(
                                                              duration: !isPause?Duration(
                                                                  seconds: duration[
                                                                  iteration]):Duration(seconds: 0),
                                                              width: sizes[iteration],
                                                              height:
                                                              sizes[iteration],
                                                              child: CustomPaint(
                                                                painter: ResponsiveCirclePainter(
                                                                    text: textArray[
                                                                    iteration],
                                                                    breatheIn:
                                                                    double.parse(
                                                                        duration[1]
                                                                            .toString()),
                                                                    breatheOut:
                                                                    double.parse(
                                                                        duration[3]
                                                                            .toString()),
                                                                    hold1: double.parse(
                                                                        duration[2]
                                                                            .toString()),
                                                                    hold2: double.parse(
                                                                        duration[4]
                                                                            .toString()),
                                                                    progress:
                                                                    controller
                                                                        .value,isReset:false),
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
                                                                  math.cos(0.0 +
                                                                      3 *
                                                                          math.pi /
                                                                          2),
                                                              //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                              12 *
                                                                  9.5 *
                                                                  math.sin(0.0 +
                                                                      3 *
                                                                          math.pi /
                                                                          2),
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
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.12,
                                                      padding:
                                                     const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFF71B9E4),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              3),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xFF1B4F6D),
                                                              width: 1.0)),
                                                      child: const Text(
                                                        "Start",
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                            "PlayfairDisplay-Regular.ttf",
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (!isAnimation &&
                                                          !start) {
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
                                                          //controller.forward();
                                                         controller.repeat();
                                                          run(cycle!);
                                                          start = true;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: Container(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.12,
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              0xFF71B9E4),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              3),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xFF1B4F6D),
                                                              width: 1.0)),
                                                      child: const Text(
                                                        "pause",
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                            "PlayfairDisplay-Regular.ttf",
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      // if (!isAnimation &&
                                                      //     start) {
                                                        setState(() {

                                                          // isAnimation = true;
                                                          // isCircleAnimation = true;
                                                          // isConfetti = false;
                                                          // isRestart = false;
                                                          // isshowQuestion = false;
                                                          // startTimer();
                                                          // cycle = 0;
                                                          // iteration = 0;
                                                          // controller.reset();
                                                          isPause=false;
                                                          start = false;
                                                           controller.stop();
                                                         // controller.repeat();
                                                          //run(cycle!);

                                                        });
                                                    //  }
                                                    },
                                                  )
                                                ],
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.18,
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 12,
                                                    right: 12),
                                                decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xFFFF9000),
                                                    border: Border.all(color: const Color(0xFF1B4F6D),width: 2.0),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        3)),
                                                child: Text(
                                                  "${((timerMaxSeconds - currentSeconds)).toString() + ":00" //.padLeft(2, '0')
                                                  }",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      letterSpacing: 1.0,
                                                      color: const Color(
                                                          0xFFFFFFFF),
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              )
                                            ])),
                                      ),
                                    ],
                                  )):isConfetti?
                              confettiWidget(h * 0.55, w * 0.7):Expanded(child:questionAnswer(  h * 0.65, w ))



                            ],
                          ),
                        ),
                      )
                    : ResponsiveWidget.isMediumScreen(context)
                        ? Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                top: 5, left: 15.0, right: 15.0, bottom: 5.0),
                            color: Color(0xFF0E244A),
                            //Color(0xFFE5E3E3),
                            child: Container(
                              alignment: Alignment.center,
                              height: 505,
                              width: 550,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                //  color: const Color(0xffffffff),

                                /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                border:
                                    Border.all(color: const Color(0xFFCADCD8)),
                                image: const DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assets/images/Background.jpg")),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              right: 20, top: 5),
                                          child: Image.asset(
                                            "assets/images/breath.png",
                                            color: const Color(0xFF264E8F),
                                            height: 55.0,
                                            width: 55.0,
                                          ))
                                      // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
                                      ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10, top: 20),
                                    child: Text(
                                      "RHYTHMIC BREATHING TECHNIQUE",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily:
                                              "PlayfairDisplay-Regular.ttf",
                                          color: Color(0xFF264E8F),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  isCircleAnimation
                                      ?  AnimatedOpacity(opacity: isCircleAnimation?1:0,
                                      duration:const Duration(seconds: 1),
                                      child:Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child: Container(
                                                height: h * 0.55,
                                                width: w * 0.7,
                                                child: Center(
                                                    child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CustomPaint(
                                                          painter: OpenPainter(
                                                              height: h * 0.45,
                                                              width: h * 0.45),
                                                          child:
                                                              AnimatedContainer(
                                                            duration: Duration(
                                                                seconds: duration[
                                                                    iteration]),
                                                            width: sizes[
                                                                iteration],
                                                            height: sizes[
                                                                iteration],
                                                            child: CustomPaint(
                                                              painter: ResponsiveCirclePainter(
                                                                  text: textArray[
                                                                      iteration],
                                                                  breatheIn: double.parse(
                                                                      duration[1]
                                                                          .toString()),
                                                                  breatheOut: double.parse(
                                                                      duration[3]
                                                                          .toString()),
                                                                  hold1: double.parse(
                                                                      duration[2]
                                                                          .toString()),
                                                                  hold2: double.parse(
                                                                      duration[
                                                                              4]
                                                                          .toString()),
                                                                  progress:
                                                                      controller
                                                                          .value
                                                                  ,isReset:false),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    RotationTransition(
                                                      turns: animationRotation,
                                                      child:
                                                          Transform.translate(
                                                              child: Dot(
                                                                radius: 20,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              offset: Offset(
                                                                13 *
                                                                    9.5 *
                                                                    math.cos(0.0 +
                                                                        3 *
                                                                            math.pi /
                                                                            2),
                                                                //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                                13 *
                                                                    9.5 *
                                                                    math.sin(0.0 +
                                                                        3 *
                                                                            math.pi /
                                                                            2),
                                                              )),
                                                    ),
                                                  ],
                                                )),
                                              )),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0,
                                                          bottom: 15.0),
                                                  child: Column(children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        GestureDetector(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xFF71B9E4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                                border:
                                                                    Border.all(
                                                                        color: const Color(
                                                                            0xFF1B4F6D),
                                                                        width:
                                                                            1.0)),
                                                            child: const Text(
                                                              "Start",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "PlayfairDisplay-Regular.ttf",
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            if (!isAnimation &&
                                                                !start) {
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
                                                                start = true;
                                                              });
                                                            }
                                                          },
                                                        ),
                                                        GestureDetector(
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xFF71B9E4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                                border:
                                                                    Border.all(
                                                                        color: const Color(
                                                                            0xFF1B4F6D),
                                                                        width:
                                                                            1.0)),
                                                            child: const Text(
                                                              "Replay",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:TextStyle(
                                                                  fontFamily:
                                                                      "PlayfairDisplay-Regular.ttf",
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            if (!isAnimation &&
                                                                start) {
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
                                                                start = false;
                                                              });
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      padding: const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 12,
                                                          right: 12),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFFF9000),
                                                          border: Border.all(color: const Color(0xFF1B4F6D),width: 1.0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                      child: Text(
                                                        "${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')+":00"}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            letterSpacing: 1.0,
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    )
                                                  ])),
                                            ),
                                          ],
                                        )):

                                  isConfetti?confettiWidget(100, 100)
                                      : Expanded(child: questionAnswer(h * 0.55, w * 0.5,)),
                                  //confettiWidget( h * 0.55,w * 0.7)
                                ],
                              ),
                            ))
                        : Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                top: 5, left: 15.0, right: 15.0, bottom: 5.0),
                            color: Color(0xFF0E244A),
                            //Color(0xFFE5E3E3),

                            child: Container(
                              alignment: Alignment.center,
                              height: 550,
                              width: 750,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.0),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/Background.jpg"),
                                      fit: BoxFit.cover),

                                  //  color: const Color(0xffffffff),

                                  /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                  border: Border.all(
                                      color: const Color(0xFFCADCD8))),
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              right: 20, top: 5),
                                          child: Image.asset(
                                            "assets/images/breath.png",
                                            color: const Color(0xFF264E8F),
                                            height: 80.0,
                                            width: 80.0,
                                          ))
                                      // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
                                      ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10, top: 15.0),
                                    child: Text(
                                      "RHYTHMIC BREATHING TECHNIQUE",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily:
                                              "PlayfairDisplay-Regular.ttf",
                                          color: Color(0xFF264E8F),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  isCircleAnimation?
                                  AnimatedOpacity(opacity: isCircleAnimation?1:0,
                                      duration:const Duration(seconds: 1),
                                      child:
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                            child: Container(
                                          height: h * 0.5,
                                          width: w * 0.7,
                                          child: Center(
                                              child: Stack(
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CustomPaint(
                                                    painter: OpenPainter(
                                                        height: h * 0.45,
                                                        width: h * 0.45),
                                                    child: AnimatedContainer(
                                                      duration: Duration(
                                                          seconds: duration[
                                                              iteration]),
                                                      width: sizes[iteration],
                                                      height: sizes[iteration],
                                                      child: CustomPaint(
                                                        painter: ResponsiveCirclePainter(
                                                            text: textArray[
                                                                iteration],
                                                            breatheIn: double.parse(
                                                                duration[1]
                                                                    .toString()),
                                                            breatheOut:
                                                                double.parse(
                                                                    duration[3]
                                                                        .toString()),
                                                            hold1: double.parse(
                                                                duration[2]
                                                                    .toString()),
                                                            hold2: double.parse(
                                                                duration[4]
                                                                    .toString()),
                                                            progress: controller
                                                                .value,
                                                            isReset:false),
                                                        // child: Padding(
                                                        //   padding:
                                                        //       const EdgeInsets.all(
                                                        //           8.0),
                                                        //   child: CustomPaint(
                                                        //       painter: OpenPainter(
                                                        //           height: h * 0.45,
                                                        //           width: h * 0.45)
                                                        //       //  child:  Dot(radius: 10.0,color: Colors.yellow,),
                                                        //       ),
                                                        // ),
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
                                                      14 *
                                                          9.5 *
                                                          math.cos(0.0 +
                                                              3 * math.pi / 2),
                                                      //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                      14 *
                                                          9.5 *
                                                          math.sin(0.0 +
                                                              3 * math.pi / 2),
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
                                                top: 5.0, bottom: 15.0),
                                            child: Column(children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFF71B9E4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xFF1B4F6D),
                                                              width: 1.0)),
                                                      child:const  Text(
                                                        "Start",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "PlayfairDisplay-Regular.ttf",
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (!isAnimation &&
                                                          !start) {
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

                                                          start = true;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFF71B9E4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xFF1B4F6D),
                                                              width: 1.0)),
                                                      child: const Text(
                                                        "Replay",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style:  TextStyle(
                                                            fontFamily:
                                                                "PlayfairDisplay-Regular.ttf",
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (!isAnimation &&
                                                          start) {
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
                                                          start = false;
                                                        });
                                                      }
                                                    },
                                                  )
                                                ],
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.07,
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 12,
                                                    right: 12),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFF9000),
                                                    border: Border.all(color: const Color(0xFF1B4F6D),width: 1.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                                child: Text(
                                                  "${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0') + ":00"}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      letterSpacing: 1.0,
                                                      color:  Color(
                                                          0xFFFFFFFF),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ])),
                                      ),
                                    ],
                                  )) :isConfetti?confettiWidget(200, 300):
                                  Expanded(child: questionAnswer( h * 0.5, w * 0.4,)),
                                ],
                              ),
                            ));
              },
            )));
  }

  Widget questionAnswer(height, width) {
    return AnimatedOpacity(
      opacity: isshowQuestion?1.0:0,
      duration: const Duration(seconds: 3),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.only(
            left: 30.0, right: 30.0, bottom: 30.0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 10.0),
              child: Row(
                children: const [
                  Text("Are you feeling better?  Are you more",
                      style: TextStyle(
                          color: Color(0xFF264E8F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: values.keys.map((String key) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        key,
                        style: TextStyle(color: Color(0xFF264E8F)),
                      ),
                     // Spacer(),
                      Theme(
                        data:
                            ThemeData(unselectedWidgetColor: Color(0xFF264E8F)),
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
                          color: Color(0xFF264E8F),
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            ),
            Row(
              children: [
                const Text('Yes :', style: TextStyle(color: Color(0xFF264E8F))),
                const Spacer(),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Color(0xFF264E8F)),
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
                const Text('No :', style: TextStyle(color: Color(0xFF264E8F))),
                const Spacer(),
                Theme(
                  data: ThemeData(unselectedWidgetColor: Color(0xFF264E8F)),
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
                        isCircleAnimation = true;
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

  Widget confettiWidget(double height, double width) {
    return AnimatedOpacity(
      opacity: isConfetti?1:0,
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
      // Container(
      //  height: height,
      //   width: width,
      //   margin: EdgeInsets.all(10),
      //   child:
      // ),
    );
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.stop();
    controller.dispose();
  }
}
