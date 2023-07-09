import 'dart:convert';

import 'package:card_book_flutter/counter/counter.dart';
import 'package:card_book_flutter/model/record_model.dart';
import 'package:card_book_flutter/static_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../counter/counter_page.dart';
import 'home_list_item.dart';

class HomeScreen extends StatefulWidget {

  List<RecordModel> recordList = [];
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  List<String> items = [];

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: StaticFunction.colors),
        ),
      ),
      title: Center(
          child: Text(
        "主畫面",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black54),
      )),
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reNewList();
  }

  void reNewList() {
    if(StaticFunction.prefs.getStringList('mainTree')!=null){
      items = StaticFunction.prefs.getStringList('mainTree')!;
    }
    widget.recordList.clear();
    items.add('{"id": "","position": "","count": 0,"title": "按一下新增分類","type": "","colors":["0xffffffff","0","0xffffffff"],"childList":[]}');
    for(int i = 0;i<items!.length;i++){
      Map<String,dynamic> map = jsonDecode(items[i]);
      widget.recordList.add(RecordModel.fromJson(map));
    }
  }

  Future<void> startForResult(String value) async {
    if(value.contains("select")){
      await Navigator.push(context, MaterialPageRoute(builder: (context) => CounterPage(parentId: value.split(":")[1],title: "",)));
    }else  if(value.contains("add")){
      await StaticFunction.getInstance().addItemOfHome();
    }else  if(value.contains("delete")){
      await StaticFunction.getInstance().deleteItemOfHome(0);
    }

    if(mounted){
      setState(() {
        reNewList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.all(8.w),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.bottomCenter,
        //       end: Alignment.topCenter,
        //       colors: [
        //         StaticFunction.colors[2],
        //         StaticFunction.colors[1],
        //         StaticFunction.colors[0]
        //       ]),
        // ),
        child: ListView.builder(
            itemCount: widget.recordList.length,
            itemBuilder: (BuildContext context, int index) {
              return HomeListItem(
                id:widget.recordList[index].id,
                title: widget.recordList[index].title,
                colors: widget.recordList[index].colors,
                childList: widget.recordList[index].childList,
                voidCallback: (value) {
                  startForResult(value);
                },
              );
            }),
      ),
    );
  }

}
