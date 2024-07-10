import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';

import '../generated/l10n.dart';
import '../static_function.dart';
import '../tool/time_stamp_embed_widget.dart';

class RecordEditPage extends StatefulWidget {
  final String parentId;
  final String selectId;
  final String title;

  const RecordEditPage(
      {super.key,
      required this.parentId,
      required this.selectId,
      required this.title});

  @override
  State<RecordEditPage> createState() => _RecordEditPageState();
}

enum _SelectionType {
  none,
  word,
  // line,
}

class _RecordEditPageState extends State<RecordEditPage> {
  QuillController? _controller;
  final FocusNode _focusNode = FocusNode();
  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;

  TextEditingController titleController = TextEditingController();
  late String date, date_inital;

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
        "${widget.title} ${S.of(context).record_of}",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 20.w),
      )),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_sharp,
          size: 22.w,
        ),
      ),
      actions: [
        SizedBox(
          width: 40.w,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _selectAllTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadFromDB();
  }

  Future<void> _loadFromDB() async {
    Document doc;
    if (int.parse(widget.selectId) == 0) {
      date = DateTime.now().toString();
      doc = Document();
    } else {
      titleController.text =
          StaticFunction.prefs.getString("${widget.selectId}_t")!;
      date = StaticFunction.prefs.getString("${widget.selectId}_d")!;
      String result = StaticFunction.prefs.getString("${widget.selectId}_j")!;
      doc = Document.fromJson(jsonDecode(result));
    }
    date_inital = date;
    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (_controller == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }

    return Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.grey,
        body: Column(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 8.h, bottom: 8.h, right: 20.w, left: 20.w),
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.w)),
                      ),
                      child: Center(
                        child: TextField(
                          controller: titleController,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 20.w),
                          decoration: InputDecoration(
                            labelText: S.of(context).title,
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
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 8.h, bottom: 8.h, right: 20.w, left: 20.w),
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.w)),
                      ),
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime.parse(date_inital),
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            date = newDate.toString();
                          });
                        },
                        use24hFormat: true,
                        minimumYear: 1999,
                        maximumYear: 3000,
                        minuteInterval: 1,
                        mode: CupertinoDatePickerMode.date,
                        dateOrder: DatePickerDateOrder.ymd,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 8.h, bottom: 8.h, right: 20.w, left: 20.w),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: ScreenUtil().screenHeight - 250.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.w)),
                      ),
                      child: Column(
                        children: [
                          QuillToolbar.simple(configurations: QuillSimpleToolbarConfigurations(controller: _controller!)),
                          Container(
                            child: _buildEditorArea(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(90.w)),
          ),
          child: IconButton(
            onPressed: () {
              var json = jsonEncode(_controller?.document.toDelta().toJson());
              _save(json);
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            iconSize: 30.w,
            tooltip: S.of(context).save,
          ),
        ));
  }

  bool _onTripleClickSelection() {
    final controller = _controller!;

    _selectAllTimer?.cancel();
    _selectAllTimer = null;

    // If you want to select all text after paragraph, uncomment this line
    // if (_selectionType == _SelectionType.line) {
    //   final selection = TextSelection(
    //     baseOffset: 0,
    //     extentOffset: controller.document.length,
    //   );

    //   controller.updateSelection(selection, ChangeSource.REMOTE);

    //   _selectionType = _SelectionType.none;

    //   return true;
    // }

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      _startTripleClickTimer();
      return false;
    }

    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );

      controller.updateSelection(selection, ChangeSource.remote);

      // _selectionType = _SelectionType.line;

      _selectionType = _SelectionType.none;

      _startTripleClickTimer();

      return true;
    }

    return false;
  }

  void _startTripleClickTimer() {
    _selectAllTimer = Timer(const Duration(milliseconds: 900), () {
      _selectionType = _SelectionType.none;
    });
  }

  Widget _buildEditorArea(BuildContext context) {
    Widget quillEditor = QuillEditor.basic(
       configurations: QuillEditorConfigurations(controller: _controller!,
         scrollable: true,
         autoFocus: false,
         placeholder: S.of(context).add_here,
         enableSelectionToolbar: isMobile(supportWeb: false),
         expands: false,
         padding: EdgeInsets.zero,
         onImagePaste: _onImagePaste,
         onTapUp: (details, p1) {
           return _onTripleClickSelection();
         },
         customStyles: const DefaultStyles(
           h1: DefaultTextBlockStyle(
               TextStyle(
                 fontSize: 32,
                 color: Colors.black,
                 height: 1.15,
                 fontWeight: FontWeight.w300,
               ),
               VerticalSpacing(16, 0),
               VerticalSpacing(0, 0),
               null),
           sizeSmall: TextStyle(fontSize: 9),
         ),),
    );

    return quillEditor;
  }

  Future<String> _onImagePaste(Uint8List imageBytes) async {
    // Saves the image to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = await File(
            '${appDocDir.path}/${basename('${DateTime.now().millisecondsSinceEpoch}.png')}')
        .writeAsBytes(imageBytes, flush: true);
    return file.path.toString();
    // return" file.path.toString()";
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
      ),
    );
  }

  void _save(jsonString) async {
    if (titleController.text.isEmpty) {
      _showSnackBar(S.of(context).title_warning);
      return;
    }

    Map<String, String> data = {};
    data['json'] = jsonString;
    data['title'] = titleController.text;
    data['date'] = date.toString();

    int result = await StaticFunction.getInstance().editRecord(
        int.parse(widget.parentId), int.parse(widget.selectId), data);

    if (mounted) {
      switch (result) {
        case 0:
          _showSnackBar(S.of(context).save_err);
        case 1:
          _showSnackBar(S.of(context).save_success);
          Navigator.pop(context);
      }
    }
  }
}
