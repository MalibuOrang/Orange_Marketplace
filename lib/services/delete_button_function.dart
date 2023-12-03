import 'package:flutter/material.dart';

import '../widgets/delete_message_dialog.dart';

class DeleteFuctinoButton {
  onPressDeleteBut(context, data,
      {required Function deleting, required String question}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => deleteDialog(
        context,
        question,
        () {
          deleting();
        },
      ),
    );
    return false;
  }
}
