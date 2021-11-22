import 'package:flutter/cupertino.dart';

class check_Provider extends ChangeNotifier{
  String _Graphcheck='none';
  String get Graphcheck=>_Graphcheck;

  String _Tablecheck='none';
  String get Tablecheck=>_Tablecheck;

  String _page='none';
  String get page=>_page;

  void updateTable(String Tablecheck){
    _Tablecheck=Tablecheck;
    notifyListeners();
  }

  void updatePage(String Page){
    _page=Page;
    notifyListeners();
  }

  void updateGraph(String Graphcheck){
    _Graphcheck=Graphcheck;
    notifyListeners();
  }
}