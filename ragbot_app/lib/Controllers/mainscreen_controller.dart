import 'package:flutter/material.dart';

class MainScreenController extends ChangeNotifier {
  final List<String> _tests = [];

  List<String> get tests => _tests;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  void loadList() async {
    final listToAdd = [
      'Medieval Europe',
      'World War 1',
      'Third World Countries',
    ];

    for (var i = 0; i < listToAdd.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100), () {
        _tests.add(listToAdd[i]);
        listKey.currentState?.insertItem(i);
        notifyListeners();
      });
    }
  }
}
