import 'dart:math';

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' hide context;
import 'package:card_book_flutter/chart/pie_chart_sample2.dart';
import 'package:card_book_flutter/counter/record_edit_page.dart';
import 'package:card_book_flutter/dialog/dialog_helper.dart';
import 'package:card_book_flutter/setting/about.dart';
import 'package:card_book_flutter/upload/google_drive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../admob/ad_helper.dart';
import '../generated/l10n.dart';
import '../static_function.dart';
import 'counter.dart';

class CounterPage extends StatefulWidget {
  final String parentId;
  String title;

  CounterPage({super.key, required this.parentId,  required this.title});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  List<Counter> counterList = [];
  List<int> selectList = [];

  bool editable = true;
  bool selectMode = false;

  // COMPLETE: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  static const platform = MethodChannel('package/Main');

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
        style: TextStyle(color: Colors.black, fontSize: 20.w),
      )),
      leading: int.parse(widget.parentId) == 0
          ? IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
            )
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_sharp),
            ),
      actions: [
        selectMode
            ? IconButton(
                onPressed: () {
                  if (selectList.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogHelper.showWarning(context, S.of(context).delete,
                              S.of(context).delete_question, S.of(context).yes, () {
                            Navigator.pop(context);
                            for (int i = 0; i < selectList.length; i++) {
                              _decrementCounter(selectList[i].toString());
                            }
                          });
                        });
                  }
                },
                icon: const Icon(Icons.delete),
              )
            : IconButton(
                onPressed: () {
                  editable = !editable;
                  _reloadList();
                },
                icon: const Icon(Icons.remove_red_eye),
              ),
        selectMode
            ? IconButton(
                onPressed: () {
                  if (selectList.length == 2) {
                    _swapCounter(selectList[0], selectList[1]);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogHelper.showWarning(context, S.of(context).swap,
                              S.of(context).switch_question, S.of(context).ok, () {
                            Navigator.pop(context);
                          });
                        });
                  }
                },
                icon: const Icon(Icons.swap_horiz),
              )
            : IconButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PieChartSample2(
                  //               dataList: counterList,
                  //             )));
                  if (_interstitialAd != null) {
                    _interstitialAd?.show();
                  } else {
                    _loadInterstitialAd();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PieChartSample2(
                                  dataList: counterList,
                                )));
                  }
                },
                icon: const Icon(Icons.compare),
              ),
        selectMode
            ? IconButton(
                onPressed: () {
                  if (selectList.length == 1) {
                    Map<String, String> data = {};
                    if (StaticFunction.prefs
                        .containsKey("${selectList[0]}_ch")) {
                      data['category'] = "1";
                    }
                    data['color'] =
                        StaticFunction.prefs.getString("${selectList[0]}_c")!;
                    data['value'] =
                        StaticFunction.prefs.getString("${selectList[0]}_v")!;
                    data['title'] =
                        StaticFunction.prefs.getString("${selectList[0]}_t")!;
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogHelper.showCounterEdit(context, data,
                              (data, addNote) {
                            Navigator.pop(context);
                            _editCounter(selectList[0], data, addNote);
                          });
                        });
                  } else if (selectList.length > 1) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return DialogHelper.showWarning(
                              context,
                              S.of(context).edit,
                              S.of(context).edit_question,
                              S.of(context).ok, () {
                            Navigator.pop(context);
                          });
                        });
                  }
                },
                icon: const Icon(Icons.edit),
              )
            :
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
                  _showSnackBar(S.of(context).help_message);
                },
                icon: const Icon(Icons.help),
              ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
      ),
    );
  }

  void _incrementCounter() async {
    await StaticFunction.getInstance().addCounter(int.parse(widget.parentId),context);
    _reloadList();
  }

  void _decrementCounter(String selectId) async {
    await StaticFunction.getInstance()
        .deleteCounter(int.parse(selectId), int.parse(widget.parentId));
    _reloadList();
    if (counterList.isEmpty) {
      editable = true;
      setState(() {
        selectMode = false;
      });
    }
  }

  void _swapCounter(int selectId1, int selectId2) async {
    await StaticFunction.getInstance()
        .exchangeCounter(selectId1, selectId2, int.parse(widget.parentId));
    _reloadList();
  }

  void _editCounter(int selectId, data, int addNote) async {
    if (addNote == 1) {
      startForResult(RecordEditPage(
        parentId: selectList[0].toString(),
        selectId: "0",
        title: StaticFunction.prefs.getString("${selectList[0]}_t")!,
      ));
    } else if (addNote == 2) {
      List<String> textList = [];
      String tmpList = StaticFunction.prefs.getString("${selectList[0]}_r")!;
      for (int i = 0; i < tmpList.split(",").length; i++) {
        if (tmpList.split(",")[i].isNotEmpty) {
          textList.add(
              StaticFunction.prefs.getString("${tmpList.split(",")[i]}_t")!);
        }
      }
      showDialog(
          context: context,
          builder: (context) {
            return DialogHelper.showChoiceDialog(
                context, S.of(context).record_List, S.of(context).record_describe, textList, (value) {
              Navigator.pop(context);
              startForResult(RecordEditPage(
                parentId: selectList[0].toString(),
                selectId: tmpList.split(",")[value],
                title: StaticFunction.prefs.getString("${selectList[0]}_t")!,
              ));
            });
          });
    } else {
      await StaticFunction.getInstance().editCounter(selectId, data);
      _reloadList();
    }
  }

  void _incrementCategory() async {
    await StaticFunction.getInstance().addCategory(int.parse(widget.parentId), context);
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
        value:
            int.parse(StaticFunction.prefs.getString("${tmpChildList[i]}_v")!),
        title: StaticFunction.prefs.getString("${tmpChildList[i]}_t")!,
        color: StaticFunction.prefs.getString("${tmpChildList[i]}_c")!,
        isCategory: StaticFunction.prefs.containsKey("${tmpChildList[i]}_ch"),
        id: int.parse(tmpChildList[i]),
        callback: (value) {
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

  void _callback(int selectId) {
    if (selectId == 0) {
      if (selectMode) {
        editable = true;
      } else {
        editable = false;
      }
      setState(() {
        selectMode = !selectMode;
      });
      _reloadList();
      selectList.clear();
    } else if (selectId < 0) {
      int id = 0 - selectId;
      var widget = CounterPage(
          parentId: id.toString(),
          title: StaticFunction.prefs.getString("${id}_t")!);
      startForResult(widget);
    } else {
      if (selectList.contains(selectId)) {
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
    _loadInterstitialAd();
    if (StaticFunction.prefs.getString("${widget.parentId}_ch") != null) {
      _reloadList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.title.isEmpty){
      setState(() {
        widget.title = S.of(context).main_category;
      });
    }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: editable
          ? Container(
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
                          label: Text(S.of(context).new_count)),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: TextButton.icon(
                          onPressed: () {
                            _incrementCategory();
                          },
                          icon: const Icon(Icons.folder),
                          label: Text(S.of(context).new_category)),
                    ),
                  ];
                },
                onSelected: (value) {
                  _incrementCounter();
                },
              ),
            )
          : null,
      bottomNavigationBar: editable
          ? BottomAppBar(
              padding: EdgeInsets.zero,
              height: 50.h,
              notchMargin: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: StaticFunction.colors),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        // color: Colors.white,
                      ),
                      onPressed: () {
                        _showSnackBar(S.of(context).coming_soon);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cloud_upload,
                        // color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DialogHelper.showWarning(
                                  context,
                                  S.of(context).export,
                                  S.of(context).export_describe,S.of(context).yes, () {
                                Navigator.pop(context);
                                _exportSharePreference();
                              });
                            });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        // color: Colors.white,
                      ),
                      onPressed: () {
                        // _showSnackBar("Change settings or see licenses");
                        startForResult(AboutPage());
                      },
                    ),
                    SizedBox(),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    // COMPLETE: Dispose an InterstitialAd object
    _interstitialAd?.dispose();

    super.dispose();
  }

  void startForResult(Widget widget) async {
    /// do switch and prepare

    /// goto widget
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));

    /// back with result
    if (mounted) {
      _reloadList();
    }
  }

  // COMPLETE: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _interstitialAd = null;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PieChartSample2(
                            dataList: counterList,
                          )));
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  Future<String> dirpath() async {
    String downloadDirectory = "";
    if (Platform.isAndroid) {
      downloadDirectory = Directory('/storage/emulated/0/Download').path;
    } else {
      final downloadFolder = await getDownloadsDirectory();
      if (downloadFolder != null) {
        downloadDirectory = downloadFolder.path;
      }
    }
    return downloadDirectory;
  }

  Future<void> _exportSharePreference() async {
    //check permission
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    String appDocDirString = appDocDir.path;
    appDocDirString = appDocDirString.replaceAll("app_flutter", "shared_prefs");

    print("dir $appDocDirString");
    final file = await File(
        '$appDocDirString/${basename('FlutterSharedPreferences.xml')}');
    // return file.path.toString();

    // Read the file
    final contents = await file.readAsString();

    // final outPutDir = await dirpath();
    // final fileOut =
    //     File('${outPutDir.toString()}/${basename('SharedPreferences.xml')}')
    //         .writeAsString(contents)
    //         .whenComplete(() =>
    //             _showSnackBar(S.of(context).export_success))
    //         .catchError((err) {
    //   _showSnackBar("${S.of(context).export_fail} $err");
    // });
    try {
      final int result = await platform.invokeMethod('writeFile',contents);
    } on PlatformException catch (e) {
      _showSnackBar("${S.of(context).export_fail} $e");
    }
    // return" file.path.toString()";
  }
}
