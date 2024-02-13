import 'package:flutter_libserialport/flutter_libserialport.dart';

class PortController {
  List<String> getAvailablePorts() {
    return SerialPort.availablePorts;
  }

  bool isPortsEmpty() {
    return SerialPort.availablePorts.isEmpty ? true : false;
  }
}
