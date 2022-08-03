import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';


typedef ValueChanged<T> = void Function(T value);

class AppShowDatePicker extends StatefulWidget {
  String message = "";
  String title = "";
  DateTime initialDate;
  DateTime startDate;
  DateTime endDate;
  //Function onChange;
  bool isDotted = false;

  final ValueChanged<String> onSelected;

  //final df = new DateFormat('dd-MMM-yyyy HH:mm aa');
  final df = new DateFormat('EEE, dd MMM yyyy');
  final dfTime = new DateFormat('hh:mm aa');

  AppShowDatePicker(
      {
      required this.title,

        required this.message,
        required this.initialDate,
        required    this.startDate,
        required this.endDate,
        required this.isDotted,
        required this.onSelected});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowDatePicker();
  }
}

class _ShowDatePicker extends State<AppShowDatePicker> {
  DateTime date = new DateTime.now();
  int selectedIndex = 0;
  int selectedHourIndex = 2;
  int selectedMinuteIndex = 10;
  int _index = 0;

  //DateTime startDate = new DateTime(2020, 3, 2);
  //DateTime endDate = new DateTime(2020, 3, 10);
  List<String> days = [];
  List<String> hours = [];
  List<String> minute = [];

  //var monthsOfTheYear=['10-10-2021','11-10-2021','12-10-2021','13-10-2021','14-10-2021','15-10-2021'];
  late FixedExtentScrollController fixedExtentScrollController;

  //new FixedExtentScrollController(initialItem: 10);
  FixedExtentScrollController fixedExtentScrollController1 =
      new FixedExtentScrollController();
  FixedExtentScrollController fixedExtentScrollController2 =
      new FixedExtentScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var initialDate = widget.df.format(widget.initialDate);
    var initialTime = widget.dfTime.format(widget.initialDate);
    var initialMinutes =
        widget.dfTime.format(widget.initialDate).substring(3, 5);
    print("@@Time $initialTime");

    DateTime tmp = DateTime(widget.startDate.year, widget.startDate.month,
        widget.startDate.day, 30);
    while (DateTime(tmp.year, tmp.month, tmp.day) != widget.endDate) {
      var value = widget.df.format(DateTime(tmp.year, tmp.month, tmp.day));
      days.add(value);
      tmp = tmp.add(new Duration(days: 1));
    }
    for (int j = 0; j < days.length; j++) {
      if (days[j] == initialDate) {
        _index = j;
      }
    }
    for (int i = 0; i <= 12; i++) {
      if (i < 10) {
        hours.add("0" + i.toString());
      } else {
        hours.add(i.toString());
      }
      if (hours[i] == initialTime.split(':')[0]) {
        selectedHourIndex = i;
      }
    }
    for (int i = 0; i <= 60; i++) {
      if (i < 10) {
        minute.add("0" + i.toString());
      } else {
        minute.add(i.toString());
      }
      if (minute[i] == initialMinutes) {
        selectedMinuteIndex = i;
      }
    }
    fixedExtentScrollController =
        new FixedExtentScrollController(initialItem: _index);
    selectedIndex = _index;

    fixedExtentScrollController1 =
        new FixedExtentScrollController(initialItem: selectedHourIndex);
    fixedExtentScrollController2 =
        new FixedExtentScrollController(initialItem: selectedMinuteIndex);

