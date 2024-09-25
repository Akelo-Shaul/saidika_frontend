
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saidika_ui/utils/constants.dart';

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios),
      splashRadius: 1,
    ),
    title: Text(
      title,
      style: appTextTheme(context).labelSmall,
    ),
  );
}

AppBar appBarWithActions(
    BuildContext context, String title, List<Widget> actions, {TextStyle? titleStyle}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios),
      splashRadius: 1,
    ),
    title: Text(
      title,
      style: titleStyle ?? appTextTheme(context).labelSmall,
    ),
    actions: actions,
  );
}
