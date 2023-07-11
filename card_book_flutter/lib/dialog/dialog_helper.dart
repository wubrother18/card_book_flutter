import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogHelper {
  static AlertDialog showWarning (BuildContext context,title,descriptions,text, Function callback) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      content: _warningContentBox(context, title, descriptions, text,callback),
    );
  }

  static AlertDialog showCounterEdit (BuildContext context, data, Function positive) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: _counterEditContentBox(context, "Counter Edit", "SAVE", data, positive),
    );
  }

  static Widget _warningContentBox(context,title,descriptions,text,callback) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
          const EdgeInsets.only(left: 25, top: 50, right: 25, bottom: 25),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                descriptions,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                    color: Colors.teal,
                    onPressed: () {
                      callback.call();
                    },
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 30,
          right: 30,
          top: 1,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Icon(Icons.warning,color: Colors.amberAccent, size: 60 ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _counterEditContentBox(context, title, text, Map<String, String> data, positive) {
    TextEditingController titleController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    TextEditingController colorController = TextEditingController();
    titleController.text = data["title"]!;
    valueController.text = data["value"]!;
    colorController.text = data["color"]!;

    String color = colorController.text;
    return Stack(
      children: <Widget>[
        Container(
          padding:
          const EdgeInsets.only(left: 25, top: 50, right: 25, bottom: 25),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style:
                const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: titleController,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20.w),
                decoration: const InputDecoration(
                  labelText: "Title",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  titleController.text = value;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: valueController,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20.w),
                decoration: const InputDecoration(
                  labelText: "Value",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width:200.w,
                    height: 80.h,
                    child:TextField(
                      controller: colorController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20.w),
                      decoration: const InputDecoration(
                        labelText: "Color(max: 0xFFFFFFFF)",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        color = colorController.text;
                      },
                    ),
                  ),
                  Container(
                    color: Color(int.parse(color)),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                    color: Colors.teal,
                    onPressed: () {
                      data['color'] = colorController.text;
                      data['value'] = valueController.text;
                      data['title'] = titleController.text;
                      positive.call(data);
                    },
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
        // const Positioned(
        //   left: 30,
        //   right: 30,
        //   top: 1,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.white,
        //     radius: 40,
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.all(Radius.circular(25)),
        //       child: Icon(Icons.warning,color: Colors.amberAccent, size: 60 ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}