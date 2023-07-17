import 'package:flutter/cupertino.dart';

class HideKeyboard extends StatelessWidget {
  final Widget child;

  const HideKeyboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          /// 取消焦點，相當於關閉鍵盤
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }
}
