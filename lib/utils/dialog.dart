import 'package:flutter/material.dart';

class LoadingDialog {
  String message;
  BuildContext context;

  LoadingDialog(this.message, this.context);

  void Show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: SimpleDialog(
        backgroundColor: Colors.white,
        children: <Widget>[
          Center(
            child: Column(children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.blueAccent),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class MessageDialog {
  String title;
  String message;
  BuildContext context;

  MessageDialog(this.title, this.message, this.context);

  void Show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: SimpleDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Center(
              child: Column(children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
