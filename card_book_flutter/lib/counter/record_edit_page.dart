import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../generated/l10n.dart';
import '../static_function.dart';

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
  final QuillController _controller = () {
    return QuillController.basic(
        config: QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(
            enableExternalRichPaste: true,
            onImagePaste: (imageBytes) async {
              if (kIsWeb) {
                // Dart IO is unsupported on the web.
                return null;
              }
              // Save the image somewhere and return the image URL that will be
              // stored in the Quill Delta JSON (the document).
              final newFileName =
                  'image-file-${DateTime.now().toIso8601String()}.png';
              final newPath = path.join(
                io.Directory.systemTemp.path,
                newFileName,
              );
              final file = await io.File(
                newPath,
              ).writeAsBytes(imageBytes, flush: true);
              return file.path;
            },
          ),
        ));
  }();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();
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
      _controller.document = doc;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: _appBar(),
        backgroundColor: Colors.grey,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
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
                      QuillSimpleToolbar(
                        controller: _controller,
                        config: QuillSimpleToolbarConfig(
                          embedButtons: FlutterQuillEmbeds.toolbarButtons(),
                          showClipboardPaste: true,
                          customButtons: [
                            QuillToolbarCustomButtonOptions(
                              icon: const Icon(Icons.add_alarm_rounded),
                              onPressed: () {
                                _controller.document.insert(
                                  _controller.selection.extentOffset,
                                  TimeStampEmbed(
                                    DateTime.now().toString(),
                                  ),
                                );

                                _controller.updateSelection(
                                  TextSelection.collapsed(
                                    offset: _controller.selection.extentOffset + 1,
                                  ),
                                  ChangeSource.local,
                                );
                              },
                            ),
                          ],
                          buttonOptions: QuillSimpleToolbarButtonOptions(
                            base: QuillToolbarBaseButtonOptions(
                              afterButtonPressed: () {
                                final isDesktop = {
                                  TargetPlatform.linux,
                                  TargetPlatform.windows,
                                  TargetPlatform.macOS
                                }.contains(defaultTargetPlatform);
                                if (isDesktop) {
                                  _editorFocusNode.requestFocus();
                                }
                              },
                            ),
                            linkStyle: QuillToolbarLinkStyleButtonOptions(
                              validateLink: (link) {
                                // Treats all links as valid. When launching the URL,
                                // `https://` is prefixed if the link is incomplete (e.g., `google.com` → `https://google.com`)
                                // however this happens only within the editor.
                                return true;
                              },
                            ),
                          ),
                        ),
                      ),
                      QuillEditor(
                        focusNode: _editorFocusNode,
                        scrollController: _editorScrollController,
                        controller: _controller,
                        config: QuillEditorConfig(
                          placeholder: 'Start writing your notes...',
                          padding: const EdgeInsets.all(16),
                          embedBuilders: [
                            ...FlutterQuillEmbeds.editorBuilders(
                              imageEmbedConfig: QuillEditorImageEmbedConfig(
                                imageProviderBuilder: (context, imageUrl) {
                                  // https://pub.dev/packages/flutter_quill_extensions#-image-assets
                                  if (imageUrl.startsWith('assets/')) {
                                    return AssetImage(imageUrl);
                                  }
                                  return null;
                                },
                              ),
                              videoEmbedConfig: QuillEditorVideoEmbedConfig(
                                customVideoBuilder: (videoUrl, readOnly) {
                                  return null;
                                },
                              ),
                            ),
                            TimeStampEmbedBuilder(),
                          ],
                        ),
                      ),
                    ],
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
            ],
          ),
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

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(
      String value,
      ) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) {
    return node.value.data;
  }

  @override
  Widget build(
      BuildContext context,
      EmbedContext embedContext,
      ) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        Text(embedContext.node.value.data as String),
      ],
    );
  }
}
