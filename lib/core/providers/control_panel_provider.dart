
import 'package:flutter/material.dart';

class ControlPanelProvider extends ChangeNotifier {
  String hizDegeri = "0";
  String zamanDegeri = "0";
  String bataryaSicakligi = "0";
  String bataryaGerilimi = "0";
  String kalanEnerji = "0";

  void setHizDegeri(String hizDegeri) {
    this.hizDegeri = hizDegeri;
    notifyListeners();
  }

  void setZamanDegeri(String zamanDegeri) {
    this.zamanDegeri = zamanDegeri;
    notifyListeners();
  }

  void setBataryaSicakligi(String bataryaSicakligi) {
    this.bataryaSicakligi = bataryaSicakligi;
    notifyListeners();
  }

  void setBataryaGerilimi(String bataryaGerilimi) {
    this.bataryaGerilimi = bataryaGerilimi;
    notifyListeners();
  }

  void setKalanEnerji(String kalanEnerji) {
    this.kalanEnerji = kalanEnerji;
    notifyListeners();
  }

  void reset() {
    hizDegeri = "0";
    zamanDegeri = "0";
    bataryaSicakligi = "0";
    bataryaGerilimi = "0";
    kalanEnerji = "0";
    notifyListeners();
  }
}