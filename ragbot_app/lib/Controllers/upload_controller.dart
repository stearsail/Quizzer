import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UploaderViewController extends ChangeNotifier {
  bool _fileUploaded = false;
  bool get fileUploaded => _fileUploaded;
  set fileUploaded(bool fileUploaded) {
    _fileUploaded = fileUploaded;
    notifyListeners();
  }
  String? uploadedFilePath = '';
  final String _uri = "http://0.0.0.0:8000";

  void uploadFile() async {
    try {
      //select file to upload
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          dialogTitle: "Select .pdf file",
          allowMultiple: false,
          allowedExtensions: ['pdf'],
          lockParentWindow: false);
      if (result != null) {
        uploadedFilePath = result.files.first.path;
        await _uploadFileToServer();
      }
    } catch (ex) {}
  }

  Future<void> _uploadFileToServer() async {
    
      //upload file to fastapi endpoint
      //define uri and multipart request
      Uri uploadUri = Uri.parse('$_uri/upload-pdf');
      MultipartRequest request = MultipartRequest('POST', uploadUri);
      
      //attach file to request {'filename' : '<the path>'}
      request.files.add(await MultipartFile.fromPath('filename', uploadedFilePath!));

      //send request
      StreamedResponse response = await request.send();

      if(response.statusCode == 200){
        //is successful
        fileUploaded = true;
      }else{
        //temporar
        fileUploaded = true;
        uploadedFilePath = "error";
      }
    
  }
}
