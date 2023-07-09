import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StaticFunction {
  /// 單例
  static final StaticFunction self = StaticFunction();

  ///共用
  static late SharedPreferences prefs;

  ///使用者變數
  static List<Color> colors = [Colors.amber, Colors.amberAccent,Colors.white];

  static StaticFunction getInstance() {
    return self;
  }


  Future<void> addItemOfHome () async {
    List<String> items = [];
    if(StaticFunction.prefs.getStringList('mainTree')!=null){
      items = StaticFunction.prefs.getStringList('mainTree')!;
    }
    int uuid = DateTime.now().microsecond;
    items.add('{"id": "$uuid","position": "","count": 0,"title": "沒錢哭哭喔","type": "","colors":["0xaaaaaaaa","0","0xffffffff"],"childList":[""]}');

    await prefs.setStringList('mainTree', items);

  }

  Future<void> deleteItemOfHome (int index) async {
    List<String> items = [];
    if(StaticFunction.prefs.getStringList('mainTree')!=null){
      items = StaticFunction.prefs.getStringList('mainTree')!;
    }
    items.removeAt(items.length-1);
    await prefs.setStringList('mainTree', items);

  }

  Future<void> addCounter (int parentId) async {

    var rng = Random();
    int uuid = DateTime.now().microsecondsSinceEpoch;
    int value = 0;
    String color = rng.nextInt(0xFFFFFFFF).toString();
    String title = "項目";
    String record = "";
    await prefs.setString('${uuid}_p', parentId.toString());
    await prefs.setString('${uuid}_v', value.toString());
    await prefs.setString('${uuid}_c', color.toString());
    await prefs.setString('${uuid}_t', title);
    await prefs.setString('${uuid}_r', record);

    String? tmpChildList = prefs.getString("${parentId}_ch");
    if(tmpChildList!=null){
      tmpChildList = "$tmpChildList$uuid,";
    }else{
      tmpChildList = "$uuid,";
    }
    await prefs.setString("${parentId}_ch", tmpChildList);

  }

  Future<void> deleteCounter (int selectId, int parentId) async {
    String? tmpChildList = prefs.getString("${parentId}_ch");
    tmpChildList = tmpChildList?.replaceAll("$selectId,", "");
    await prefs.setString("${parentId}_ch", tmpChildList!);

    await prefs.remove("${selectId}_p");
    await prefs.remove("${selectId}_v");
    await prefs.remove("${selectId}_c");
    await prefs.remove("${selectId}_t");
    await prefs.remove("${selectId}_r");

  }

  Future<void> editCounter (int selectId, Map<String,String> data) async {
    if(data.containsKey("color")){
      await prefs.setString('${selectId}_c', data["color"]!);
    }if(data.containsKey("value")){
      await prefs.setString('${selectId}_v', data["value"]!);
    }if(data.containsKey("title")){
      await prefs.setString('${selectId}_t', data["title"]!);
    }
  }

  Future<void> exchangeCounter (int selectId1, int selectId2, int parentId) async {
    String? tmpChildList = prefs.getString("${parentId}_ch");
    tmpChildList = tmpChildList?.replaceAll("$selectId1,", "tmp");
    tmpChildList = tmpChildList?.replaceAll("$selectId2,", "$selectId1,");
    tmpChildList = tmpChildList?.replaceAll("tmp", "$selectId2,");
    await prefs.setString("${parentId}_ch", tmpChildList!);
  }

}
