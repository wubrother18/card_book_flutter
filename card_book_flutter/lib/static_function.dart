import 'dart:convert';
import 'dart:ui';

import 'package:card_book_flutter/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/record_model.dart';

class StaticFunction {
  /// 單例
  static final StaticFunction self = StaticFunction();

  ///共用
  static late SharedPreferences prefs;

  ///使用者變數
  static List<Color> colors = [Colors.amber, Colors.amberAccent,Colors.white];

  // late State<HomeScreen> state;
  static StaticFunction getInstance() {
    return self;
  }

  void setState(State<HomeScreen>  state){
    // this.state = state;
  }

  Future<void> addItemOfHome () async {
    List<String> items = [];
    if(StaticFunction.prefs.getStringList('mainTree')!=null){
      items = StaticFunction.prefs.getStringList('mainTree')!;
    }
    items.add('{"id": "","position": "","count": 0,"title": "沒錢哭哭喔","type": "","colors":["0xaaaaaaaa","0","0xffffffff"],"childList":[""]}');

    await prefs.setStringList('mainTree', items);

    // items.add('{"id": "","position": "","count": 0,"title": "按一下新增分類","type": "","colors":["0xffffffff","0","0xffffffff"],"childList":[]}');
    // state.widget.recordList.clear();
    // for(int i = 0;i<items!.length;i++){
    //   Map<String,dynamic> map = jsonDecode(items[i]);
    //   state.setState(() {
    //     Map<String,dynamic> map = jsonDecode(items[i]);
    //     state.widget.recordList.add(RecordModel.fromJson(map));
    //   });
    // }

  }

  Future<void> deleteItemOfHome (int index) async {
    List<String> items = [];
    if(StaticFunction.prefs.getStringList('mainTree')!=null){
      items = StaticFunction.prefs.getStringList('mainTree')!;
    }
    items.removeAt(items.length-1);
    await prefs.setStringList('mainTree', items);
    // items.add('{"id": "","position": "","count": 0,"title": "按一下新增分類","type": "","colors":["0xffffffff","0","0xffffffff"],"childList":[]}');
    // state.widget.recordList.clear();
    // for(int i = 0;i<items!.length;i++){
    //   Map<String,dynamic> map = jsonDecode(items[i]);
    //   state.setState(() {
    //     Map<String,dynamic> map = jsonDecode(items[i]);
    //     state.widget.recordList.add(RecordModel.fromJson(map));
    //   });
    // }
  }
}
