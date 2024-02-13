import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class CsvReaderView extends StatefulWidget {
  String csvPath;
  CsvReaderView({super.key, required this.csvPath});

  @override
  State<CsvReaderView> createState() => _CsvReaderViewState();
}

class _CsvReaderViewState extends State<CsvReaderView> {
  List<List<dynamic>> _data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar for back
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // CSV READER GIVEN PATH
      body: SafeArea(
        child: Center(
          child: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_data[index].join(", ")),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    // final csvData = await rootBundle.loadString(widget.csvPath);
    // List<List<dynamic>> csvTable =
    //     const CsvToListConverter().convert(widget.csvPath);
    // setState(() {
    //   _data = csvTable;
    // });

    final input = File(widget.csvPath).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    setState(() {
      _data = fields;
    });
  }
}
