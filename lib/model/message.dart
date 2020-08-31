import 'package:flutter/material.dart';

@immutable
class MyMessage {
  final String title;
  final String body;

  const MyMessage({
    @required this.title,
    @required this.body,
  });
}