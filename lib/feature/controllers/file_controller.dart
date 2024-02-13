import 'dart:io';

class FileController {
  
  Future<File> createFile({String? fileName}) async {
    // String datetime = DateTime.now().toString();
    final file =
        await File(fileName ?? DateTime.now().toString().replaceAll(':', '-'))
            .create();
    return file;
  }

  // GET LENGTH OF datas FOLDER content and return it
  Future<List<String>> getDatasFolderContent() async {
    final directory = Directory('datas');
    final files = directory.listSync();
    List<String> fileNames = [];
    for (var file in files) {
      fileNames.add(file.path);
    }
    return fileNames;
  }

}
