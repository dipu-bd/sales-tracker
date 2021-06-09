import 'package:flutter/material.dart';
import 'package:sales_tracker/src/pages/widgets/error_message.dart';

Future<T?> showFutureLoading<T>({
  required BuildContext context,
  required Future<T> future,
  required String loadingText,
  required String errorText,
}) {
  return showDialog<T>(
    context: context,
    builder: (_) => FutureBuilder<T?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Card(
              child: Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(loadingText),
                  ],
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return ErrorMessage(
            messageText: errorText,
            errorDetails: snapshot.error,
            onDismiss: () => Navigator.of(context).pop(),
          );
        }
        Navigator.of(context).pop(snapshot.data!);
        return Container();
      },
    ),
  );
}
