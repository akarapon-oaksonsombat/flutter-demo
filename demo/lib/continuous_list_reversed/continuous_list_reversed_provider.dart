import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ContinuousListReversedProvider extends ChangeNotifier {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final List<String> _dataList = [];
  List get dataList => _dataList;

  final int loadMoreMax = 5;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void loadMore() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 200));
    for (int i = 0; i < 5; i++) {
      dataList.add(const Uuid().v4());
      if (listKey.currentState != null) {
        listKey.currentState!.insertItem(dataList.length);
      }
      notifyListeners();
    }
    notifyListeners();
  }

  void addNew() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 200));
    dataList.insert(0, const Uuid().v4());
    if (listKey.currentState != null) {
      listKey.currentState!.insertItem(0);
    }
    notifyListeners();
  }

  Future<void> clean({int max = 12}) async {
    _isLoading = true;
    dataList.clear();
    if (listKey.currentState != null) {
      listKey.currentState!.dispose();
    }
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 200));
    for (int i = 0; i <= max; i++) {
      dataList.add(const Uuid().v4());
      if (listKey.currentState != null) {
        listKey.currentState!.insertItem(dataList.length);
      }
      notifyListeners();
    }
    notifyListeners();
  }
}
