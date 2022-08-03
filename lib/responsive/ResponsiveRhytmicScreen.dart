import 'dart:async';
import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rhythmicbreathingtechnique/AppColors.dart';
import 'package:rhythmicbreathingtechnique/AppStrings.dart';
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
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../app_show_date_picker.dart';

class ResponsiveRhythmicScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResponsiveRhythmicState();
  }
}

class ItemValue {
  final String valueInSeconds;
  final String text;

  final String cycle;

  ItemValue(
    this.valueInSeconds,
    this.text,
    this.cycle,
  );
}

//30 minutes=1800 seconds //12 seconds = 1 cycle //150*12= 1800

class ResponsiveRhythmicState extends State<ResponsiveRhythmicScreen>
    with TickerProviderStateMixin {
  late RhythmicBreathingProvider _provider;
  bool clickCount = false;
  bool start = false;
  String? selectedTime;
  String initalDateValue = "";
  String finalDateValue = "";
  bool isValueSelected = false;
 // String AppStrings.toolTipStart = "Start";
  //String AppStrings.toolTipReset = "Reset";
  bool isClicked = false;
  //String AppStrings.toolTipReplay = "Start again after practice";

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
  bool isPracticeAgain = false;
  int tempminutes = 0;
  int tempseconds = 0;
  int max = 60;
  int min = 0;
  var selectedValue;
  bool isReplay = false;

  TextEditingController minuteEditController = TextEditingController();
  TextEditingController secondEditingController = TextEditingController();

  // scrollItem("assessment",Icon(Icons.assessment))
  // scrollItem("assessment",Icon(Icons.assessment))
  // scrollItem("assessment",Icon(Icons.assessment))
  // scrollItem("assessment",Icon(Icons.assessment))
  // scrollItem("assessment",Icon(Icons.assessment));
  //blue dark Color(0xFF264E8F),

  var darkBlue = const Color(0xFF264E8F);

  String? selectval = "12";

  int sumDuration = 4 + 4 + 4 + 4;

  //String? selectval = "00:12";
  var items;

  // final List<double> sizes = [10,15,15,10,10];//
  final List<double> sizes = [150, 250, 250, 150, 150];
  final List<double> centerCircleSizes = [40, 90, 90, 40, 40];

  final List<int> duration = [
    0,
    4,
    4,
    4,
    4
  ]; //final List<int> duration = [0, 4, 2, 4, 2];

  //TODO 1cycle= 12 seconds

  //final List<int> duration = [0, 4, 4, 4, 4];
  int iteration = 0;

  var w;
  var h;
  int? cycle;
  String minText = "";
  String secondText = ""; // empty string to carry what was there before it
  List<ItemValue> itemList = [];
  int maxLength = 2;

  final List<String> textArray = [
    "",
    "Breathe in",
    "Hold",
    "Breathe out",
    "Hold",
  ];
  double progress = 0;
  String? displayStr = " 4-4-4-4 ";
  int timerMaxSeconds = 0;
  int tempTimerMaxSeconds = 0;
  int currentSeconds = 0;
  Timer? time;
  int cycleValue = 5;
  bool isConfetti = false;
  List<String> selectedItems = [];
  Map<String, bool> values = {
    'calm  :': false,
    'energetic :': false,
    'relaxed :': false,
    'focused :': false,
  };
  var displayTimer = "00:60";
  int tempvalue = 0;
  var _radioSelected;
  String _radioVal = "";
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _provider = RhythmicBreathingProvider();
    for (int i = 0; i < duration.length; i++) {
      sum = sum + duration[i];
    }
    // tempvalue = sum * 8;

    //["12", "24", "36", "48"]

    timerMaxSeconds = sum * 5;
    tempTimerMaxSeconds = timerMaxSeconds;
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
    print("controller" + controller.value.toString());
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));
    addDropdownItem();
  }

  /// Timer update
  startTimer() {
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClicked) {
        timer.cancel();
      } else {
        setState(() {
          currentSeconds = timer.tick;
          print("@@timer" +
              currentSeconds.toString() +
              "  " +
              timerMaxSeconds.toString() +
              " " +
              tempTimerMaxSeconds.toString() +
              " " +
              sum.toString());

          if (timer.tick >= timerMaxSeconds) {
            timer.cancel();

          }
        });
      }
    });
  }

  /// animation withing circle and iteration update
  Future<void> run(int cycle) async {
  //  print("@@cycleValue isClicked $cycleValue  $isClicked");

    while (cycle < cycleValue) {
      for (int i = 0; i < duration.length; i++) {
        if (isClicked) {
          print("returned for");
          break;
        }
        if (iteration + 1 < 5) {
          setState(() {
            iteration += 1;

          });

          await Future.delayed(Duration(seconds: duration[iteration]), () {
            print("iteration $iteration");
          });
        }
      }

      setState(() {
        cycle += 1;
        iteration = 0;
      });
      if (cycle == cycleValue) {
        setState(() {
          controller.stop();
          isConfetti = true;
          isAnimation = false;
          isCircleAnimation = false;
          questionFunction();
        });
      }
      if (isClicked) {
        print("returned");
        break;

      }
    }
  }

  void addDropdownItem() {
    for (int i = 2; i < 150; i++) {
      var j = i * sum;
      //  print(" items" + j.toString());

      var k = j / sum;
      int m = (j / 60).toInt();
      //  tempminutes = m;

      ///60).toInt();
      int s = (j % 60).toInt();
      // tempseconds = seconds;

      var value = m.toString() + ":" + s.toString();
      value = m <= 9 && s <= 9
          ? "0$m:0$s"
          : m <= 9 && s > 9
              ? "0$m:$s"
              : m > 9 && s <= 9
                  ? "$m:0$s"
                  : "$m:$s";
      // selectval=s.toString();
      //  print(" value $value");
      setState(() {
        itemList.add(ItemValue(
            j.toInt().toString(), value.toString(), k.toInt().toString()));

        //  items.addAll( itemList);
      });
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
        backgroundColor: const  Color(0xFFE5E3E3),
        body:

            ChangeNotifierProvider<RhythmicBreathingProvider>(
                create: (context) => _provider,
                child: Consumer<RhythmicBreathingProvider>(
                  builder: (context, provider, child) {
                    return ResponsiveWidget.isSmallScreen(context)
                    ///Small Screen
                        ? Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: AppColors.blueColor,
                            ),
                            padding: const EdgeInsets.only(
                                top: 5, left: 15.0, right: 15.0, bottom: 5.0),
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  // margin: EdgeInsets.only(top:50, right: 70, left: 70,bottom: 50),
                                  height: 570,
                                  width: 360,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xFFCADCD8))),
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    alignment: Alignment.center,
                                    //margin: EdgeInsets.only(top:50, right: 70, left: 70,bottom: 50),
                                    height: 570,
                                    width: 360,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        //color:Colors.white,
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/unnamed_rock.jpg"),
                                            fit: BoxFit.cover),
                                        border: Border.all(
                                            color: const Color(0xFFCADCD8))),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  //  margin: EdgeInsets.only(top:50, right: 70, left: 70,bottom: 50),
                                  height: 570,
                                  width: 360,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: const Color(0xFFCADCD8))),
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  right: 20, top: 10),
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
                                          AppStrings.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontFamily:
                                                  "PlayfairDisplay-Regular.ttf",
                                              color: Color(0xFF264E8F),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10,
                                            top: 5.0,
                                            bottom: 10),
                                        child: Text(
                                          displayStr!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontStyle: FontStyle.normal,
                                              fontFamily:
                                                  "PlayfairDisplay-Regular.ttf",
                                              color: Color(0xFF264E8F),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      //breathing animation

                                      isCircleAnimation
                                          ? AnimatedOpacity(
                                              opacity:
                                                  isCircleAnimation ? 1 : 0,
                                              duration: isClicked?const Duration(milliseconds: 1):
                                                  const Duration(seconds: 1),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
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
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  CustomPaint(
                                                                painter: OpenPainter(
                                                                    height:
                                                                        h * 0.4,
                                                                    width: h *
                                                                        0.4),
                                                                //  child:  Dot(radius: 10.0,color: Colors.yellow,),

                                                                child:
                                                                    AnimatedContainer(
                                                                  duration:
                                                                  isClicked?const Duration(milliseconds: 0):
                                                                      Duration(
                                                                          seconds:
                                                                              duration[iteration]),
                                                                  width: sizes[
                                                                      iteration],
                                                                  height: sizes[
                                                                      iteration],
                                                                  child:
                                                                      CustomPaint(
                                                                    painter: ResponsiveCirclePainter(
                                                                        text: textArray[
                                                                                iteration],
                                                                        breatheIn:
                                                                            double.parse(duration[1]
                                                                                .toString()),
                                                                        breatheOut:
                                                                            double.parse(duration[3]
                                                                                .toString()),
                                                                        hold1: double.parse(duration[2]
                                                                            .toString()),
                                                                        hold2: double.parse(duration[4]
                                                                            .toString()),
                                                                        progress:  controller.value,
                                                                        isReset: isClicked),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          RotationTransition(
                                                            turns:
                                                                animationRotation,
                                                            child: Transform
                                                                .translate(
                                                                    child: Dot(
                                                                      radius:
                                                                          20,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    offset:
                                                                        Offset(
                                                                      12 *
                                                                          9.5 *
                                                                          math.cos(0.0 +
                                                                              3 * math.pi / 2),
                                                                      //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                                      12 *
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
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20.0,
                                                                bottom: 10.0),
                                                        child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  openPopMenu(),
                                                                  GestureDetector(
                                                                    child: Tooltip(
                                                                        message: isPracticeAgain ? AppStrings.toolTipReplay : "",
                                                                        child: Container(
                                                                          width:
                                                                              w * 0.2,
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          decoration: BoxDecoration(
                                                                              color: AppColors.buttonBlueColor,
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              border: Border.all(color: AppColors.buttonBorderColor, width: 1.0)),
                                                                          child:
                                                                              Text(
                                                                            AppStrings.replay,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                                fontFamily: "PlayfairDisplay-Regular.ttf",
                                                                                color: Color(0xFFFFFFFF),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        )),
                                                                    onTap: () {
                                                                      onReplayButtonClick();
                                                                    },
                                                                  )
                                                                ],
                                                              ),
                                                              GestureDetector(
                                                                    child: Tooltip(
                                                                        message: AppStrings.toolTipStart,
                                                                        child: Container(
                                                                          width:
                                                                              w * 0.2,
                                                                          margin:
                                                                              EdgeInsets.only(top: 15.0),
                                                                          padding:
                                                                              EdgeInsets.all(5.0),
                                                                          decoration: BoxDecoration(
                                                                              color: isPracticeAgain || isAnimation? AppColors.greyColor:
                                                                              AppColors.orangeColor,
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              border: Border.all(color: AppColors.buttonBorderColor, width: 1.0)),
                                                                          child:
                                                                              const Text(
                                                                            AppStrings.start,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                                fontFamily: "PlayfairDisplay-Regular.ttf",
                                                                                color: Color(0xFFFFFFFF),
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        )),
                                                                    onTap: () {
                                                                      onStartButtonClick();
                                                                    },
                                                                  ),
                                                        Opacity(
                                                            opacity:
                                                            isAnimation
                                                                ? 1.0
                                                                : 0.0,
                                                            child:GestureDetector(
                                                                child: Tooltip(
                                                                    message:
                                                                        isAnimation?AppStrings.toolTipReset:"",
                                                                    child:
                                                                        Container(
                                                                      width: w *
                                                                          0.2,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                              top: 15.0),
                                                                      padding: const
                                                                          EdgeInsets.all(
                                                                              5.0),
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors.orangeColor,
                                                                          borderRadius: BorderRadius.circular(
                                                                              3),
                                                                          border: Border.all(
                                                                              color: AppColors.blueColor,
                                                                              width: 1.0)),
                                                                      child:
                                                                          const Text(
                                                                        AppStrings.reset,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "PlayfairDisplay-Regular.ttf",
                                                                            color: Color(
                                                                                0xFFFFFFFF),
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    )),
                                                                onTap: () {
                                                                  onResetButtonClick();
                                                                },
                                                              ))
                                                            ])),
                                                  ),
                                                ],
                                              ))
                                          : isConfetti
                                              ? confettiWidget(
                                                  h * 0.55, w * 0.7)
                                              : isshowQuestion
                                                  ? Expanded(
                                                      child: questionAnswer(
                                                          550, w * 0.8))
                                                  : startAgain()
                                    ],
                                  ),
                                ),
                              ],
                            ))
                        : ResponsiveWidget.isMediumScreen(context) ?
                    ///Medium Screen
                            Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    top: 5,
                                    left: 15.0,
                                    right: 15.0,
                                    bottom: 5.0),
                                color: AppColors.blueColor,
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 605,
                                      width: 550,
                                      //color: Colors.transparent,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        color: Colors.white,

                                        /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                        border: Border.all(
                                            color: const Color(0xFFCADCD8)),
                                        // image: const DecorationImage(
                                        //     fit: BoxFit.cover,
                                        //     image: AssetImage("assets/images/unnamed_rock.jpg",
                                        //       //  "assets/images/Background.jpg"
                                        //     )
                                        // ),
                                      ),
                                    ),
                                    Opacity(
                                        opacity: 0.5,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 605,
                                          width: 550,
                                          //color: Colors.transparent,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2.0),
                                            border: Border.all(
                                                color: const Color(0xFFCADCD8)),
                                            image: const DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  "assets/images/unnamed_rock.jpg",
                                                  //  "assets/images/Background.jpg"
                                                )),
                                          ),
                                        )),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 605,
                                      width: 550,
                                      //color: Colors.transparent,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: const Color(0xFFCADCD8)),

                                      ),
                                      child: Column(
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
                                              AppStrings.title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily:
                                                      "PlayfairDisplay-Regular.ttf",
                                                  color: AppColors.lightBlueColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10,
                                                top: 5.0,
                                                bottom: 10),
                                            child: Text(
                                              displayStr!,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily:
                                                      "PlayfairDisplay-Regular.ttf",
                                                  color: AppColors.lightBlueColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ),

                                          isCircleAnimation
                                              ? AnimatedOpacity(
                                                  opacity:
                                                      isCircleAnimation ? 1 : 0,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
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
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      CustomPaint(
                                                                    painter: OpenPainter(
                                                                        height: h *
                                                                            0.45,
                                                                        width: h *
                                                                            0.45),
                                                                    child:
                                                                        AnimatedContainer(
                                                                      duration: isClicked?
                                                                      const Duration(milliseconds: 0):
                                                                      Duration(
                                                                          seconds:
                                                                          duration[iteration]),
                                                                      width: sizes[
                                                                          iteration],
                                                                      height: sizes[
                                                                          iteration],
                                                                      child:
                                                                          CustomPaint(
                                                                        painter: ResponsiveCirclePainter(
                                                                            text:
                                                                                textArray[iteration],
                                                                            breatheIn: double.parse(duration[1].toString()),
                                                                            breatheOut: double.parse(duration[3].toString()),
                                                                            hold1: double.parse(duration[2].toString()),
                                                                            hold2: double.parse(duration[4].toString()),
                                                                            progress: controller.value,
                                                                             isReset: isClicked),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              RotationTransition(
                                                                turns:
                                                                    animationRotation,
                                                                child: Transform
                                                                    .translate(
                                                                        child:
                                                                            Dot(
                                                                          radius:
                                                                              20,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        offset:
                                                                            Offset(
                                                                          13 *
                                                                              9.5 *
                                                                              math.cos(0.0 + 3 * math.pi / 2),
                                                                          //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                                          13 *
                                                                              9.5 *
                                                                              math.sin(0.0 + 3 * math.pi / 2),
                                                                        )),
                                                              ),
                                                            ],
                                                          )),
                                                        )),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,
                                                                    bottom:
                                                                        12.0),
                                                            child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      //todo
                                                                      openPopMenu(),

                                                                      GestureDetector(
                                                                        child: Tooltip(
                                                                            message: AppStrings.toolTipReplay,
                                                                            child: Container(
                                                                              width: w * 0.1,
                                                                              padding: const EdgeInsets.all(9.0),
                                                                              decoration: BoxDecoration(color: AppColors.buttonBlueColor, borderRadius: BorderRadius.circular(3), border: Border.all(color: const Color(0xFF1B4F6D), width: 1.5)),
                                                                              child: const Text(
                                                                                AppStrings.replay,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontFamily: "PlayfairDisplay-Regular.ttf", color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            )),
                                                                        onTap:
                                                                            () {
                                                                          onReplayButtonClick();
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                  //todo
                                                                  GestureDetector(
                                                                    child: Tooltip(
                                                                        message: AppStrings.toolTipStart,
                                                                        child: Container(
                                                                          width:
                                                                              w * 0.1,
                                                                          padding:
                                                                              const EdgeInsets.all(7.0),
                                                                          decoration: BoxDecoration(
                                                                              color:  isPracticeAgain || isAnimation? AppColors.greyColor:
                                                                              AppColors.orangeColor,
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              border: Border.all(color:AppColors.buttonBorderColor, width: 1.5)),
                                                                          child:
                                                                              const Text(
                                                                            AppStrings.start,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style: TextStyle(
                                                                                fontFamily: "PlayfairDisplay-Regular.ttf",
                                                                                color: Color(0xFFFFFFFF),
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        )),
                                                                    onTap: () {
                                                                      onStartButtonClick();
                                                                    },
                                                                  ),
                                                                  const SizedBox(height: 20.0,),
                                                          Opacity(opacity: isAnimation?1.0:0.0,

                                                                    child: GestureDetector(
                                                                      child: Tooltip(
                                                                          message: AppStrings.toolTipReset,
                                                                          child: Container(
                                                                            width:
                                                                            w * 0.1,
                                                                            padding:
                                                                            const EdgeInsets.all(7.0),
                                                                            decoration: BoxDecoration(
                                                                                color: AppColors.orangeColor,
                                                                                borderRadius: BorderRadius.circular(3),
                                                                                border: Border.all(color:AppColors.buttonBorderColor, width: 1.5)),
                                                                          child:
                                                                            const Text(
                                                                             AppStrings.reset,
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              style: TextStyle(
                                                                                  fontFamily: "PlayfairDisplay-Regular.ttf",
                                                                                  color: Color(0xFFFFFFFF),
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          )),
                                                                      onTap: () {
                                                                        onResetButtonClick();
                                                                      },
                                                                    ),
                                                                  )
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
                    ///Large Screen
                        : Container(
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    top: 5,
                                    left: 15.0,
                                    right: 15.0,
                                    bottom: 5.0),
                                color: AppColors.blueColor,
                                //Color(0xFFE5E3E3),

                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      height: 650,
                                      width: 750,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.0),
                                          color: const Color(0xffffffff),

                                          /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                          border: Border.all(
                                              color: const Color(0xFFCADCD8))),
                                    ),
                                    Opacity(
                                        opacity: 0.5,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 650,
                                          width: 750,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/unnamed_rock.jpg"),
                                                  fit: BoxFit.cover),

                                              /// color: isCircleAnimation? const Color(0xff00BBA6):Colors.black,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFCADCD8))),
                                        )),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 650,
                                      width: 750,
                                      color: Colors.transparent,
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
                                                left: 10.0,
                                                right: 10,
                                                top: 15.0),
                                            child: Text(
                                              AppStrings.title,
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
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10,
                                                top: 5.0,
                                                bottom: 10),
                                            child: Text(
                                              displayStr!,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
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
                                                  opacity:
                                                      isCircleAnimation ? 1 : 0,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
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
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      CustomPaint(
                                                                    painter: OpenPainter(
                                                                        height: h *
                                                                            0.45,
                                                                        width: h *
                                                                            0.45),
                                                                    child:
                                                                        AnimatedContainer(
                                                                      duration:isClicked?const Duration(milliseconds: 0):
                                                                      Duration(
                                                                          seconds:
                                                                          duration[iteration]),
                                                                      width: sizes[
                                                                          iteration],
                                                                      height: sizes[
                                                                          iteration],
                                                                      child:
                                                                          CustomPaint(
                                                                        painter: ResponsiveCirclePainter(
                                                                            text:
                                                                                textArray[iteration],
                                                                            breatheIn: double.parse(duration[1].toString()),
                                                                            breatheOut: double.parse(duration[3].toString()),
                                                                            hold1: double.parse(duration[2].toString()),
                                                                            hold2: double.parse(duration[4].toString()),
                                                                            progress: controller.value,isReset: isClicked),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              RotationTransition(
                                                                turns:
                                                                    animationRotation,
                                                                child: Transform
                                                                    .translate(
                                                                        child:
                                                                            Dot(
                                                                          radius:
                                                                              20,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        offset:
                                                                            Offset(
                                                                          14 *
                                                                              9.5 *
                                                                              math.cos(0.0 + 3 * math.pi / 2),
                                                                          //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
                                                                          14 *
                                                                              9.5 *
                                                                              math.sin(0.0 + 3 * math.pi / 2),
                                                                        )),
                                                              ),
                                                            ],
                                                          )),
                                                        )),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,
                                                                    bottom:
                                                                        15.0),
                                                            child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      openPopMenu(),
                                                                      GestureDetector(
                                                                        child: Tooltip(
                                                                            message: AppStrings.toolTipReplay,
                                                                            child: Container(
                                                                              width: MediaQuery.of(context).size.width * 0.07,
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              decoration: BoxDecoration(color: Color(0xFF71B9E4),
                                                                                  borderRadius: BorderRadius.circular(3),
                                                                                  border: Border.all(color:AppColors.buttonBorderColor, width: 1.5)),
                                                                              child: const Text(
                                                                                AppStrings.replay,
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontFamily: "PlayfairDisplay-Regular.ttf", color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            )),
                                                                        onTap:
                                                                            () {
                                                                          onReplayButtonClick();
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                  //TODO
                                                                  GestureDetector(
                                                                      child: Tooltip(
                                                                          message: AppStrings.toolTipStart,
                                                                          child: Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.065,
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            decoration: BoxDecoration(
                                                                                color: isPracticeAgain || isAnimation? AppColors.greyColor:
                                                                                AppColors.orangeColor,
                                                                                borderRadius: BorderRadius.circular(3),
                                                                                border: Border.all(color:AppColors.buttonBorderColor, width: 1.5)),
                                                                            child:
                                                                                const Text(
                                                                              AppStrings.start,
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontFamily: "PlayfairDisplay-Regular.ttf", color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          )),
                                                                      onTap: () {
                                                                        onStartButtonClick();
                                                                      }),

                                                                  Opacity(opacity: isAnimation?1.0:0.0,
                                                                    child: GestureDetector(
                                                                      child: Tooltip(
                                                                          message: isAnimation?AppStrings.toolTipReset:"",
                                                                          child: Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 20.0),
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.065,
                                                                            padding:
                                                                                const EdgeInsets.all(10.0),
                                                                            decoration: BoxDecoration(
                                                                                color: AppColors.orangeColor,
                                                                                borderRadius: BorderRadius.circular(3),
                                                                                border: Border.all(color:AppColors.buttonBorderColor, width: 1.5)),
                                                                            child:
                                                                                const Text(
                                                                              AppStrings.reset,
                                                                              textAlign:
                                                                                  TextAlign.center,
                                                                              style: TextStyle(
                                                                                  fontFamily: "PlayfairDisplay-Regular.ttf",
                                                                                  color: Color(0xFFFFFFFF),
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          )),
                                                                      onTap: () {
                                                                        onResetButtonClick();
                                                                      },
                                                                    ),
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
                                    )
                                  ],
                                ));
                  },
                )));
  }




  ///Question Answer Widget
  Widget questionAnswer(height, width) {
    return AnimatedOpacity(
        opacity: isshowQuestion ? 1.0 : 0,
        duration: const Duration(seconds: 3),
        child: Container(
          height: height,
          width: width,
          padding: ResponsiveWidget.isSmallScreen(context)
              ? const EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: 20.0, top: 10)
              : const EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 30.0, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                child: Row(
                  children: const [
                    Text("Are you feeling better?  Are you more",
                        maxLines: 1,
                        style: TextStyle(
                            color: Color(0xFF264E8F),
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: values.keys.map((String key) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          key,
                          style: TextStyle(
                            color: Color(0xFF264E8F),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            // Color(0xFF264E8F)
                          ),
                        ),
                        // Spacer(),
                        Theme(
                          data:
                              ThemeData(unselectedWidgetColor: Color(0xFF264E8F)
                                  // Color(0xFF264E8F)
                                  ),
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
                padding: const EdgeInsets.only(bottom: 4.0, top: 4.0),
                child: Row(
                  children: const [
                    Text("Was this practice effective?",
                        style: TextStyle(
                            color: Color(0xFF264E8F),
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text('Yes :',
                      style: TextStyle(
                          color: Color(0xFF264E8F),
                          fontWeight: FontWeight.bold // Color(0xFF264E8F)

                          )),
                  const Spacer(),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor:
                          Color(0xFF264E8F), //Color(0xFF264E8F)
                    ),
                    child: Radio(
                      value: 1,
                      groupValue: _radioSelected,
                      activeColor: Color(0xFF264E8F),
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
                  const Text('No :',
                      style: TextStyle(
                          color: Color(0xFF264E8F), fontWeight: FontWeight.bold
                          //Color(0xFF264E8F)
                          )),
                  const Spacer(),
                  Theme(
                    data: ThemeData(
                        unselectedWidgetColor:
                            Color(0xFF264E8F) //Color(0xFF264E8F)
                        ),
                    child: Radio(
                      value: 2,
                      groupValue: _radioSelected,
                      activeColor: Color(0xFF264E8F),
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
                  width: 140.0,
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
                          selectedItems = [];
                          values = {
                            'calm  :': false,
                            'energetic :': false,
                            'relaxed :': false,
                            'focused :': false,
                          };
                          // _radioSelected;
                          // _radioVal = "";
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
                          _radioVal="";


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
        )
        //),
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

  ///time display dropdown
  getTimerValue() {
     isPracticeAgain?currentSeconds=0:timerMaxSeconds;
    int temp = timerMaxSeconds - currentSeconds;
    int minute = (temp / 60).toInt();
    tempminutes = minute;
    print("@@getTimerValue" +
        currentSeconds.toString() +
        "  " +
        timerMaxSeconds.toString() +
        " " +
        tempTimerMaxSeconds.toString() +
        " " +
        sum.toString());

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

  ///Confetti show multiple color animation
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
              "Congratulations!! You have successfully completed box breathing techniques",
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
    );
  }

  ///Draw path for confetti widget
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

  ///Practice start again

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
                      "Thank you for practicing with Breath Technologies!",
                      //" Thank You for Practicing with Breath Connect Technologies",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.lightBlueColor))),
              SizedBox(height: 10.0,),
              _provider.totalData!.isEmpty ?  const Text(" People found this technique effective",
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color:  AppColors.lightBlueColor)) :
              Text(
                _provider.effectiveData!.length.toString() +
                    "/" +
                    _provider.totalData!.length.toString() +
                    " people found this technique effective",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color:  AppColors.lightBlueColor),
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        width: 140.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffff9000), // background
                            ),
                            onPressed: () {
                              setState(() {
                                controller.stop();
                                timerMaxSeconds = tempTimerMaxSeconds;
                                isPracticeAgain = true;
                                isCircleAnimation = true;
                                isRestart = false;
                                start=true;
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
                        width: 140.0,
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

  ///Lunch breath Technologies
  _launchURLBrowser() async {
    const url = 'https://breathtechnologies.com/';
    if (await canLaunch(url)) {
      await launch(url);
      isPracticeAgain = false;
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.stop();
    controller.dispose();
  }

  Widget openPopMenu() {
    return PopupMenuButton(
        tooltip: "select for more practice",
        color: darkBlue,
        child: Container(
            width: ResponsiveWidget.isSmallScreen(context)
                ? w * 0.22
                : ResponsiveWidget.isMediumScreen(context)
                    ? w * 0.12
                    : w * 0.1,
            padding: ResponsiveWidget.isSmallScreen(context)
                ? const EdgeInsets.all(1.2)
                : ResponsiveWidget.isMediumScreen(context)
                    ? EdgeInsets.all(5.0)
                    : EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: AppColors.buttonBlueColor,
                border: Border.all(color:AppColors.buttonBorderColor, width: 1.50),
                borderRadius: BorderRadius.circular(3)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    getTimerValue(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        letterSpacing: 1.0,
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: darkBlue,
                  ),
                ])),
        elevation: 10,
        enabled: true,
        onSelected: (value) {
          //   if(!isAnimation) {
          print("update ${value}");
          setState(() {
            items = value;
            selectval = items.text;
            timerMaxSeconds = int.parse(items.valueInSeconds);
            tempTimerMaxSeconds = int.parse(items.valueInSeconds);
            cycleValue = int.parse(items.cycle);
            if (isPracticeAgain) {
              isPracticeAgain = false;
             start = false;
            }

            //
            print("seld $selectval $timerMaxSeconds  $cycleValue");
          });
          // }
        },
        itemBuilder: (context) {
          return itemList.map((ItemValue itemValue) {
            return PopupMenuItem(
                value: itemValue,
                child: Center(
                  child: Text(
                    itemValue.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ));
          }).toList();
        });
  }

  void onReplayButtonClick() {
    // clickCount=clickCount+1;
    print("replay isAnimation ${isAnimation}");
    print("replay start ${start}");
    print("isPracticeAgain ${isPracticeAgain}");
    if (!isAnimation && start) {
      if (isPracticeAgain) {
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
          isPracticeAgain = false;
        });


      }
    }
  }

  void onStartButtonClick() {
    print("start isAnimation ${isAnimation}");
    print("start start ${start}");
    print("start isPracticeAgain ${isPracticeAgain}");
    if (!isAnimation && !start) {
      if (!isPracticeAgain) {
        setState(() {
          isClicked = false;
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
    }
  }

  void onResetButtonClick() {
    if ((isAnimation && start) || !isPracticeAgain) {
      setState(() {
        isClicked = true;
        controller.reset();
        print("# controller ${controller.lastElapsedDuration}  # $cycleValue");
        time!.cancel();
        currentSeconds = 0;
        cycle=0;
        iteration=0;
        start = false;
        isAnimation = false;
      });
    }
  }

  //
  // Widget circleAnimation(BuildContext context){
  //   return AnimatedOpacity(
  //       opacity:
  //       isCircleAnimation ? 1 : 0,
  //       duration: const Duration(
  //           seconds: 1),
  //       child: Column(
  //         children: [
  //           Padding(
  //             padding:
  //             const EdgeInsets
  //                 .all(5.0),
  //             child: Center(
  //                 child: Container(
  //                   height: h * 0.5,
  //                   width: w * 0.7,
  //                   child: Center(
  //                       child: Stack(
  //                         children: [
  //                           Center(
  //                             child: Padding(
  //                               padding:
  //                               const EdgeInsets
  //                                   .all(
  //                                   8.0),
  //                               child:
  //                               CustomPaint(
  //                                 painter: OpenPainter(
  //                                     height: h *
  //                                         0.45,
  //                                     width: h *
  //                                         0.45),
  //                                 child:
  //                                 AnimatedContainer(
  //                                   duration:isClicked?const Duration(milliseconds: 0):
  //                                   Duration(
  //                                       seconds:
  //                                       duration[iteration]),
  //                                   width: sizes[
  //                                   iteration],
  //                                   height: sizes[
  //                                   iteration],
  //                                   child:
  //                                   CustomPaint(
  //                                     painter: ResponsiveCirclePainter(
  //                                         text:
  //                                         textArray[iteration],
  //                                         breatheIn: double.parse(duration[1].toString()),
  //                                         breatheOut: double.parse(duration[3].toString()),
  //                                         hold1: double.parse(duration[2].toString()),
  //                                         hold2: double.parse(duration[4].toString()),
  //                                         progress: controller.value, isReset: isClicked),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           RotationTransition(
  //                             turns:
  //                             animationRotation,
  //                             child: Transform
  //                                 .translate(
  //                                 child:
  //                                 Dot(
  //                                   radius:
  //                                   20,
  //                                   color:
  //                                   Colors.red,
  //                                 ),
  //                                 offset:
  //                                 Offset(
  //                                   14 *
  //                                       9.5 *
  //                                       math.cos(0.0 + 3 * math.pi / 2),
  //                                   //dotRadius  9.5  math.cos(0.0 + 3 * math.pi / 2),
  //                                   14 *
  //                                       9.5 *
  //                                       math.sin(0.0 + 3 * math.pi / 2),
  //                                 )),
  //                           ),
  //                         ],
  //                       )),
  //                 )),
  //           ),
  //           Align(
  //             alignment: Alignment
  //                 .bottomCenter,
  //             child: Padding(
  //                 padding:
  //                 const EdgeInsets
  //                     .only(
  //                     top: 5.0,
  //                     bottom:
  //                     15.0),
  //                 child: Column(
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment:
  //                         MainAxisAlignment
  //                             .spaceAround,
  //                         children: [
  //                           openPopMenu(),
  //                           GestureDetector(
  //                             child: Tooltip(
  //                                 message: AppStrings.toolTipReplay,
  //                                 child: Container(
  //                                   width: MediaQuery.of(context).size.width * 0.07,
  //                                   padding: const EdgeInsets.all(10.0),
  //                                   decoration: BoxDecoration(color: Color(0xFF71B9E4),
  //                                       borderRadius: BorderRadius.circular(3),
  //                                       border: Border.all(color:AppColors.buttonBorderColor, width: 1.5)),
  //                                   child: const Text(
  //                                     AppStrings.replay,
  //                                     textAlign: TextAlign.center,
  //                                     style: TextStyle(fontFamily: "PlayfairDisplay-Regular.ttf", color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.bold),
  //                                   ),
  //                                 )),
  //                             onTap:
  //                                 () {
  //                               onReplayButtonClick();
  //                             },
  //                           )
  //                         ],
  //                       ),
  //                       //TODO
  //                       GestureDetector(
  //                           child: Tooltip(
  //                               message: AppStrings.toolTipStart,
  //                               child: Container(
  //                                 width:
  //                                 MediaQuery.of(context).size.width * 0.065,
  //                                 padding:
  //                                 const EdgeInsets.all(10.0),
  //                                 decoration: BoxDecoration(
  //                                     color: isPracticeAgain || isAnimation? AppColors.greyColor:
  //                                     AppColors.orangeColor,
  //                                     borderRadius: BorderRadius.circular(3),
  //                                     border: Border.all(color:AppColors.buttonBorderColor, width: 1.5)),
  //                                 child:
  //                                 const Text(
  //                                   AppStrings.start,
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(fontFamily: "PlayfairDisplay-Regular.ttf", color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.bold),
  //                                 ),
  //                               )),
  //                           onTap: () {
  //                             onStartButtonClick();
  //                           }),
  //
  //                       Opacity(opacity: isAnimation?1.0:0.0,
  //                         child: GestureDetector(
  //                           child: Tooltip(
  //                               message: isAnimation?AppStrings.toolTipReset:"",
  //                               child: Container(
  //                                 margin:
  //                                 EdgeInsets.only(top: 20.0),
  //                                 width:
  //                                 MediaQuery.of(context).size.width * 0.065,
  //                                 padding:
  //                                 const EdgeInsets.all(10.0),
  //                                 decoration: BoxDecoration(
  //                                     color: AppColors.orangeColor,
  //                                     borderRadius: BorderRadius.circular(3),
  //                                     border: Border.all(color:AppColors.buttonBorderColor, width: 1.5)),
  //                                 child:
  //                                 const Text(
  //                                   AppStrings.reset,
  //                                   textAlign:
  //                                   TextAlign.center,
  //                                   style: TextStyle(
  //                                       fontFamily: "PlayfairDisplay-Regular.ttf",
  //                                       color: Color(0xFFFFFFFF),
  //                                       fontSize: 13,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                               )),
  //                           onTap: () {
  //                             onResetButtonClick();
  //                           },
  //                         ),
  //                       )
  //                     ])),
  //           ),
  //         ],
  //       ));
  // }
}
