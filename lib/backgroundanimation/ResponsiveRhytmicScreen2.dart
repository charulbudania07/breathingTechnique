import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rhythmicbreathingtechnique/ResponsiveWidget.dart';
import 'package:rhythmicbreathingtechnique/provider/RhythmicBreathingProvider.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../OpenPainter.dart';
import '../RhythmicBreathingTechniqueTesting.dart';
import '../ResponsiveCirclePainter.dart';

class ResponsiveRhythmicScreen2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResponsiveRhythmic2State();
  }
}

class ResponsiveRhythmic2State extends State<ResponsiveRhythmicScreen2>
    with TickerProviderStateMixin {
  late RhythmicBreathingProvider _provider;

  late Animation<double> animationRotation;
  late Animation<double> animationRotation2;
  late AnimationController controller;
  late AnimationController animation;
  late ConfettiController _controllerCenter;
  int sum = 0;
  bool isAnimation = false;
  bool isCircleAnimation = true;

  // final List<double> sizes = [10,15,15,10,10];//
  final List<double> sizes = [150, 250, 250, 150, 150];
  final List<double> centerCircleSizes = [40, 90, 90, 40, 40];
  final List<int> duration = [0, 2, 1, 2, 1];
  int iteration = 0;
  var w;
  int? cycle;
  var h;
  final List<String> textArray = [
    "",
    "Breathe in",
    "Hold",
    "Breathe out",
    "Hold",
  ];
  double progress = 0;
  int timerMaxSeconds = 54;
  int currentSeconds = 0;
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
    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
    // _controllerCenter =
    //     ConfettiController(duration: const Duration(seconds: 3));
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
          isCircleAnimation = false;
        });
      }
    }
  }
