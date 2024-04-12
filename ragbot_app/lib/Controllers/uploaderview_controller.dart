import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploaderViewController extends ChangeNotifier {
  void uploadFile() async {
    try {
      //select file to upload
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          dialogTitle: "Select .pdf file",
          allowMultiple: false,
          allowedExtensions: ['pdf'],
          withData: true,
          lockParentWindow: false);
      if (result != null) {
        String filename = result.files.first.name;
        await _uploadFileToServer(result.files.first.bytes);
      }
    } catch (ex) {}
  }

  Future<void> _uploadFileToServer(Uint8List? bytes) async {
    try {
      //upload file to fastapi endpoint
    } catch (ex) {}
  }
}
