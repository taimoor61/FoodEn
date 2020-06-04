import 'package:flutter/material.dart';

class AlertDialogWithMessage extends StatelessWidget {

  AlertDialogWithMessage({@required this.title, @required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      title: Text(title),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          )
      ),
      elevation: 24.0,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0)),
            child: Text(
              "Done",
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
