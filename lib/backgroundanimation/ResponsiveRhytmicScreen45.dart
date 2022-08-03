import 'dart:async';

import 'package:confetti/confetti.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rhythmicbreathingtechnique/Constants.dart';
import 'package:rhythmicbreathingtechnique/ResponsiveWidget.dart';
import 'package:rhythmicbreathingtechnique/model/RhythmicModel.dart';
import 'package:rhythmicbreathingtechnique/provider/RhythmicBreathingProvider.dart';
import 'dart:math' as math;
import '../OpenPainter.dart';
import '../RhythmicBreathingTechniqueTesting.dart';
import '../ResponsiveCirclePainter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import '../app_show_date_picker.dart';

class ResponsiveRhythmicScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResponsiveRhythmicState();
  }
}
class _ScrollItem{
  String text;// Icon icon;
  _ScrollItem(this.text);
}
class ResponsiveRhythmicState extends State<ResponsiveRhythmicScreen>
    with TickerProviderStateMixin {
  late RhythmicBreathingProvider _provider;
  bool start = false;
  String? selectedTime;
  String initalDateValue = "";
  String finalDateValue = "";
  //TimeOfDay.now();
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
  int tempminutes = 0;
  int tempseconds = 0;
  int max = 60;
  int min = 0;

  TextEditingController minuteEditController = TextEditingController();
  TextEditingController secondEditingController = TextEditingController();





  // scrollItem("assessment",Icon(Icons.assessment))
  // scrollItem("assessment",Icon(Icons.assessment))
  // scrollItem("assessment",Icon(Icons.assessment))
  // scrollItem("assessment",Icon(Icons.assessment))
  // scrollItem("assessment",Icon(Icons.assessment));
  //blue dark Color(0xFF264E8F),
  // final List<double> sizes = [10,15,15,10,10];//
  final List<double> sizes = [150, 250, 250, 150, 150];
  final List<double> centerCircleSizes = [40, 90, 90, 40, 40];

  final List<int> duration = [0, 2, 1, 2, 1];

  //final List<int> duration = [0, 4, 4, 4, 4];
  int iteration = 0;
  var w;
  var h;
  int? cycle;
  String minText = "";
  String secondText = ""; // empty string to carry what was there before it

  int maxLength = 2;

  final List<String> textArray = [
    "",
    "Breathe in",
    "Hold",
    "Breathe out",
    "Hold",
  ];
  double progress = 0;
  String? displayStr = "[2,1,2,1]";
  int timerMaxSeconds = 0;
  int currentSeconds = 0;
  Timer? time;
  bool isConfetti = false;
  List<String> selectedItems = [];
  Map<String, bool> values = {
    'calm  :': false,
    'energetic :': false,
    'relaxed :': false,
    'focused :': false,
  };
  var displayTimer = "0";
  int tempvalue = 0;
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
    tempvalue = sum * 8;

    timerMaxSeconds = sum * 8;
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
    while (cycle <= 7) {
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
      sizes.add(w * 0.22);
      sizes.add(w * 0.35);
      sizes.add(w * 0.35);
      sizes.add(w * 0.22);
      sizes.add(w * 0.22);
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
      sizes.add(h * 0.20);
    }
  }

  @override
  Widget build(BuildContext context) {
    configWidth();

    return Scaffold(
        backgroundColor: Color(0xFFE5E3E3),
        body:

        ChangeNotifierProvider<RhythmicBreathingProvider>(
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
                                      fontSize: 17),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10,
                                    top: 5.0,
                                    bottom: 10),
                                child: Text(
                                  displayStr!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontFamily: "PlayfairDisplay-Regular.ttf",
                                      color: Color(0xFF264E8F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              //breathing animation

                              isCircleAnimation
                                  ? AnimatedOpacity(
                                      opacity: isCircleAnimation ? 1 : 0,
                                      duration: const Duration(seconds: 1),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                                child: Container(
                                              height: h * 0.5,
                                              width: w * 0.65,
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

                                                        child:
                                                            AnimatedContainer(
                                                          duration: Duration(
                                                              seconds: duration[
                                                                  iteration]),
                                                          width:
                                                              sizes[iteration],
                                                          height:
                                                              sizes[iteration],
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
                                                    top: 5.0, bottom: 10.0),
                                                child: Column(children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      GestureDetector(
                                                        child: Container(
                                                          width: w * 0.2,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  6.0),
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
                                                            "Start",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "PlayfairDisplay-Regular.ttf",
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          if (!isAnimation &&
                                                              !start) {
                                                            setState(() {
                                                              isAnimation =
                                                                  true;
                                                              isCircleAnimation =
                                                                  true;
                                                              isConfetti =
                                                                  false;
                                                              isRestart = false;
                                                              isshowQuestion =
                                                                  false;
                                                              startTimer();
                                                              cycle = 0;
                                                              iteration = 0;
                                                              controller
                                                                  .reset();
                                                              controller
                                                                  .repeat();
                                                              run(cycle!);
                                                              start = true;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      GestureDetector(
                                                        child: Container(
                                                          width: w * 0.2,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6.0),
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
                                                            "Replay",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "PlayfairDisplay-Regular.ttf",
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          if (!isAnimation &&
                                                              start) {
                                                            setState(() {
                                                              isAnimation =
                                                                  true;
                                                              isCircleAnimation =
                                                                  true;
                                                              isConfetti =
                                                                  false;
                                                              isRestart = false;
                                                              isshowQuestion =
                                                                  false;
                                                              startTimer();
                                                              cycle = 0;
                                                              iteration = 0;
                                                              controller
                                                                  .reset();
                                                              controller
                                                                  .repeat();
                                                              run(cycle!);
                                                              start = false;
                                                            });
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: w * 0.08,
                                                      ),
                                                      Container(
                                                        width: w * 0.25,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 7,
                                                                bottom: 7,
                                                                left: 10,
                                                                right: 10),
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xFFFF9000),
                                                            border: Border.all(
                                                                color: const Color(
                                                                    0xFF1B4F6D),
                                                                width: 2.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3)),
                                                        child: Text(
                                                          getTimerValue(),
                                                          //((timerMaxSeconds - currentSeconds)).toString().padLeft(2,"0") + ":00",
                                                          // (timerMaxSeconds - currentSeconds)<=9?
                                                          // "0"+((timerMaxSeconds - currentSeconds)).toString() + ":00":
                                                          // ((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0') + ":00",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              letterSpacing:
                                                                  1.0,
                                                              color: Color(
                                                                  0xFFFFFFFF),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {


                                                                  return  Container(
                                                                      height: MediaQuery.of(
                                                                          context)
                                                                          .size
                                                                          .height *
                                                                          0.55,
                                                                      child:
                                                                      AppShowDatePicker(
                                                                        title:
                                                                        'select_date_time',

                                                                        message:
                                                                        "Recommended opening after 08/31/2021",
                                                                        initialDate:
                                                                        DateTime.now(),
                                                                        startDate: DateTime(
                                                                            2020, 01, 01),
                                                                        endDate: DateTime(
                                                                            2025, 01, 01),
                                                                        isDotted: false,
                                                                        onSelected: (value) {
                                                                          print(
                                                                              "@#selected date $value");
                                                                          initalDateValue =  DateFormat('EEE, dd MMM yyyy').parse(value).toString();
                                                                          setState(() {
                                                                            var  initialValue =value;
                                                                            print("@@@@"+initialValue);
                                                                          });
                                                                        },
                                                                      ));
                                                                  //   Dialog(
                                                                  //     //this right here
                                                                  //     child: inputDuration(
                                                                  //         context)
                                                                  // );
                                                                });
                                                            //_show();
                                                            // showTimePicker(
                                                            //   context: context,
                                                            //   initialTime: TimeOfDay.now(),
                                                            //   initialEntryMode: TimePickerEntryMode.input,
                                                            //   confirmText: "Confirm",
                                                            //   cancelText: "Cancel",
                                                            //   helpText: "Breathing Practice",
                                                            //
                                                            //   onEntryModeChanged: (values){
                                                            //     setState(() {
                                                            //       print("changes");
                                                            //       print(values);
                                                            //     });
                                                            //
                                                            //   }
                                                            // );
                                                          },
                                                          icon:
                                                              Icon(Icons.timer))
                                                    ],
                                                  )
                                                ])),
                                          ),
                                        ],
                                      ))
                                  : isConfetti
                                      ? confettiWidget(h * 0.55, w * 0.7)
                                      : isshowQuestion
                                          ? Expanded(
                                              child:
                                                  questionAnswer(h * 0.65, w))
                                          : startAgain()
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
                            //color: Color(0xFF0E244A),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/unnamed_rock.jpg",
                            //  "assets/images/Background.jpg"
                          )),
                    ),
                            //Color(0xFFE5E3E3),
                            child: Stack(
                              children: [

                                Opacity(opacity: 0.5,
                                child:
                                Container(
                                    alignment: Alignment.center,
                                    height: 505,
                                    width: 550,
                                    //color: Colors.transparent,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                      //color: Colors.transparent,

                                      /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                      border:
                                      Border.all(color: const Color(0xFFCADCD8)),
                                      image: const DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage("assets/images/unnamed_rock.jpg",
                                            //  "assets/images/Background.jpg"
                                          )
                                      ),
                                    ),
                            )),

                                    Container(
                                      alignment: Alignment.center,
                                      height: 505,
                                      width: 550,
                                      //color: Colors.transparent,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2.0),
                                        color: Colors.transparent,

                                        /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                        border:
                                        Border.all(color: const Color(0xFFCADCD8)),
                                        // image: const DecorationImage(
                                        //     fit: BoxFit.fill,
                                        //     image: AssetImage("assets/images/unnamed_rock.jpg",
                                        //       //  "assets/images/Background.jpg"
                                        //     )
                                        //),
                                      ),
                                        child:   Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                    margin: const EdgeInsets.only(
                                                        right: 20, top: 5),
                                                    child: Image.asset(

                                                      "assets/images/BreathTechnologies_Logo_White.png",
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
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10,
                                                  top: 5.0,
                                                  bottom: 10),
                                              child: Text(
                                                displayStr!,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily:
                                                    "PlayfairDisplay-Regular.ttf",
                                                    color: Color(0xFF264E8F),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            isCircleAnimation
                                                ? AnimatedOpacity(
                                                opacity: isCircleAnimation ? 1 : 0,
                                                duration: const Duration(seconds: 1),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.all(8.0),
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
                                                                        const EdgeInsets
                                                                            .all(8.0),
                                                                        child: CustomPaint(
                                                                          painter:
                                                                          OpenPainter(
                                                                              height: h *
                                                                                  0.45,
                                                                              width: h *
                                                                                  0.45),
                                                                          child:
                                                                          AnimatedContainer(
                                                                            duration: Duration(
                                                                                seconds: duration[
                                                                                iteration]),
                                                                            width: sizes[
                                                                            iteration],
                                                                            height: sizes[
                                                                            iteration],
                                                                            child:
                                                                            CustomPaint(
                                                                              painter: ResponsiveCirclePainter(
                                                                                  text: textArray[
                                                                                  iteration],
                                                                                  breatheIn: double.parse(
                                                                                      duration[1]
                                                                                          .toString()),
                                                                                  breatheOut:
                                                                                  double.parse(duration[3]
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
                                                                      turns:
                                                                      animationRotation,
                                                                      child:
                                                                      Transform.translate(
                                                                          child: Dot(
                                                                            radius: 20,
                                                                            color: Colors
                                                                                .red,
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
                                                      alignment:
                                                      Alignment.bottomCenter,
                                                      child: Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0,
                                                              bottom: 12.0),
                                                          child: Column(children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                //todo
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    // SizedBox(
                                                                    //   width: w * 0.08,
                                                                    // ),
                                                                    Container(

                                                                      width: w * 0.1,

                                                                      padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                      decoration: BoxDecoration(
                                                                          color: const Color(
                                                                              0xFF71B9E4),
                                                                          border: Border.all(
                                                                              color: const Color(
                                                                                  0xFF1B4F6D),
                                                                              width: 1.0),
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                              3)),
                                                                      child: Text(
                                                                        getTimerValue(),
                                                                        // (timerMaxSeconds - currentSeconds)<=9?
                                                                        // "0"+((timerMaxSeconds - currentSeconds)).toString() + ":00":
                                                                        // ((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0') + ":00",
                                                                        textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                        style: const TextStyle(
                                                                            letterSpacing:
                                                                            1.0,
                                                                            color: Color(
                                                                                0xFFFFFFFF),
                                                                            fontSize: 14,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .normal),
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                        onPressed: () {

                                                                          showDialog(
                                                                              context:
                                                                              context,
                                                                              builder:
                                                                                  (BuildContext
                                                                              context) {
                                                                                return  Container(
                                                                                    height: MediaQuery.of(
                                                                                        context)
                                                                                        .size
                                                                                        .height *
                                                                                        0.55,
                                                                                    child:
                                                                                    AppShowDatePicker(
                                                                                      title:
                                                                                      'select_date_time',

                                                                                      message:
                                                                                      "Recommended opening after 08/31/2021",
                                                                                      initialDate:
                                                                                      DateTime.now(),
                                                                                      startDate: DateTime(
                                                                                          2020, 01, 01),
                                                                                      endDate: DateTime(
                                                                                          2025, 01, 01),
                                                                                      isDotted: false,
                                                                                      onSelected: (value) {
                                                                                        print(
                                                                                            "@#selected date $value");
                                                                                        initalDateValue =  DateFormat('EEE, dd MMM yyyy').parse(value).toString();
                                                                                        setState(() {
                                                                                          var  initialValue =value;
                                                                                          print("@@@@"+initialValue);
                                                                                        });
                                                                                      },
                                                                                    ));

                                                                                // Dialog(
                                                                                //   alignment: Alignment.centerRight,
                                                                                // //this right here
                                                                                //   child: inputDuration(
                                                                                //       context)
                                                                                // );
                                                                              });
                                                                          //_show();
                                                                          // showTimePicker(
                                                                          //     context:
                                                                          //         context,
                                                                          //     initialTime:
                                                                          //         TimeOfDay
                                                                          //             .now(),
                                                                          //     initialEntryMode:
                                                                          //         TimePickerEntryMode
                                                                          //             .input,
                                                                          //     confirmText:
                                                                          //         "Confirm",
                                                                          //     cancelText:
                                                                          //         "Cancel",
                                                                          //     helpText:
                                                                          //         "Breathing Practice",
                                                                          //     onEntryModeChanged:
                                                                          //         (values) {
                                                                          //       setState(
                                                                          //           () {
                                                                          //         print(
                                                                          //             "changes");
                                                                          //         print(
                                                                          //             values);
                                                                          //       });
                                                                          //     });

                                                                        },
                                                                        icon: Icon(
                                                                            Icons.timer))
                                                                  ],
                                                                ),
                                                                GestureDetector(
                                                                  child: Container(
                                                                    width: w * 0.1,
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10.0),
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
                                                                            width:
                                                                            1.0)),
                                                                    child: const Text(
                                                                      "Replay",
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                          "PlayfairDisplay-Regular.ttf",
                                                                          color: Color(
                                                                              0xFFFFFFFF),
                                                                          fontSize:
                                                                          14,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    if (!isAnimation &&
                                                                        start) {
                                                                      setState(() {
                                                                        isAnimation =
                                                                        true;
                                                                        isCircleAnimation =
                                                                        true;
                                                                        isConfetti =
                                                                        false;
                                                                        isRestart =
                                                                        false;
                                                                        isshowQuestion =
                                                                        false;
                                                                        startTimer();
                                                                        cycle = 0;
                                                                        iteration = 0;
                                                                        controller
                                                                            .reset();
                                                                        controller
                                                                            .repeat();
                                                                        run(cycle!);
                                                                        start = false;
                                                                      });
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                            //todo
                                                            GestureDetector(
                                                              child: Container(
                                                                width: w * 0.1,
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    10.0),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xFFFF9000),
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        3),
                                                                    border: Border.all(
                                                                        color:const Color(
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
                                                                      fontSize:
                                                                      14,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                if (!isAnimation &&
                                                                    !start) {
                                                                  setState(() {
                                                                    isAnimation =
                                                                    true;
                                                                    isCircleAnimation =
                                                                    true;
                                                                    isConfetti =
                                                                    false;
                                                                    isRestart =
                                                                    false;
                                                                    isshowQuestion =
                                                                    false;
                                                                    startTimer();
                                                                    cycle = 0;
                                                                    iteration = 0;
                                                                    controller
                                                                        .reset();
                                                                    controller
                                                                        .repeat();
                                                                    run(cycle!);
                                                                    start = true;
                                                                  });
                                                                }
                                                              },
                                                            ),

                                                          ])),
                                                    ),
                                                  ],
                                                ))
                                                : isConfetti
                                                ? confettiWidget(100, 100)
                                                : isshowQuestion
                                                ? Expanded(
                                                child: questionAnswer(
                                                  h * 0.55,
                                                  w * 0.5,
                                                ))
                                                : startAgain(),
                                            //confettiWidget( h * 0.55,w * 0.7)
                                          ],
                                        ),
                                      ),

                              ],
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
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 5),
                                          child: Image.asset(
                                            "assets/images/BreathTechnologies_Logo_White.png",
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
                                          fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0,
                                        right: 10,
                                        top: 5.0,
                                        bottom: 10),
                                    child: Text(
                                      displayStr!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontFamily:
                                              "PlayfairDisplay-Regular.ttf",
                                          color: Color(0xFF264E8F),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                  isCircleAnimation
                                      ? AnimatedOpacity(
                                          opacity: isCircleAnimation ? 1 : 0,
                                          duration: const Duration(seconds: 1),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: CustomPaint(
                                                            painter:
                                                                OpenPainter(
                                                                    height: h *
                                                                        0.45,
                                                                    width: h *
                                                                        0.45),
                                                            child:
                                                                AnimatedContainer(
                                                              duration: Duration(
                                                                  seconds: duration[
                                                                      iteration]),
                                                              width: sizes[
                                                                  iteration],
                                                              height: sizes[
                                                                  iteration],
                                                              child:
                                                                  CustomPaint(
                                                                painter: ResponsiveCirclePainter(
                                                                    text: textArray[
                                                                        iteration],
                                                                    breatheIn: double.parse(
                                                                        duration[1]
                                                                            .toString()),
                                                                    breatheOut:
                                                                        double.parse(duration[3]
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
                                                        turns:
                                                            animationRotation,
                                                        child:
                                                            Transform.translate(
                                                                child: Dot(
                                                                  radius: 20,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                offset: Offset(
                                                                  14 *
                                                                      9.5 *
                                                                      math.cos(0.0 +
                                                                          3 *
                                                                              math.pi /
                                                                              2),
                                                                  //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                                  14 *
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
                                                alignment:
                                                    Alignment.bottomCenter,
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
                                                                  0.08,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
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
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              if (!isAnimation &&
                                                                  !start) {
                                                                setState(() {
                                                                  isAnimation =
                                                                      true;
                                                                  isCircleAnimation =
                                                                      true;
                                                                  isConfetti =
                                                                      false;
                                                                  isRestart =
                                                                      false;
                                                                  isshowQuestion =
                                                                      false;
                                                                  startTimer();
                                                                  cycle = 0;
                                                                  iteration = 0;
                                                                  controller
                                                                      .reset();
                                                                  controller
                                                                      .repeat();
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
                                                                  0.07,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
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
                                                                      width:
                                                                          1.0)),
                                                              child: const Text(
                                                                "Replay",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "PlayfairDisplay-Regular.ttf",
                                                                    color: Color(
                                                                        0xFFFFFFFF),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              if (!isAnimation &&
                                                                  start) {
                                                                setState(() {
                                                                  isAnimation =
                                                                      true;
                                                                  isCircleAnimation =
                                                                      true;
                                                                  isConfetti =
                                                                      false;
                                                                  isRestart =
                                                                      false;
                                                                  isshowQuestion =
                                                                      false;
                                                                  startTimer();
                                                                  cycle = 0;
                                                                  iteration = 0;
                                                                  controller
                                                                      .reset();
                                                                  controller
                                                                      .repeat();
                                                                  run(cycle!);
                                                                  start = false;
                                                                });
                                                              }
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: w * 0.04,
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.07,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10,
                                                                    bottom: 10,
                                                                    left: 12,
                                                                    right: 12),
                                                            decoration: BoxDecoration(
                                                                color: const Color(
                                                                    0xFFFF9000),
                                                                border: Border.all(
                                                                    color: const Color(
                                                                        0xFF1B4F6D),
                                                                    width: 1.0),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3)),
                                                            child: Text(
                                                              getTimerValue(),
                                                              // (timerMaxSeconds - currentSeconds)<=9?
                                                              // "0"+((timerMaxSeconds - currentSeconds)).toString() + ":00":
                                                              // ((timerMaxSeconds - currentSeconds)).toString().padLeft(2, '0') + ":00",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  letterSpacing:
                                                                      1.0,
                                                                  color: Color(
                                                                      0xFFFFFFFF),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          IconButton(
                                                              onPressed:
                                                                  () async {
                                                                    showDialog(
                                                                        context:
                                                                        context,
                                                                        builder:
                                                                            (BuildContext
                                                                        context) {
                                                                          return  Container(
                                                                              height: MediaQuery.of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.55,
                                                                              child:
                                                                              AppShowDatePicker(
                                                                                title:
                                                                                'select_date_time',

                                                                                message:
                                                                                "Recommended opening after 08/31/2021",
                                                                                initialDate:
                                                                                DateTime.now(),
                                                                                startDate: DateTime(
                                                                                    2020, 01, 01),
                                                                                endDate: DateTime(
                                                                                    2025, 01, 01),
                                                                                isDotted: false,
                                                                                onSelected: (value) {
                                                                                  print(
                                                                                      "@#selected date $value");
                                                                                  initalDateValue =  DateFormat('EEE, dd MMM yyyy').parse(value).toString();
                                                                                  setState(() {
                                                                                   var  initialValue =value;
print("@@@@"+initialValue);
                                                                                  });
                                                                                },
                                                                              ));

                                                                          //   Dialog(
                                                                          //   alignment: Alignment.centerRight,
                                                                          //   //this right here
                                                                          //     child:
                                                                          //
                                                                          //     inputDuration(context)
                                                                          // );
                                                                        });
                                                                // _show();
                                                                // var select =
                                                                //     await showTimePicker(
                                                                //         context:
                                                                //             context,
                                                                //         initialTime:
                                                                //             TimeOfDay
                                                                //                 .now(),
                                                                //         initialEntryMode:
                                                                //             TimePickerEntryMode
                                                                //                 .input,
                                                                //         confirmText:
                                                                //             "Confirm",
                                                                //         cancelText:
                                                                //             "Cancel",
                                                                //         helpText:
                                                                //             "Breathing Practice",
                                                                //         onEntryModeChanged:
                                                                //             (values) {
                                                                //           setState(
                                                                //               () {
                                                                //             print("changes");
                                                                //             print(values);
                                                                //           });
                                                                //         });
                                                                // if (select !=
                                                                //     null) {
                                                                //   print("@@" +
                                                                //       select
                                                                //           .minute
                                                                //           .toString()); //pickedDate output format => 2021-03-10 00:00:00.000
                                                                //   // setState(() {
                                                                  //   displayStr=select.toString(); //set output date to TextField value.
                                                                  // });
                                                                // } else {
                                                                //   print(
                                                                //       "Time is not selected");
                                                                // }
                                                              },
                                                              icon: Icon(
                                                                  Icons.timer))
                                                        ],
                                                      )
                                                    ])),
                                              ),
                                            ],
                                          ))
                                      : isConfetti
                                          ? confettiWidget(200, 300)
                                          : isshowQuestion
                                              ? Expanded(
                                                  child: questionAnswer(
                                                  h * 0.5,
                                                  w * 0.4,
                                                ))
                                              : startAgain(),
                                ],
                              ),
                            ));
              },
            )));
  }

  Widget questionAnswer(height, width) {
    return AnimatedOpacity(
      opacity: isshowQuestion ? 1.0 : 0,
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
                      primary: const Color(0xffff9000), // background
                    ),
                    onPressed: () {
                      setState(() {
                        isRestart = true;
                        isshowQuestion = false;
                        isConfetti = false;
                        isCircleAnimation = false;

                        // controller.stop();

                        selectedItems = [];
                        values = {
                          'calm  :': false,
                          'energetic :': false,
                          'relaxed :': false,
                          'focused :': false,
                        };
                        _radioSelected;
                        _radioVal = "";
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

  getTimerValue() {
    int temp = timerMaxSeconds - currentSeconds;
    int minute = (temp / 60).toInt();
    tempminutes = minute;

    ///60).toInt();
    int seconds = (temp % 60).toInt();
    tempseconds = seconds;
    displayTimer = minute.toString() + ":" + seconds.toString();
    displayTimer = minute <= 9 && seconds <= 9
        ? "0$minute:0$seconds"
        : minute <= 9 && seconds > 9
            ? "0$minute:$seconds"
            : minute > 9 && seconds <= 9
                ? "$minute:0$seconds"
                : "$minute:$seconds";
    return displayTimer;
  }

  Widget confettiWidget(double height, double width) {
    return AnimatedOpacity(
      opacity: isConfetti ? 1 : 0,
      duration: const Duration(seconds: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 8.0, right: 8.0),
            child: Text(
              "Congratulations!! You have successfully completed rhythmic breathing techniques",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF264E8F),
                  fontWeight: FontWeight.bold,
                  fontFamily: "PlayfairDisplay-Regular.ttf",
                  fontSize: 14.0),
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

  Widget StartAgainold() {
    return AnimatedOpacity(
      opacity: isRestart ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      // onEnd: (){
      //   setState(() {
      //     controller.isAnimating?controller.stop():controller.clearListeners();
      //     isCircleAnimation=true;
      //     isConfetti=false;
      //     isshowQuestion=false;
      //   });
      //
      // },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 50.0),
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
                            color: Colors.blue),
                      )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isCircleAnimation = true;
                isRestart = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Press Here to practice Again",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 16)),
                ],
              ),
            ),
          )
        ],
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
              const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 80),
                  child: Text(
                    "Thank you for practicing with Breath Technologies! \n  I'm done! yay",
                    //" Thank You for Practicing with Breath Connect Technologies",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue),
                  )),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        width: 150.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffff9000), // background
                            ),
                            onPressed: () {
                              setState(() {
                                isCircleAnimation = true;
                                isRestart = false;
                              });
                            },
                            child: const Text(
                              "Practice Again",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 6.0, right: 6.0, top: 10, bottom: 10),
                      child: SizedBox(
                        width: 150.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffff9000), // background
                            ),
                            onPressed: () {
                              _launchURLBrowser();
                            },
                            child: const Text(
                              "Learn More",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ])
            ]));
  }

  _launchURLBrowser() async {
    const url = 'https://breathtechnologies.com/app/breathingtechniques/4.2.4.rhythmic';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _show() async {
    final TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
              // MediaQuery.of(context).copyWith(
              //       // Using 12-Hour format
              //         alwaysUse24HourFormat: false),
              // If you want 24-Hour format, just change alwaysUse24HourFormat to true
              child: child!);
        });
    if (result != null) {
      setState(() {
        selectedTime = result.format(context);
      });
    }
  }

  Widget inputDuration(BuildContext context) {
    return

      Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      width:  ResponsiveWidget.isSmallScreen(context)? w * 0.6 : ResponsiveWidget.isMediumScreen(context)?w*0.4:w*0.3,
      height: h! * 0.4,
      padding: const EdgeInsets.all(12.0),
      child:


      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Breathing Practice",
            style: TextStyle(
              color: Color(0xFF264E8F),
              fontSize: 18.0,
              fontFamily: "PlayfairDisplay-Regular.ttf",
            ),
          ),
          SizedBox(
            height: 10,
          ),

         // TODO
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 5),
                      child: Text("Minutes",
                          style: TextStyle(
                              color: Color(0xFF264E8F), fontSize: 10.0))),
                  Container(
                    width: 60.0,
                    height: 45,
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        border: Border.all(color: Color(0xFF264E8F))),
                    child: TextFormField(
                      controller: minuteEditController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                      maxLines: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                      ),
                      onChanged: (String newVal) {
                        {
                          print('Changed');
                          if (newVal.length <= maxLength) {
                            int x;
                            try {
                              x = int.parse(newVal);
                            } catch (error) {
                              x = min;
                            }
                            if (x < min) {
                              x = min;
                            } else if (x > max) {
                              x = max;
                            }

                            minuteEditController.value = TextEditingValue(
                              text: x == 0 ? "" : x.toString(),
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                    offset: minuteEditController
                                        .value.selection.baseOffset),
                              ),
                            );
                          }
                        }
                        ;
                        // if(newVal.length <= maxLength ){
                        //   minText = newVal;
                        // }else{
                        //   minuteEditController.value = new TextEditingValue(
                        //       text: minText,
                        //       selection: new TextSelection(
                        //           baseOffset: maxLength,
                        //           extentOffset: maxLength,
                        //           affinity: TextAffinity.downstream,
                        //           isDirectional: false
                        //       ),
                        //       composing: new TextRange(
                        //           start: 0, end: maxLength
                        //       )
                        //   );
                        //   minuteEditController.text = minText;
                        // }
                      },
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Text(
                  ":",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("Seconds",
                          style: TextStyle(
                              color: Color(0xFF264E8F), fontSize: 10.0))),
                  Container(
                    width: 60.0,
                    height: 45,
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        border: Border.all(color: Color(0xFF264E8F))),
                    child: TextFormField(
                      controller: secondEditingController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF264E8F)),
                      maxLines: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (String newVal) {
                        {
                          print('Changed');
                          if (newVal.length <= maxLength) {
                            int x;
                            try {
                              x = int.parse(newVal);
                            } catch (error) {
                              x = min;
                            }
                            if (x < min) {
                              x = min;
                            } else if (x > max) {
                              x = max;
                            }

                            secondEditingController.value = TextEditingValue(
                              text: x == 0 ? "" : x.toString(),
                              selection: TextSelection.fromPosition(
                                TextPosition(
                                    offset: secondEditingController
                                        .value.selection.baseOffset),
                              ),
                            );
                          }
                        }
                        ;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 80.0,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xFFFF9000),
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    border: Border.all(color: Color(0xFF264E8F))),
                margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  //color: Colors.transparent,
                ),
              ),
              Container(
                width: 80.0,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xFFFF9000),
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    border: Border.all(color: Color(0xFF264E8F))),
                margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.stop();
    controller.dispose();
  }
}
