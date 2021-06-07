import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddProductDialog extends StatelessWidget {
  static void display(BuildContext context) {
    // TODO: open dialog respective of the context
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            buildDateInput()
          ],
        ),
      ),
    );
  }

  Widget buildDateInput() {
    final year = DateTime.now().year;
    return InputDatePickerFormField(
      firstDate: DateTime(year - 10),
      lastDate: DateTime(year + 1),
      initialDate: DateTime.now(),
      fieldLabelText: 'Date',
    );
  }
}
