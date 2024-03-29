import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:provider/provider.dart';
import 'package:rotak_arac/core/Constants/colors.dart';
import 'package:rotak_arac/core/extensions/contextExtension.dart';
import 'package:rotak_arac/core/providers/control_panel_provider.dart';
import 'package:rotak_arac/core/providers/main_provider.dart';
import 'package:rotak_arac/feature/widgets/control_panel_field.dart';

class ControlPanelView extends StatefulWidget {
  const ControlPanelView({super.key});

  @override
  State<ControlPanelView> createState() => _ControlPanelViewState();
}

class _ControlPanelViewState extends State<ControlPanelView> {
  File? file;
  SerialPort? port;
  IOSink? sink;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Row(
        children: [
          //* LEFT SIDE - MAP
          Column(
            children: [
              SizedBox(
                height: context.height * 0.125,
              ),
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50, top: 50),
                      child: Container(
                        color: Colors.black,
                        width: context.width * 0.35,
                        height: context.height,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Image.asset(
                            "assets/images/Balıkesir_Üniversitesi_logo.png",
                            width: context.width * 0.07,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/images/road.png',
                  fit: BoxFit.fill,
                  width: context.width * 0.35,
                ),
              )
            ],
          ),
          SizedBox(
            width: context.width * 0.05,
          ),
          //* DATAS
          Consumer<ControlPanelProvider>(
              builder: (context, controlPanelProvider, child) {
            return Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    SizedBox(width: context.width * 0.2),
                    Column(
                      children: [
                        ControlPanelFieldWidget(
                            text: "Zaman: ${controlPanelProvider.zamanDegeri}",
                            color: AppColors.deepBlue,
                            textColor: Colors.white),
                        SizedBox(
                          height: context.height * 0.01,
                        ),
                        ControlPanelFieldWidget(
                            text: "Hız: ${controlPanelProvider.hizDegeri} Km/s",
                            color: AppColors.lightBlue,
                            textColor: Colors.black),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Column(
                      children: [
                        ControlPanelFieldWidget(
                            text:
                                "Batarya Sıcaklığı: ${controlPanelProvider.bataryaSicakligi} °C",
                            color: AppColors.deepBlue,
                            textColor: Colors.white),
                        SizedBox(
                          height: context.height * 0.01,
                        ),
                        ControlPanelFieldWidget(
                            text:
                                "Batarya Gerilimi: ${controlPanelProvider.bataryaGerilimi} V",
                            color: AppColors.lightBlue,
                            textColor: Colors.black),
                      ],
                    ),
                    SizedBox(width: context.width * 0.2),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    SizedBox(width: context.width * 0.2),
                    Column(
                      children: [
                        ControlPanelFieldWidget(
                            text:
                                "Kalan Enerji: ${controlPanelProvider.kalanEnerji} kWh",
                            color: AppColors.deepBlue,
                            textColor: Colors.white),
                        SizedBox(
                          height: context.height * 0.01,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              await sink?.close();
                              port?.close();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: context.width * 0.3,
                              height: context.height * 0.065,
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Text(
                                        "Bağlantıyı Kes",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      width: context.width * 0.005,
                                    ),
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const Spacer(),
              ],
            );
          })
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      portReadingStream();
      // reset all values
      context.read<ControlPanelProvider>().reset();
    });
  }

  Future portReadingStream() async {
    Provider.of<MainProvider>(context, listen: false)
        .setAvailablePorts(SerialPort.availablePorts);

    //* CREATE A CSV FILE WITH NAME DATETIME AND WRITE DATA TO IT
    // String datetime = DateTime.now().toString();
    // datetime = datetime.replaceAll(':', '-');

    // new
    DateTime now = DateTime.now();
    String datetime =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}";
    print(datetime);
    try {
      file = await File('datas/$datetime.csv').create().then((value) async {
        sink = value.openWrite();
        sink?.write(
            'Zaman, Hız, Batarya Sıcaklığı, Batarya Gerilimi, Kalan Enerji \n');
        await sink?.flush();
        // await sink.close();
        return null;
      });
    } catch (e) {
      print(e);
    }

    if (context.read<MainProvider>().availablePorts.isEmpty) {
      print("No serial ports available");
      return;
    } else {
      print(context.read<MainProvider>().availablePorts.first);
    }

    port = SerialPort(context.read<MainProvider>().availablePorts.first);

    if (port != null) {
      if (port!.isOpen) {
        port!.close();
      }
    }

    final configu = SerialPortConfig();
    configu.baudRate = 57600;
    configu.parity = // NONE ;
        SerialPortParity.none;
    configu.stopBits = 1;
    configu.bits = 8;
    port?.config = configu;
    SerialPortReader reader = SerialPortReader(port!, timeout: 500);

    try {
      port!.openReadWrite();
      print("açıldı");
      reader.stream.listen((data) {
        print('received : $data');
        print(String.fromCharCodes(data));

        // split data with ; then set values
        try {
          List<String> datas = String.fromCharCodes(data).split(';');

          context.read<ControlPanelProvider>().setZamanDegeri(datas[0]);
          context.read<ControlPanelProvider>().setHizDegeri(datas[1]);
          context.read<ControlPanelProvider>().setBataryaSicakligi(datas[2]);
          context.read<ControlPanelProvider>().setBataryaGerilimi(datas[3]);
          context.read<ControlPanelProvider>().setKalanEnerji(datas[4]);
        } on Exception catch (e) {
          // TODO
          print(e);
        }

        //! DATADAN VERİLERİ ÇEK VE İŞLE
        sink?.write('${String.fromCharCodes(data)}\n');
        sink?.flush();
      });
    } on SerialPortError catch (_, err) {
      if (port!.isOpen) {
        // port.close();
        print('serial port error');
      }

      print(err);
    }
  }
}
