import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String titleText;
  final String messageText;
  final Object? errorDetails;
  final void Function() onDismiss;

  ErrorMessage({
    Key? key,
    this.titleText = 'Error',
    required this.messageText,
    this.errorDetails,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleText),
      elevation: 5,
      actionsPadding: EdgeInsets.symmetric(horizontal: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
              Text(messageText),
            ] +
            (errorDetails != null
                ? <Widget>[
                    Padding(padding: EdgeInsets.all(10)),
                    buildErrorDetails(),
                  ]
                : <Widget>[]),
      ),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: Text('Dismiss'),
        ),
      ],
    );
  }

  Widget buildErrorDetails() {
    return Container(
      child: Text(
        '$errorDetails',
        style: TextStyle(
          fontFamily: 'monospaced',
          fontSize: 11,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(),
      ),
    );
  }
}
