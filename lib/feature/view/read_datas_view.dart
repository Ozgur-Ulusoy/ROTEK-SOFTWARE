import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotak_arac/core/providers/main_provider.dart';
import 'package:rotak_arac/feature/controllers/file_controller.dart';
import 'package:rotak_arac/feature/view/csv_reader_view.dart';

class ReadDatasView extends StatefulWidget {
  const ReadDatasView({super.key});

  @override
  State<ReadDatasView> createState() => _ReadDatasViewState();
}

class _ReadDatasViewState extends State<ReadDatasView> {
  bool isLoaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const Text("Geri Dön"),
              ],
            ),
          ),
          Expanded(
            child: Consumer<MainProvider>(
              builder: (context, value, child) => !isLoaded
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : value.fileNames.isEmpty
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
                              },
                            );
                          },
                        ),
            ),
          ),
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
      setDatas();
    });
  }

  Future setDatas() async {
    await FileController().getDatasFolderContent().then(
      (value) {
        print(value);
        Provider.of<MainProvider>(context, listen: false).setFileNames(value);

        setState(() {
          isLoaded = true;
        });
      },
    );
  }
}
