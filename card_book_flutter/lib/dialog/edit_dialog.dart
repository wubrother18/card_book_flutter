import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDialog extends StatefulWidget {
  String title, text;
  Map<String, String> data;
  bool isCategory = false;
  Function positive;

  EditDialog(this.title, this.text, this.isCategory, this.data, this.positive,
      {super.key});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  String color = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.data["title"]!;
    valueController.text = widget.data["value"]!;
    colorController.text = widget.data["color"]!;

    color = colorController.text;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      child: Stack(
        children: <Widget>[
          Container(
            width: 500.w,
            padding:
                const EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 25),
            // margin: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 12.h,
                ),
                TextField(
                  controller: titleController,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20.w),
                  decoration: InputDecoration(
                    labelText: "Title",
                    isCollapsed: true,
                    contentPadding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  maxLength: 5,
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 8.h,
                ),
                !widget.isCategory
                    ? TextField(
                        controller: valueController,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20.w),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding:
                              EdgeInsets.only(top: 10.h, bottom: 10.h),
                          labelText: "Value",
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                        maxLength: 5,
                        keyboardType: TextInputType.number,
                      )
                    : Container(),
                !widget.isCategory
                    ? SizedBox(
                        height: 8.h,
                      )
                    : const SizedBox(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150.w,
                      height: 30.h,
                      child: Text(
                        "Select Color:",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.black, fontSize: 20.w),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  // child: ColorPicker(
                                  //   pickerColor: Color(int.parse(color)),
                                  //   onColorChanged: (newColor){
                                  //     setState(() {
                                  //       color = newColor.toString().split("(")[1].replaceAll(")", "");
                                  //       colorController.text = color;
                                  //     });
                                  //   },
                                  // ),
                                  // Use Material color picker:
                                  //
                                  // child: MaterialPicker(
                                  //   pickerColor: pickerColor,
                                  //   onColorChanged: changeColor,
                                  //   showLabel: true, // only on portrait mode
                                  // ),
                                  //
                                  /// Use Block color picker:
                                  //
                                  child: BlockPicker(
                                    pickerColor: Color(int.parse(color)),
                                    onColorChanged: (newColor) {
                                      setState(() {
                                        print(newColor.toString());
                                        color =
                                            "0x${newColor.toString().split("0x")[1].replaceAll(")", "")}";
                                        colorController.text = color;
                                      });
                                    },
                                  ),
                                  //
                                  // child: MultipleChoiceBlockPicker(
                                  //   pickerColors: currentColors,
                                  //   onColorsChanged: changeColors,
                                  // ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        height: 30.h,
                        width: 30.w,
                        color: Color(int.parse(color)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                !widget.isCategory
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.note_add,
                              size: 30.w,
                            ),
                            tooltip: "add new note",
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.pageview,
                              size: 30.w,
                            ),
                            tooltip: "view note list",
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                                color: Colors.teal,
                                onPressed: () {
                                  widget.data['color'] = colorController.text;
                                  widget.data['value'] = valueController.text;
                                  widget.data['title'] = titleController.text;
                                  widget.positive.call(widget.data);
                                },
                                child: Text(
                                  widget.text,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.photo,
                              size: 30.w,
                            ),
                            tooltip: "edit picture",
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                                color: Colors.teal,
                                onPressed: () {
                                  widget.data['color'] = colorController.text;
                                  widget.data['value'] = valueController.text;
                                  widget.data['title'] = titleController.text;
                                  widget.positive.call(widget.data);
                                },
                                child: Text(
                                  widget.text,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 8.h,
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: MaterialButton(
                //       color: Colors.teal,
                //       onPressed: () {
                //         widget.data['color'] = colorController.text;
                //         widget.data['value'] = valueController.text;
                //         widget.data['title'] = titleController.text;
                //         widget.positive.call(widget.data);
                //       },
                //       child: Text(
                //         widget.text,
                //         style:
                //             const TextStyle(fontSize: 18, color: Colors.white),
                //       )),
                // ),
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
      ),
    );
  }
}
