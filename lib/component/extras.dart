import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mixin/constants.dart';

bool isDebug = true;
String True = "true";
String False = "false";
const int ERROR = 1;
const int WARN = 2;

void ILogout({required BuildContext context}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('LOGOUT', style: TextStyle(color: Colors.red)),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Are you sure you want to logout ?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Logout'),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              return prefs.clear().then((value) {
                Navigator.of(context).pop();
              });
            },
          ),
        ],
      );
    },
  );
}

ILoader() async {

}

IDialog({required String title, required String message, width = 300.0, height = 100.0}) async {

  }

List<TextSpan> highlight(String source, String query) {
  if (query == null ||
      query.isEmpty ||
      !source.toLowerCase().contains(query.toLowerCase())) {
    return [TextSpan(text: source)];
  }
  final matches = query.toLowerCase().allMatches(source.toLowerCase());

  int lastMatchEnd = 0;

  final List<TextSpan> children = [];
  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);

    if (match.start != lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.start),
      ));
    }

    children.add(TextSpan(
      text: source.substring(match.start, match.end),
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
    ));

    if (i == matches.length - 1 && match.end != source.length) {
      children.add(TextSpan(
        text: source.substring(match.end, source.length),
      ));
    }

    lastMatchEnd = match.end;
  }
  return children;
}

IProc({required String title, required String message, width = 300.0, height = 100.0}) async {

}

