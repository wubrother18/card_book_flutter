import 'package:card_book_flutter/counter/counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ///建立title controller變數
  TextEditingController titleController = TextEditingController();

  List<Counter> counterList = [];

  bool editable = true;

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Center(
          child: TextField(
        textAlign: TextAlign.center,
        controller: titleController,
        style: TextStyle(color: Colors.white),
      )),
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu),
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
                ));
              }
              counterList.clear();
              counterList= tmpList;
            });
          },
          icon: const Icon(Icons.remove_red_eye),
        ),
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
      counterList.add(Counter(
        editable: editable,
        weight: 0,
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
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //每行三列
          childAspectRatio: 0.8, //顯示區域寬高相等
        ),
        itemCount: counterList.length,
        itemBuilder: (context, index) {
          return counterList[index];
        },
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
