import 'dart:math';

import 'package:card_book_flutter/chart/pie_chart_sample2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../static_function.dart';
import 'counter.dart';

class CounterPage extends StatefulWidget {
  final String parentId;
  final String title;

  const CounterPage({super.key, required this.parentId, required this.title});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  List<Counter> counterList = [];
  List<int> selectList = [];

  bool editable = true;
  bool selectMode = false;

  AppBar _appBar() {
    return AppBar(
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
        widget.title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 20.w),
      )),
      leading: int.parse(widget.parentId) == 0 ? IconButton(
        onPressed: () {

        },
        icon: const Icon(Icons.home),
      ) : IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_sharp),
      ),
      actions: [
        selectMode? IconButton(
          onPressed: () {
            if(selectList.isNotEmpty){
              for (int i =0;i<selectList.length;i++){
                _decrementCounter(selectList[i].toString());
              }
            }
          },
          icon: const Icon(Icons.delete),
        ): IconButton(
          onPressed: () {
            editable = !editable;
            _reloadList();
          },
          icon: const Icon(Icons.remove_red_eye),
        ),
        selectMode?IconButton(
          onPressed: () {
            if(selectList.length == 2) {
              _swapCounter(selectList[0],selectList[1]);
            }
          },
          icon: const Icon(Icons.swap_horiz),
        ):IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PieChartSample2(
                          dataList: counterList,
                        )));
          },
          icon: const Icon(Icons.compare),
        ),
        IconButton(
          onPressed: () {
            // ///testing code
            // String? tmpChild =
            //     StaticFunction.prefs.getString("${widget.parentId}_ch");
            // String selectId = "";
            // if (tmpChild != null) {
            //   selectId = tmpChild.split(",")[0];
            // }
            // _decrementCounter(selectId);

          },
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  void _incrementCounter() async {
    await StaticFunction.getInstance().addCounter(int.parse(widget.parentId));
    _reloadList();
  }

  void _decrementCounter(String selectId) async {
    await StaticFunction.getInstance()
        .deleteCounter(int.parse(selectId), int.parse(widget.parentId));
    _reloadList();
    if(counterList.isEmpty){
      editable = true;
      setState(() {
        selectMode = !selectMode;
      });
    }
  }

  void _swapCounter (int selectId1, int selectId2) async {
    await StaticFunction.getInstance().exchangeCounter(selectId1, selectId2, int.parse(widget.parentId));
    _reloadList();
  }

  void _reloadList() {
    String? tmpChild = StaticFunction.prefs.getString("${widget.parentId}_ch");
    List tmpChildList = [];
    for (int i = 0; i < tmpChild!.split(",").length; i++) {
      if (tmpChild.split(",")[i].isNotEmpty) {
        tmpChildList.add(tmpChild.split(",")[i]);
      }
    }
    List<Counter> tmpList = [];
    for (int i = 0; i < tmpChildList.length; i++) {
      tmpList.add(Counter(
        editable: editable,
        weight:
            int.parse(StaticFunction.prefs.getString("${tmpChildList[i]}_v")!),
        title: StaticFunction.prefs.getString("${tmpChildList[i]}_t")!,
        color: StaticFunction.prefs.getString("${tmpChildList[i]}_c")!,
        id: int.parse(tmpChildList[i]),
        callback: (value){
          _callback(value);
        },
        selectMode: selectMode,
      ));
    }
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      counterList.clear();
      selectList.clear();
      counterList = tmpList;
    });
  }

  void _callback (int selectId) {
    if(selectId == 0) {
      if(selectMode){
        editable = true;
      }else {
        editable = false;
      }
      setState(() {
        selectMode = !selectMode;
      });
      _reloadList();
      selectList.clear();
    } else {
      if(selectList.contains(selectId)){
        selectList.remove(selectId);
      } else {
        selectList.add(selectId);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (StaticFunction.prefs.getString("${widget.parentId}_ch") != null) {
      _reloadList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        color: Colors.grey,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.bottomCenter,
        //       end: Alignment.topCenter,
        //       colors: [
        //     StaticFunction.colors[2],
        //     StaticFunction.colors[1],
        //     StaticFunction.colors[0]
        //   ]),
        // ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //每行三列
            childAspectRatio: 0.8, //顯示區域寬高相等
          ),
          itemCount: counterList.length,
          itemBuilder: (context, index) {
            return counterList[index];
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(90)),
        ),
        child: PopupMenuButton(
          icon: const Icon(Icons.add, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 0,
                child: TextButton.icon(
                    onPressed: () {
                      _incrementCounter();
                    },
                    icon: const Icon(Icons.timer),
                    label: const Text('新增計數項目')),
              ),
              PopupMenuItem(
                value: 1,
                child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.folder),
                    label: const Text('新增分類項目')),
              ),
            ];
          },
          onSelected: (value) {
            _incrementCounter();
          },
        ),
      ),
    );
  }
}
