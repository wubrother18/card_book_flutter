import 'package:card_book_flutter/counter/counter_page.dart';
import 'package:card_book_flutter/static_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeListItem extends StatefulWidget {
  final String title;
  final List<String> colors;
  final List<String> childList;
  final Function(String value) voidCallback;

  const HomeListItem(
      {super.key,
      required this.title,
      required this.colors,
      required this.childList,
      required this.voidCallback});

  @override
  State<HomeListItem> createState() => _HomeListItemState();
}

class _HomeListItemState extends State<HomeListItem> {
  void onItemSelect() {
    if (widget.childList.isNotEmpty) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => CounterPage(parentId: "0")));
      widget.voidCallback.call("select");
    } else {
      // StaticFunction.getInstance().addItemOfHome();
      widget.voidCallback.call("add");
    }
  }

  void onItemDelete() {
    // StaticFunction.getInstance().deleteItemOfHome(0);
    widget.voidCallback.call("delete");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        onItemSelect();
      },
      onLongPress: () {
        onItemDelete();
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.all(4.w),
          height: 100.h,
          width: ScreenUtil().screenWidth - 16.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(int.parse(widget.colors[0])),
                  Color(int.parse(widget.colors[1])),
                ]),
            border: Border.all(
              color: Color(int.parse(widget.colors[0])),
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.w)),
          ),
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 50.h),
          ),
        ),
      ),
    );
  }
}
