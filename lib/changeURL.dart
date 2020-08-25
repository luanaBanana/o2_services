import 'package:flutter/material.dart';

class ChangeURL extends StatelessWidget {

  final Function selectHandler;

  ChangeURL(this.selectHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.lightBlueAccent,
        child: Text('Change URL'),
        onPressed: selectHandler,


      ),
    );
  }
}