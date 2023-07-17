import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';
import '../static_function.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final List<Widget> _licenses = <Widget>[];
  final Map<String, List<Widget>> _licenseContent = {};
  bool _loaded = false;

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
        S.of(context).about,
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
        )
      ],
    );
  }

  Future<void> _initLicenses() async {
    // most of these part are taken from flutter showLicensePage
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      List<Widget> tempSubWidget = [];
      final List<LicenseParagraph> paragraphs =
          await SchedulerBinding.instance.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
        debugLabel: 'License',
      );
      if (_licenseContent.containsKey(license.packages.join(', '))) {
        tempSubWidget = _licenseContent[license.packages.join(', ')]!;
      }
      for (LicenseParagraph paragraph in paragraphs) {
        if (paragraph.indent == LicenseParagraph.centeredIndent) {
          tempSubWidget.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              paragraph.text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ));
        } else {
          tempSubWidget.add(Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              paragraph.text,
            ),
          ));
        }
      }
      tempSubWidget.add(Divider());
      _licenseContent[license.packages.join(', ')] = tempSubWidget;
    }

    _licenses.add(
      Text(
        "  This app used following licenses:",
        style: TextStyle(color: Colors.white, fontSize: 18.w),
      ),
    );

    _licenseContent.forEach((key, value) {
      int count = 0;
      value.forEach((element) {
        if (element.runtimeType == Divider) count += 1;
      });
      // Replace ExpansionTile with any widget that suits you
      _licenses.add(ExpansionTile(
        title: Text('$key', style: TextStyle(color: Colors.white)),
        subtitle: Text(
          '$count licenses',
          style: TextStyle(color: Colors.white),
        ),
        children: <Widget>[...value],
      ));
    });

    setState(() {
      _loaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initLicenses();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: _appBar(),
        body: Container(
          width: ScreenUtil().screenWidth,
          color: Colors.grey,
          child: Column(
            children: [
              Text(
                "App Version : 1.0.0",
                style: TextStyle(color: Colors.white, fontSize: 20.w),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: ScreenUtil().screenHeight - 120.h,
                width: ScreenUtil().screenWidth - 16.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: ListView.separated(
                  itemCount: _licenses.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    return _licenses.elementAt(index);
                  },
                ),
              )
            ],
          ),
        ));
  }
}
