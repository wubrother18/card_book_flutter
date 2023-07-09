import 'dart:async';

import 'package:card_book_flutter/static_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Counter extends StatefulWidget {
  bool editable;
  int id;
  int weight;
  String title;
  String color;
  Function? callback;
  bool? selectMode;
  bool selected = false;

  Counter(
      {super.key,
      required this.editable,
      required this.id,
      required this.weight,
      required this.title,
      required this.color,
      this.callback,
      this.selectMode});

  @override
  State<Counter> createState() => _CounterState();

  void setEditable(bool editable) {
    this.editable = editable;
  }

  List getData() {
    return [weight, title, color, id];
  }
}

class _CounterState extends State<Counter> {
  ///建立title controller變數
  TextEditingController titleController = TextEditingController();
  late Timer _timer;
  bool changeValue = false;

  void _changeValue() async {
    Future.delayed(Duration.zero, () {
      Map<String, String> data = {};
      data['value'] = widget.weight.toString();
      StaticFunction.getInstance().editCounter(widget.id, data);
      changeValue = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.title != null) {
      titleController.text = widget.title!;
    } else {
      //   titleController.text = '要計算的目標';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Padding(
        padding: widget.selected ? EdgeInsets.zero : EdgeInsets.all(4.w),
        child: GestureDetector(
          onTap: () {
            if(widget.selectMode!){
              setState(() {
                widget.selected = !widget.selected;
              });
              widget.callback?.call(widget.id);
            }
          },
          onLongPress: () {
            if (!changeValue) {
              setState(() {
                widget.selectMode = true;
              });
              widget.callback?.call(0);
            }
          },
          child: Container(
            // padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
                color: Color(int.parse(widget.color)),
                border: widget.selected ? Border.all(
                    color: Colors.white,
                    width: 4.w,
                    style: BorderStyle.solid
                ):null,
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  textAlign: TextAlign.center,
                  controller: titleController,
                  style: TextStyle(
                    fontSize: 18.w,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.title = titleController.text;
                    });
                  },
                ),
                // const SizedBox(height: 10.0),
                Text(
                  "${widget.weight}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.w,
                  ),
                ),
                // const SizedBox(height: 10.0),
                widget.editable
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              width: ScreenUtil().screenWidth / 9,
                              height: ScreenUtil().screenWidth / 9,
                              child: Center(
                                child: Container(
                                  color: Colors.white,
                                  width: ScreenUtil().screenWidth / 27,
                                  height: 5.0,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (widget.weight > 0) widget.weight--;
                              });
                            },
                            onTapDown: (TapDownDetails details) {
                              print('down');
                              changeValue = true;
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 100), (t) {
                                setState(() {
                                  if (widget.weight > 0) widget.weight--;
                                });
                                print('value ${widget.weight}');
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              print('up');
                              _timer.cancel();
                              _changeValue();
                            },
                            onTapCancel: () {
                              print('cancel');
                              _timer.cancel();
                              _changeValue();
                            },
                            onLongPressStart: (details) {
                              print('start');
                              changeValue = true;
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 100), (t) {
                                setState(() {
                                  if (widget.weight > 0) widget.weight--;
                                });
                                print('value ${widget.weight}');
                              });
                            },
                            onLongPressEnd: (detail) {
                              print('end');
                              _timer.cancel();
                              _changeValue();
                            },
                          ),
                          const SizedBox(width: 10.0),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              width: ScreenUtil().screenWidth / 9,
                              height: ScreenUtil().screenWidth / 9,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: ScreenUtil().screenWidth * 2 / 27,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                widget.weight++;
                              });
                            },
                            onTapDown: (TapDownDetails details) {
                              print('down');
                              changeValue = true;
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 100), (t) {
                                setState(() {
                                  widget.weight++;
                                });
                                print('value ${widget.weight}');
                              });
                            },
                            onTapUp: (TapUpDetails details) {
                              print('up');
                              _timer.cancel();
                              _changeValue();
                            },
                            onTapCancel: () {
                              print('cancel');
                              _timer.cancel();
                              _changeValue();
                            },
                            onLongPressStart: (details) {
                              print('start');
                              changeValue = true;
                              _timer = Timer.periodic(
                                  Duration(milliseconds: 100), (t) {
                                setState(() {
                                  widget.weight++;
                                });
                                print('value ${widget.weight}');
                              });
                            },
                            onLongPressEnd: (details) {
                              print('end');
                              _timer.cancel();
                              _changeValue();
                            },
                          ),
                        ],
                      )
                    : Container(
                        height: ScreenUtil().screenWidth / 9,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
