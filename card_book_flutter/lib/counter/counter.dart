import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Counter extends StatefulWidget {
  bool editable;
  int weight;
  String title;
  Counter({super.key, required this.editable, required this.weight, required this.title});

  @override
  State<Counter> createState() => _CounterState();

  void setEditable(bool editable){
    this.editable = editable;
  }

  List getData(){
    return [weight, title];
  }
}

class _CounterState extends State<Counter> {
  ///建立title controller變數
  TextEditingController titleController = TextEditingController();
  late Timer _timer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(widget.title != null){
    //   titleController.text = widget.title!;
    // }else{
    //   titleController.text = '要計算的目標';
    // }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        // padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            color: Colors.purple,
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
            ),
            // const SizedBox(height: 10.0),
            Text(
              "${widget.weight}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            // const SizedBox(height: 10.0),
            widget.editable? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Container(
                        color: Colors.white,
                        width: 20,
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
                    _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                      setState(() {
                        if (widget.weight > 0) widget.weight--;
                      });
                      print('value ${widget.weight}');
                    });
                  },
                  onTapUp: (TapUpDetails details) {
                    print('up');
                    _timer.cancel();
                  },
                  onTapCancel: () {
                    print('cancel');
                    _timer.cancel();
                  },
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 40.0,
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
                    _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                      setState(() {
                        widget.weight++;
                      });
                      print('value ${widget.weight}');
                    });
                  },
                  onTapUp: (TapUpDetails details) {
                    print('up');
                    _timer.cancel();
                  },
                  onTapCancel: () {
                    print('cancel');
                    _timer.cancel();
                  },
                ),
              ],
            ) : Container(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