    // fixedExtentScrollController.animateToItem(15,
    //     duration: Duration(milliseconds: 200), curve: Curves.linear);
    //fixedExtentScrollController.initialItem=days[10];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width*0.6,
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.only(top: 15.0, right: 10, left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              widget.title,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 12.0, color:Colors.blueAccent),
            ),

            Container(
                margin:
                    EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 20),
                height: 140.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.5,
                    //   child: ListWheelScrollView(
                    //     controller: fixedExtentScrollController,
                    //     physics: FixedExtentScrollPhysics(),
                    //     children: days.map((d) {
                    //       return Container(
                    //           child: Row(
                    //         children: <Widget>[
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: selectedIndex == days.indexOf(d)
                    //                 ? Column(
                    //                     children: [
                    //                       Container(
                    //                         height: 1,
                    //                         margin: EdgeInsets.all(2.0),
                    //                         color: Colors.grey,
                    //                       ),
                    //                       Text(d.toString(),
                    //                           textAlign: TextAlign.center,
                    //                           style: TextStyle(
                    //                               fontSize: 16.0,
                    //                               color:
                    //                                   Colors.blue)),
                    //                       Container(
                    //                         height: 1,
                    //                         margin: EdgeInsets.all(2.0),
                    //                         color: Colors.grey,
                    //                       ),
                    //                     ],
                    //                   )
                    //                 : Text(d.toString(),
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                         fontSize: 12.0,
                    //                         color: Colors.blueGrey)),
                    //           )),
                    //         ],
                    //       ));
                    //     }).toList(),
                    //     onSelectedItemChanged: (index) {
                    //       setState(() {
                    //         selectedIndex = index;
                    //       });
                    //     },
                    //     itemExtent: 50.0,
                    //     perspective: 0.0000000001,
                    //     diameterRatio: 2,
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: ListWheelScrollView(
                        controller: fixedExtentScrollController1,
                        physics: FixedExtentScrollPhysics(),
                        children: hours.map((h) {
                          return Container(
                              child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: selectedHourIndex == hours.indexOf(h)
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 1,
                                            margin: EdgeInsets.all(2.0),
                                            color: Colors.grey,
                                          ),
                                          Text(h.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color:
                                                      Colors.blue)),
                                          Container(
                                            height: 1,
                                            margin: EdgeInsets.all(2.0),
                                            color: Colors.grey,
                                          ),
                                        ],
                                      )
                                    : Text(h.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.blueGrey)),
                              )),
                            ],
                          ));
                        }).toList(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHourIndex = index;
                          });
                        },
                        itemExtent: 60.0,
                        perspective: 0.0000000001,
                      ),
                    ),
                    Container(
                      child: Text(
                        ':',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: ListWheelScrollView(
                        controller: fixedExtentScrollController2,
                        physics: FixedExtentScrollPhysics(),
                        children: minute.map((h) {
                          return Container(
                              child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: selectedMinuteIndex == minute.indexOf(h)
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 1,
                                            margin: EdgeInsets.all(2.0),
                                            color: Colors.grey,
                                          ),
                                          Text(h.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color:
                                                      Colors.blue)),
                                          Container(
                                            height: 1,
                                            margin: EdgeInsets.all(2.0),
                                            color: Colors.grey,
                                          ),
                                        ],
                                      )
                                    : Text(h.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.blueAccent)),
                              )),
                            ],
                          ));
                        }).toList(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMinuteIndex = index;
                          });
                        },
                        itemExtent: 50.0,
                        perspective: 0.0000000001,
                      ),
                    ),
                  ],
                )),
            Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'cancel',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.blueAccent),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        var selection = getSelectedDate(context);
                        widget.onSelected(selection);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'ok',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.blueAccent),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  String getSelectedDate(BuildContext context) {
    String date = days[selectedIndex];
    String hour = hours[selectedHourIndex];
    String minutes = minute[selectedMinuteIndex];
    print("onSelected" + date + " -" + hour + ":" + minutes);
    var selected = date + " " + hour + ":" + minutes;

    return selected;
  }

/*
  Widget listItems(BuildContext context, int index){
    return Column(

      children: [
        listItemIndex3(context,index),
        listItemIndex2(context,index),
        listItemCenter(context,index),
        listItemIndex2(context,index),
        listItemIndex3(context,index),
      ],
    );
  }



  Widget listItemCenter(BuildContext context, int index) {
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
              [
                Column(
                  children: [
                    Container(height: 1, width: 180, color: AppColors.PM_GRAY3,margin: EdgeInsets.only(top: 5, bottom: 5),),
                    Text('Mar, 04 Mag 2021', style: TextStyle(
                        color: AppColors.PM_LIGHT_BLUE, fontSize: 20),),
                    Container(height: 1, width: 180, color: AppColors.PM_GRAY3,margin: EdgeInsets.only(top: 5, bottom: 5),),
                  ],
                ),
                Column(
                  children: [
                    Divider(
                      height:10, thickness: 2, color: AppColors.PM_GRAY2,),
                    Text('11', style: TextStyle(
                        color: AppColors.PM_LIGHT_BLUE, fontSize: 20)),
                    Divider(height: 5, thickness: 2, color: AppColors.PM_GRAY2),
                  ],
                ),
                Column(
                  children: [
                    Divider(
                      height: 5, thickness: 2, color: AppColors.PM_GRAY,),
                    Text('30', style: TextStyle(
                        color: AppColors.PM_LIGHT_BLUE, fontSize: 20)),
                    Divider(height: 5, thickness: 2, color: AppColors.PM_GRAY2),
                  ],
                ),

              ],)
          ],
        )


    );
  }

  Widget listItemIndex2(BuildContext context, int index) {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
          [
            Text('Mar, 04 Mag 2021',
              style: TextStyle(color: AppColors.PM_TEXT, fontSize: 18),),
            Text(
                '11', style: TextStyle(color: AppColors.PM_TEXT, fontSize: 18)),
            Text(
                '30', style: TextStyle(color: AppColors.PM_TEXT, fontSize: 18)),
          ],)
    );
  }

  Widget listItemIndex3(BuildContext context, int index) {
    return Container(
      color: AppColors.PM_GRAY70,
      margin: EdgeInsets.only(top: 5, bottom: 5),
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
          [
            Text('Mar, 04 Mag 2021',
              style: TextStyle(color: AppColors.PM_TEXT, fontSize: 18),),
            Text(
                '11', style: TextStyle(color: AppColors.PM_TEXT, fontSize: 18)),
            Text(
                '30', style: TextStyle(color: AppColors.PM_TEXT, fontSize: 18)),
          ],)
    );
  }
  */

}
