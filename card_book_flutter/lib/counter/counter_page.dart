import 'dart:math';

import 'package:card_book_flutter/chart/pie_chart_sample2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../static_function.dart';
import 'counter.dart';

class CounterPage extends StatefulWidget {
  final String parentId;

  const CounterPage({super.key, required this.parentId});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  ///建立title controller變數
  TextEditingController titleController = TextEditingController();

  List<Counter> counterList = [];

  bool editable = true;

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
          child: TextField(
        textAlign: TextAlign.center,
        controller: titleController,
        style: TextStyle(color: Colors.white),
      )),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_sharp),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              editable = !editable;
              List<Counter> tmpList = [];
              for (int i = 0; i < counterList.length; i++) {
                tmpList.add(Counter(
                  editable: editable,
                  weight: counterList[i].getData()[0],
                  title: counterList[i].getData()[1],
                  color: counterList[i].getData()[2],
                ));
              }
              counterList.clear();
              counterList = tmpList;
            });
          },
          icon: const Icon(Icons.remove_red_eye),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PieChartSample2(dataList: counterList,)));
          },
          icon: const Icon(Icons.compare),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  void _incrementCounter() {
    var rng = Random();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      counterList.add(Counter(
        editable: editable,
        weight: 0,
        title: '項目',
        color: rng.nextInt(0xFFFFFFFF).toString(),
      ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = '改成你要計算的項目';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            StaticFunction.colors[2],
            StaticFunction.colors[1],
            StaticFunction.colors[0]
          ]),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                    onPressed: () {},
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