void configWidth(){
    if(ResponsiveWidget.isSmallScreen(context)){
      w = 360.0;
      h = 505.0;
      sizes.clear();
      sizes.add(w * 0.25);
      sizes.add(w * 0.4);
      sizes.add(w * 0.4);
      sizes.add(w * 0.25);
      sizes.add(w * 0.25);
    }else if(ResponsiveWidget.isMediumScreen(context)){
      w = 768.0;
      h = 505.0;
      sizes.clear();
      sizes.add(h * 0.21);
      sizes.add(h * 0.35);
      sizes.add(h * 0.35);
      sizes.add(h * 0.21);
      sizes.add(h * 0.21);
    }else{
      w= 1025; h=561;

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
      backgroundColor: Color(0xFFE5E3E3),
      body: ChangeNotifierProvider<RhythmicBreathingProvider>(
          create: (context) => _provider,
          child: Consumer<RhythmicBreathingProvider>(
            builder: (context, provider, child) {
              return ResponsiveWidget.isSmallScreen(context)?
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 5,left: 15.0, right:15.0, bottom: 5.0),
              color: Color(0xFFE5E3E3),
              child:

                Container(
                alignment: Alignment.center,
                height: 505,
                width:360,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: const Color(0xffffffff),
                    /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                    border: Border.all(color:const Color(
                        0xFFCADCD8))),

                child:

                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0,right: 10, top: 25.0),
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
                    Align(
                      alignment: Alignment.topRight,

                      child:Container(
                        margin: EdgeInsets.only(right: 20, top: 10),
                        child: Image.asset("assets/images/breath.png",color: const Color(0xFF264E8F), height: 50.0,width: 50.0,))
                     // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                          child: Container(
                        height: h*0.55 ,
                        width: w*0.7 ,

                        child: Center(
                            child: Stack(
                          children: [
                            Center(
                              child: AnimatedContainer(
                                duration:
                                    Duration(seconds: duration[iteration]),
                                width: sizes[iteration],
                                height: sizes[iteration],
                                child: CustomPaint(
                                  painter: ResponsiveCirclePainter(
                                      text: textArray[iteration],
                                      breatheIn:
                                          double.parse(duration[1].toString()),
                                      breatheOut:
                                          double.parse(duration[3].toString()),
                                      hold1:
                                          double.parse(duration[2].toString()),
                                      hold2:
                                          double.parse(duration[4].toString()),
                                      progress: controller.value,
                                      isReset:false),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomPaint(painter: OpenPainter(height: h*0.42,width: h*0.42)
                                      //  child:  Dot(radius: 10.0,color: Colors.yellow,),
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
                                    12 * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                                    //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                    12 * 9.5 * math.sin(0.0 + 3 * math.pi / 2),
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
                              const EdgeInsets.only(top: 5.0, bottom: 30.0),
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    width:MediaQuery.of(context).size.width*0.12,
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF71B9E4),
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: const Color(0xFF1B4F6D),
                                            width: 1.0)),
                                    child: Text(
                                      "Start",

                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "PlayfairDisplay-Regular.ttf",
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isAnimation) {
                                      setState(() {
                                        isAnimation = true;
                                        isCircleAnimation = true;

                                        startTimer();
                                        cycle = 0;
                                        iteration = 0;
                                        controller.reset();
                                        controller.repeat();
                                        run(cycle!);
                                      });
                                    }
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    width:MediaQuery.of(context).size.width*0.12,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF71B9E4),
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: const Color(0xFF1B4F6D),
                                            width: 1.0)),
                                    child: Text(
                                      "Replay",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: "PlayfairDisplay-Regular.ttf",
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  onTap: () {
                                    if (!isAnimation) {
                                      setState(() {
                                        isAnimation = true;
                                        isCircleAnimation = true;

                                        startTimer();
                                        cycle = 0;
                                        iteration = 0;
                                        controller.reset();
                                        controller.repeat();
                                        run(cycle!);
                                      });
                                    }
                                  },
                                )
                              ],
                            ),
                            Container(
                              width:MediaQuery.of(context).size.width*0.12,
                              padding: EdgeInsets.only(top:8,bottom: 8, left: 12,right: 12),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFF9000),
                                  border: Border.all(
                                      color: const Color(0xFF71B9E4)),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Text(
                                "${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    letterSpacing: 1.0,
                                    color: const Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ])

                          ),
                    ),
                  ],
                ),
              )):
              ResponsiveWidget.isMediumScreen(context)?

              // Container(
              //     alignment: Alignment.center,
              //     height: MediaQuery.of(context).size.height,
              //     width: MediaQuery.of(context).size.width,
              //     padding: EdgeInsets.all(10),
              //     color: Color(0xFFE5E3E3),
              //     child:
              //
              //     Container(
              //       alignment: Alignment.center,
              //       height: 505,
              //       width:668.0,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(2.0),
              //           color: const Color(0xffffffff),
              //           /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
              //           border: Border.all(color:const Color(
              //               0xFFCADCD8))),
              //
              //       child:
              //
              //       Column(
              //         children: [
              //           const Padding(
              //             padding: EdgeInsets.all(10.0),
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
              //           Align(
              //               alignment: Alignment.topRight,
              //
              //               child:Container(
              //                   margin: EdgeInsets.only(right: 20, top: 10),
              //                   child: Image.asset("assets/images/breath.png",color: const Color(0xFF264E8F), height: 50.0,width: 50.0,))
              //             // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
              //           ),
              //
              //           Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Center(
              //                 child: Container(
              //                   height: h*0.7,
              //                   width: w*0.5,
              //
              //                   child: Center(
              //                       child: Stack(
              //                         children: [
              //                           Center(
              //                             child: AnimatedContainer(
              //                               duration:
              //                               Duration(seconds: duration[iteration]),
              //                               width: sizes[iteration],
              //                               height: sizes[iteration],
              //                               child: CustomPaint(
              //                                 painter: TestCirclePainter(
              //                                     text: textArray[iteration],
              //                                     breatheIn:
              //                                     double.parse(duration[1].toString()),
              //                                     breatheOut:
              //                                     double.parse(duration[3].toString()),
              //                                     hold1:
              //                                     double.parse(duration[2].toString()),
              //                                     hold2:
              //                                     double.parse(duration[4].toString()),
              //                                     progress: controller.value),
              //                                 // child: Padding(
              //                                 //   padding: const EdgeInsets.all(8.0),
              //                                 //   child: CustomPaint(painter: OpenPainter()
              //                                 //       //  child:  Dot(radius: 10.0,color: Colors.yellow,),
              //                                 //       ),
              //                                 // ),
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
              //                                   14 * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
              //                                   //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
              //                                   14 * 9.5 * math.sin(0.0 + 3 * math.pi / 2),
              //                                 )),
              //                           ),
              //                         ],
              //                       )),
              //                 )),
              //           ),
              //           Align(
              //             alignment: Alignment.bottomCenter,
              //             child: Padding(
              //                 padding:
              //                 const EdgeInsets.only(top: 10.0, bottom: 30.0),
              //                 child: Column(children: [
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                     children: [
              //                       GestureDetector(
              //                         child: Container(
              //                           padding: EdgeInsets.all(8.0),
              //                           decoration: BoxDecoration(
              //                               color: Color(0xFF71B9E4),
              //                               borderRadius: BorderRadius.circular(3),
              //                               border: Border.all(
              //                                   color: const Color(0xFF1B4F6D),
              //                                   width: 1.0)),
              //                           child: Text(
              //                             "Start",
              //
              //                             textAlign: TextAlign.center,
              //                             style: const TextStyle(
              //                                 fontFamily: "PlayfairDisplay-Regular.ttf",
              //                                 color: Color(0xFFFFFFFF),
              //                                 fontSize: 14,
              //                                 fontWeight: FontWeight.normal),
              //                           ),
              //                         ),
              //                         onTap: () {
              //                           if (!isAnimation) {
              //                             setState(() {
              //                               isAnimation = true;
              //                               isCircleAnimation = true;
              //
              //                               startTimer();
              //                               cycle = 0;
              //                               iteration = 0;
              //                               controller.reset();
              //                               controller.repeat();
              //                               run(cycle!);
              //                             });
              //                           }
              //                         },
              //                       ),
              //                       GestureDetector(
              //                         child: Container(
              //                           padding: EdgeInsets.all(8.0),
              //                           decoration: BoxDecoration(
              //                               color: Color(0xFF71B9E4),
              //                               borderRadius: BorderRadius.circular(3),
              //                               border: Border.all(
              //                                   color: const Color(0xFF1B4F6D),
              //                                   width: 1.0)),
              //                           child: Text(
              //                             "Replay",
              //                             textAlign: TextAlign.center,
              //                             style: const TextStyle(
              //                                 fontFamily: "PlayfairDisplay-Regular.ttf",
              //                                 color: Color(0xFFFFFFFF),
              //                                 fontSize: 14,
              //                                 fontWeight: FontWeight.normal),
              //                           ),
              //                         ),
              //                         onTap: () {},
              //                       )
              //                     ],
              //                   ),
              //                   Container(
              //                     width: 80.0,
              //                     padding: EdgeInsets.only(top:8,bottom: 8, left: 12,right: 12),
              //                     decoration: BoxDecoration(
              //                         color: const Color(0xFFFF9000),
              //                         border: Border.all(
              //                             color: const Color(0xFF71B9E4)),
              //                         borderRadius: BorderRadius.circular(3)),
              //                     child: Text(
              //                       "${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')}",
              //                       textAlign: TextAlign.center,
              //                       style: const TextStyle(
              //                           letterSpacing: 1.0,
              //                           color: const Color(0xFFFFFFFF),
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.normal),
              //                     ),
              //                   )
              //                 ])
              //
              //             ),
              //           ),
              //         ],
              //       ),
              //     ))

              /////
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 5,left: 15.0, right:15.0, bottom: 5.0),
                  color: Color(0xFFE5E3E3),
                  child:

                  Container(
                    alignment: Alignment.center,
                    height: 505,
                    width:550,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: const Color(0xffffffff),
                        /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                        border: Border.all(color:const Color(
                            0xFFCADCD8))),

                    child:

                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0,right: 10, top: 25.0),
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
                        Align(
                            alignment: Alignment.topRight,

                            child:Container(
                                margin: EdgeInsets.only(right: 20, top: 10),
                                child: Image.asset("assets/images/breath.png",color: const Color(0xFF264E8F), height: 50.0,width: 50.0,))
                          // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Container(
                                height: h*0.55 ,
                                width: w*0.7 ,

                                child: Center(
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: AnimatedContainer(
                                            duration:
                                            Duration(seconds: duration[iteration]),
                                            width: sizes[iteration],
                                            height: sizes[iteration],
                                            child: CustomPaint(
                                              painter: ResponsiveCirclePainter(
                                                  text: textArray[iteration],
                                                  breatheIn:
                                                  double.parse(duration[1].toString()),
                                                  breatheOut:
                                                  double.parse(duration[3].toString()),
                                                  hold1:
                                                  double.parse(duration[2].toString()),
                                                  hold2:
                                                  double.parse(duration[4].toString()),
                                                  progress: controller.value,isReset:false),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CustomPaint(painter: OpenPainter(height: h*0.45,width: h*0.45)
                                                  //  child:  Dot(radius: 10.0,color: Colors.yellow,),
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
                                                13 * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                                                //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                13 * 9.5 * math.sin(0.0 + 3 * math.pi / 2),
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
                              const EdgeInsets.only(top: 5.0, bottom: 30.0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        width:MediaQuery.of(context).size.width*0.1,
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF71B9E4),
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(
                                                color: const Color(0xFF1B4F6D),
                                                width: 1.0)),
                                        child: Text(
                                          "Start",

                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "PlayfairDisplay-Regular.ttf",
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      onTap: () {
                                        if (!isAnimation) {
                                          setState(() {
                                            isAnimation = true;
                                            isCircleAnimation = true;

                                            startTimer();
                                            cycle = 0;
                                            iteration = 0;
                                            controller.reset();
                                            controller.repeat();
                                            run(cycle!);
                                          });
                                        }
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        width:MediaQuery.of(context).size.width*0.1,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF71B9E4),
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(
                                                color: const Color(0xFF1B4F6D),
                                                width: 1.0)),
                                        child: Text(
                                          "Replay",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "PlayfairDisplay-Regular.ttf",
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      onTap: () {
                                        if (!isAnimation) {
                                          setState(() {
                                            isAnimation = true;
                                            isCircleAnimation = true;

                                            startTimer();
                                            cycle = 0;
                                            iteration = 0;
                                            controller.reset();
                                            controller.repeat();
                                            run(cycle!);
                                          });
                                        }
                                      },
                                    )
                                  ],
                                ),
                                Container(
                                  width:MediaQuery.of(context).size.width*0.12,
                                  padding: EdgeInsets.only(top:8,bottom: 8, left: 12,right: 12),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFF9000),
                                      border: Border.all(
                                          color: const Color(0xFF71B9E4)),
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Text(
                                    "${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        letterSpacing: 1.0,
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ])

                          ),
                        ),
                      ],
                    ),
                  ))
                  :Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 5,left: 15.0, right:15.0, bottom: 5.0),
                  color: Color(0xFFE5E3E3),
                  child: Container(
                    alignment: Alignment.center,
                    height: 550,
                    width:750,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: const Color(0xffffffff),
                        /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                        border: Border.all(color:const Color(
                            0xFFCADCD8))),

                    child:

                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0,right: 10, top: 25.0),
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
                        Align(
                            alignment: Alignment.topRight,

                            child:Container(
                                margin: EdgeInsets.only(right: 20, top: 10),
                                child: Image.asset("assets/images/breath.png",color: const Color(0xFF264E8F), height: 50.0,width: 50.0,))
                          // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Container(
                                height: h*0.55 ,
                                width: w*0.7 ,

                                child: Center(
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: AnimatedContainer(
                                            duration:
                                            Duration(seconds: duration[iteration]),
                                            width: sizes[iteration],
                                            height: sizes[iteration],
                                            child: CustomPaint(
                                              painter: ResponsiveCirclePainter(
                                                  text: textArray[iteration],
                                                  breatheIn:
                                                  double.parse(duration[1].toString()),
                                                  breatheOut:
                                                  double.parse(duration[3].toString()),
                                                  hold1:
                                                  double.parse(duration[2].toString()),
                                                  hold2:
                                                  double.parse(duration[4].toString()),
                                                  progress: controller.value,isReset:false),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CustomPaint(painter: OpenPainter(height: h*0.45,width: h*0.45)
                                                    //  child:  Dot(radius: 10.0,color: Colors.yellow,),
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
                                                14 * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
                                                //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                14 * 9.5 * math.sin(0.0 + 3 * math.pi / 2),
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
                              const EdgeInsets.only(top: 5.0, bottom: 30.0),
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        width:MediaQuery.of(context).size.width*0.1,
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF71B9E4),
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(
                                                color: const Color(0xFF1B4F6D),
                                                width: 1.0)),
                                        child: Text(
                                          "Start",

                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "PlayfairDisplay-Regular.ttf",
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      onTap: () {
                                        if (!isAnimation) {
                                          setState(() {
                                            isAnimation = true;
                                            isCircleAnimation = true;

                                            startTimer();
                                            cycle = 0;
                                            iteration = 0;
                                            controller.reset();
                                            controller.repeat();
                                            run(cycle!);
                                          });
                                        }
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        width:MediaQuery.of(context).size.width*0.1,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                            color: Color(0xFF71B9E4),
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(
                                                color: const Color(0xFF1B4F6D),
                                                width: 1.0)),
                                        child: Text(
                                          "Replay",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: "PlayfairDisplay-Regular.ttf",
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                      onTap: () {
                                        if (!isAnimation) {
                                          setState(() {
                                            isAnimation = true;
                                            isCircleAnimation = true;

                                            startTimer();
                                            cycle = 0;
                                            iteration = 0;
                                            controller.reset();
                                            controller.repeat();
                                            run(cycle!);
                                          });
                                        }
                                      },
                                    )
                                  ],
                                ),
                                Container(
                                  width:MediaQuery.of(context).size.width*0.12,
                                  padding: EdgeInsets.only(top:8,bottom: 8, left: 12,right: 12),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFF9000),
                                      border: Border.all(
                                          color: const Color(0xFF71B9E4)),
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Text(
                                    "${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        letterSpacing: 1.0,
                                        color: const Color(0xFFFFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ])

                          ),
                        ),
                      ],
                    ),
                  ));
              // Container(
              //     alignment: Alignment.center,
              //     height: MediaQuery.of(context).size.height,
              //     width: MediaQuery.of(context).size.width,
              //     padding: EdgeInsets.all(10),
              //     color: Color(0xFFE5E3E3),
              //     child:
              //
              //     Container(
              //       alignment: Alignment.center,
              //       height: 561,
              //       width:1025,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(2.0),
              //           color: const Color(0xffffffff),
              //           /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
              //           border: Border.all(color:const Color(
              //               0xFFCADCD8))),
              //
              //       child:
              //
              //       Column(
              //         children: [
              //           const Padding(
              //             padding: EdgeInsets.only(left:10.0,right: 10.0, top:20.0),
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
              //           Align(
              //               alignment: Alignment.topRight,
              //
              //               child:Container(
              //                   margin: EdgeInsets.only(right: 20, top: 10),
              //                   child: Image.asset("assets/images/breath.png",color: const Color(0xFF264E8F),
              //                     height: 50.0,
              //                     width: 50.0,))
              //             // SvgPicture.asset("assets/images/BreathLogo.svg", height: 50.0,width: 50.0,color: Colors.white70,),
              //           ),
              //
              //           Padding(
              //             padding: const EdgeInsets.all(10.0),
              //             child: Center(
              //                 child: Container(
              //                   height: h*0.55 ,
              //                   width: w*0.6 ,
              //
              //                   child: Center(
              //                       child: Stack(
              //                         children: [
              //                           Center(
              //                             child: AnimatedContainer(
              //                               duration:
              //                               Duration(seconds: duration[iteration]),
              //                               width: sizes[iteration],
              //                               height: sizes[iteration],
              //                               child: CustomPaint(
              //                                 painter: TestCirclePainter(
              //                                     text: textArray[iteration],
              //                                     breatheIn:
              //                                     double.parse(duration[1].toString()),
              //                                     breatheOut:
              //                                     double.parse(duration[3].toString()),
              //                                     hold1:
              //                                     double.parse(duration[2].toString()),
              //                                     hold2:
              //                                     double.parse(duration[4].toString()),
              //                                     progress: controller.value),
              //                                 // child: Padding(
              //                                 //   padding: const EdgeInsets.all(8.0),
              //                                 //   child: CustomPaint(painter: OpenPainter()
              //                                 //       //  child:  Dot(radius: 10.0,color: Colors.yellow,),
              //                                 //       ),
              //                                 // ),
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
              //                                   15 * 9.5 * math.cos(0.0 + 3 * math.pi / 2),
              //                                   //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
              //                                   15 * 9.5 * math.sin(0.0 + 3 * math.pi / 2),
              //                                 )),
              //                           ),
              //                         ],
              //                       )),
              //                 )),
              //           ),
              //           Align(
              //             alignment: Alignment.bottomCenter,
              //             child: Padding(
              //                 padding:
              //                 const EdgeInsets.only(top: 10.0, bottom: 30.0),
              //                 child: Column(children: [
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                     children: [
              //                       GestureDetector(
              //                         child: Container(
              //                           padding: EdgeInsets.all(8.0),
              //                           decoration: BoxDecoration(
              //                               color: Color(0xFF71B9E4),
              //                               borderRadius: BorderRadius.circular(3),
              //                               border: Border.all(
              //                                   color: const Color(0xFF1B4F6D),
              //                                   width: 1.0)),
              //                           child: Text(
              //                             "Start",
              //
              //                             textAlign: TextAlign.center,
              //                             style: const TextStyle(
              //                                 fontFamily: "PlayfairDisplay-Regular.ttf",
              //                                 color: Color(0xFFFFFFFF),
              //                                 fontSize: 14,
              //                                 fontWeight: FontWeight.normal),
              //                           ),
              //                         ),
              //                         onTap: () {
              //                           if (!isAnimation) {
              //                             setState(() {
              //                               isAnimation = true;
              //                               isCircleAnimation = true;
              //
              //                               startTimer();
              //                               cycle = 0;
              //                               iteration = 0;
              //                               controller.reset();
              //                               controller.repeat();
              //                               run(cycle!);
              //                             });
              //                           }
              //                         },
              //                       ),
              //                       GestureDetector(
              //                         child: Container(
              //                           padding: EdgeInsets.all(8.0),
              //                           decoration: BoxDecoration(
              //                               color: Color(0xFF71B9E4),
              //                               borderRadius: BorderRadius.circular(3),
              //                               border: Border.all(
              //                                   color: const Color(0xFF1B4F6D),
              //                                   width: 1.0)),
              //                           child: Text(
              //                             "Replay",
              //                             textAlign: TextAlign.center,
              //                             style: const TextStyle(
              //                                 fontFamily: "PlayfairDisplay-Regular.ttf",
              //                                 color: Color(0xFFFFFFFF),
              //                                 fontSize: 14,
              //                                 fontWeight: FontWeight.normal),
              //                           ),
              //                         ),
              //                         onTap: () {},
              //                       )
              //                     ],
              //                   ),
              //                   Container(
              //                     width: 80.0,
              //                     padding: EdgeInsets.only(top:8,bottom: 8, left: 12,right: 12),
              //                     decoration: BoxDecoration(
              //                         color: const Color(0xFFFF9000),
              //                         border: Border.all(
              //                             color: const Color(0xFF71B9E4)),
              //                         borderRadius: BorderRadius.circular(3)),
              //                     child: Text(
              //                       "${((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0')}",
              //                       textAlign: TextAlign.center,
              //                       style: const TextStyle(
              //                           letterSpacing: 1.0,
              //                           color: const Color(0xFFFFFFFF),
              //                           fontSize: 14,
              //                           fontWeight: FontWeight.normal),
              //                     ),
              //                   )
              //                 ])
              //
              //             ),
              //           ),
              //         ],
              //       ),
              //     )
               //  );
            },
          ))

      );

    ///////////////////////////////
    // AnimatedOpacity(
    //       opacity: isCircleAnimation ? 1 : 0,
    //       duration: const Duration(seconds: 1),
    //       child:
    //       Stack(
    //           children: [
    //
    //             Center(
    //                 child: AnimatedContainer(
    //
    //                   duration: Duration(seconds:duration[iteration]),
    //                   width: sizes[iteration],
    //                   height: sizes[iteration],
    //                   child: CustomPaint(
    //                     painter: TestCirclePainter(
    //                         text: textArray[iteration],
    //                         breatheIn: double.parse(duration[1].toString()),
    //                         breatheOut: double.parse(duration[3].toString()),
    //                         hold1: double.parse(duration[2].toString()),
    //                         hold2: double.parse(duration[4].toString()),
    //                         progress: controller.value),
    //                     child:
    //                     Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child:CustomPaint(painter:OpenPainter()
    //                         //  child:  Dot(radius: 10.0,color: Colors.yellow,),
    //                       ),
    //                     ),
    //                   ),
    //                 )),
    //             ////////////////////////////////////////////////////////////////
    //
    //             RotationTransition(
    //                   turns: animationRotation,
    //  child: Transform.translate(
    //  child: Dot(
    //  radius: 20,
    //  color: Colors.pinkAccent,
    //
    //  ),
    //  offset: Offset(
    //  13* 9.5*math.cos(0.0 + 3 * math.pi / 2),
    //  //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
    //  13 * 9.5*math.sin(0.0 +3 * math.pi / 2),
    //  )),
    //
    //  ),
    //  Positioned(
    //                 top: 300,
    //                 left: 50,
    //                 right: 50,
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Column(
    //  children: [
    //
    //    Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
    //      children: [
    //       GestureDetector(
    //         child: Container(
    //           padding: EdgeInsets.all(5.0),
    //           decoration: BoxDecoration(color:Color(0xFF71B9E4),borderRadius:BorderRadius.circular(3),
    //               border: Border.all(color: const Color(
    //               0xFF1B4F6D),width: 2.0)),
    //           child: Text(
    //             "Start",
    //             textAlign: TextAlign.center,
    //             style: const TextStyle(
    //                 color:Color(0xFFFFFFFF),
    //                 fontSize: 14,
    //                 fontWeight: FontWeight.normal),
    //           ),
    //         ),
    //         onTap: (){},
    //       ) , GestureDetector(
    //          child: Container(
    //            padding: EdgeInsets.all(5.0),
    //            decoration: BoxDecoration(color:Color(0xFF71B9E4),borderRadius:BorderRadius.circular(3),border: Border.all(color: const Color(
    //                0xFF1B4F6D),width: 2.0)),
    //            child: Text(
    //              "Replay",
    //              textAlign: TextAlign.center,
    //              style: const TextStyle(
    //                  color:Color(0xFFFFFFFF),
    //                  fontSize: 14,
    //                  fontWeight: FontWeight.normal),
    //            ),
    //          ),
    //          onTap: (){},
    //        )
    //      ],
    //    ),
    //   Container(
    //     padding: EdgeInsets.all(5.0),
    //     decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCADCD8)),borderRadius:BorderRadius.circular(3)),
    //     child: Text("12.6",
    //      textAlign: TextAlign.center,
    //      style: const TextStyle(
    //        letterSpacing: 1.0,
    //          color: const Color(0xFFFF9000),
    //          fontSize: 14,
    //          fontWeight: FontWeight.normal),
    //    ),)
    //
    //  ],
    //  )
    //
    //
    //                 )),
    //
    //           ])
    //     ),
    //   );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.stop();
    controller.dispose();
  }
}
