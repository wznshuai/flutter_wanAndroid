import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }
}
