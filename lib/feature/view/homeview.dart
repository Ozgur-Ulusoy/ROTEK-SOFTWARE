import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:provider/provider.dart';
import 'package:rotak_arac/core/providers/main_provider.dart';
import 'package:rotak_arac/feature/controllers/file_controller.dart';
import 'package:rotak_arac/feature/view/csv_reader_view.dart';

// class CardListTile extends StatelessWidget {
//   final String name;
//   final String? value;

//   const CardListTile(this.name, this.value, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(value ?? 'N/A'),
//         subtitle: Text(name),
//       ),
//     );
//   }
// }

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? file;
  IOSink? sink;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Expanded(
            //   child: ListView(
            //     shrinkWrap: true,
            //     children: [
            //       for (final address in availablePorts)
            //         Builder(builder: (context) {
            //           final port = SerialPort(address);
            //           return ExpansionTile(
            //             title: Text(address),
            //             children: [
            //               // CardListTile('Description', port.description),
            //               // CardListTile(
            //               //     'Transport', port.transport.toTransport()),
            //               // CardListTile('USB Bus', port.busNumber?.toPadded()),
            //               // CardListTile(
            //               //     'USB Device', port.deviceNumber?.toPadded()),
            //               // CardListTile('Vendor ID', port.vendorId?.toHex()),
            //               // CardListTile('Product ID', port.productId?.toHex()),
            //               // CardListTile('Manufacturer', port.manufacturer),
            //               // CardListTile('Product Name', port.productName),
            //               // CardListTile('Serial Number', port.serialNumber),
            //               // CardListTile('MAC Address', port.macAddress),
            //             ],
            //           );
            //         }),
            //     ],
            //   ),
            // ),

            // Button click for sa function
            // ElevatedButton(
            //   onPressed: () {
            //     portReadingStream();
            //   },
            //   child: const Text('Click'),
            // ),

            //

            // portcontroller.isportsempty return dislike icon
            // portcontroller.getavailableports return list of ports

            // PortController().isPortsEmpty()
            //     ? const Icon(Icons.error)
            //     : ListView.builder(
            //         itemCount: PortController().getAvailablePorts().length,
            //         itemBuilder: (context, index) {
            //           return ListTile(
            //             title:
            //                 Text(PortController().getAvailablePorts()[index]),
            //           );
            //         },
            //       ),

            // filecontroller.isfilesempty return dislike icon
            // filecontroller.getfilenames return list of file names
            Expanded(
              child: Consumer<MainProvider>(
                builder: (context, value, child) => value.fileNames.isEmpty
                    ? const Icon(Icons.error)
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.fileNames.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              title: Text(
                                // value.fileNames[index] but after datas/
                                value.fileNames[index].substring(6),
                              ),
                              onTap: () {
                                // OPEN CSV READER
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CsvReaderView(
                                      csvPath: value.fileNames[index],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
              ),
            ),
          ],
        ),
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
    });
  }

  Future portReadingStream() async {
    Provider.of<MainProvider>(context, listen: false)
        .setAvailablePorts(SerialPort.availablePorts);

    // CREATE A CSV FILE WITH NAME DATETIME AND WRITE DATA TO IT
    String datetime = DateTime.now().toString();
    datetime = datetime.replaceAll(':', '-');
    try {
      file = await File('datas/$datetime.csv').create().then((value) async {
        sink = value.openWrite();
        sink?.write('datetime,temperature,humidity\n');
        sink?.write('2021-01-01 00:00:00,20,50\n');
        await sink?.flush();
        // await sink.close();
        return null;
      });
    } catch (e) {
      print(e);
    }

    FileController().getDatasFolderContent().then((value) {
      print(value);
      Provider.of<MainProvider>(context, listen: false).setFileNames(value);
    });

    if (context.read<MainProvider>().availablePorts.isEmpty) {
      print("No serial ports available");
      return;
    } else {
      print(context.read<MainProvider>().availablePorts.first);
    }

    SerialPort port = SerialPort('COM4');

    if (port.isOpen) {
      port.close();
    }

    final configu = SerialPortConfig();
    configu.baudRate = 57600;
    configu.parity = // NONE ;
        SerialPortParity.none;
    configu.stopBits = 1;
    configu.bits = 8;
    port.config = configu;
    SerialPortReader reader = SerialPortReader(port, timeout: 10);

    try {
      port.openReadWrite();
      reader.stream.listen((data) {
        print('received : $data');
        print(String.fromCharCodes(data));
        //! DATADAN VERİLERİ ÇEK VE İŞLE
        sink?.write('${String.fromCharCodes(data)}\n');
        sink?.flush();
      });
    } on SerialPortError catch (_, err) {
      if (port.isOpen) {
        // port.close();
        print('serial port error');
      }

      print(err);
    }
  }
}
