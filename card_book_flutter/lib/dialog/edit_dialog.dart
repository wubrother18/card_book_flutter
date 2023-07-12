import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDialog extends StatefulWidget {
  String title, text;
  Map<String, String> data;
  bool isCategory = false;
  Function positive;

  EditDialog(this.title, this.text, this.isCategory, this.data, this.positive, {super.key});

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
            const EdgeInsets.only(left: 25, top: 50, right: 25, bottom: 25),
            // margin: const EdgeInsets.only(top: 40),
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
                  widget.title,
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                !widget.isCategory ? TextField(
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
                ): Container(),
                !widget.isCategory ? const SizedBox(
                  height: 8,
                ) : const SizedBox(),
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
                          setState(() {
                            if(colorController.text.isNotEmpty && int.parse(colorController.text) < 0xFFFFFFFF){
                              color = colorController.text;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Container(
                      height: 30.h,
                      width: 30.w,
                      color: Color(int.parse(color)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                !widget.isCategory ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.note_add),tooltip: "add new note",),
                    IconButton(onPressed: (){}, icon: Icon(Icons.pageview),tooltip: "view note list",),
                  ],
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.photo),tooltip: "edit picture",),
                  ],
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
      ),
    );
  }

}