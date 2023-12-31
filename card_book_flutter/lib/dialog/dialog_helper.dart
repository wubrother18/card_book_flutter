import 'package:card_book_flutter/dialog/edit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';

class DialogHelper {
  static AlertDialog showWarning(
      BuildContext context, title, descriptions, text, Function callback) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: _warningContentBox(context, title, descriptions, text, callback),
    );
  }

  static Widget showCounterEdit(
      BuildContext context, Map<String, String> data, Function positive) {
    String titleText = S.of(context).counter_edit;
    bool isCategory = false;
    if (data.containsKey('category')) {
      titleText = S.of(context).category_edit;
      isCategory = true;
    }
    return _counterEditContentBox(
        context, titleText, S.of(context).save, isCategory, data, positive);
  }

  static Widget showChoiceDialog(
      BuildContext context, title, descriptions, List<String> textList, Function callback) {
    List<Widget> actions = [];
    for(int i = 0; i<textList.length;i++){
      actions.add( MaterialButton(
          color: Colors.teal,
          onPressed: () {
           callback.call(i);
          },
          child: Text(
            textList[i],
            style: const TextStyle(
                fontSize: 18, color: Colors.white),
          )),);
    }
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 22.w,
        ),
      ),
      content: Text(
        descriptions,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.w,
        ),
      ),
      actions: actions,
    );
  }

  static Widget _warningContentBox(
      context, title, descriptions, text, callback) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 25, top: 50, right: 25, bottom: 25),
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                descriptions,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                    color: Colors.teal,
                    onPressed: () {
                      callback.call();
                    },
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 30,
          right: 30,
          top: 1,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Icon(Icons.warning, color: Colors.amberAccent, size: 60),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _counterEditContentBox(
      context, title, text, isCategory, Map<String, String> data, positive) {
    return EditDialog(title, text, isCategory, data, positive);
  }
}
