import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  // PORTS
  List<String> availablePorts = [];

  // FILE
  List<String> fileNames = [];
  int get fileCount => fileNames.length;

  void setAvailablePorts(List<String> availablePorts) {
    this.availablePorts = availablePorts;
    notifyListeners();
  }

  void setFileNames(List<String> fileNames) {
    this.fileNames = fileNames;
    notifyListeners();
  }

  // File file;
  // IOSink sink;
}
