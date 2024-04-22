import 'package:flutter/material.dart';
import 'package:ragbot_app/Controllers/upload_controller.dart';

class UploadFileWidget extends StatefulWidget {
  final UploaderViewController uploaderViewController;

  const UploadFileWidget({super.key, required this.uploaderViewController});

  @override
  State<StatefulWidget> createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.vertical,
      children: [
        SizedBox(
          width: 350,
          height: 100,
          child: TextField(
            cursorColor: const Color(0xFF6738FF),
            controller: widget.uploaderViewController.titleInputController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                errorText: widget.uploaderViewController.textErrorMessage,
                errorStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 238, 90)),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 250, 194, 72),
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 250, 194, 72), width: 2.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "A title for your new test",
                prefixIcon: const Icon(Icons.short_text),
                filled: true,
                fillColor: const Color(0xFFF3F6F4),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: SizedBox(
            height: 85,
            child: FittedBox(
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return const Color(0xFF5DC461);
                    }),
                    shadowColor: const MaterialStatePropertyAll(
                        Color.fromARGB(255, 43, 90, 53)),
                    elevation: const MaterialStatePropertyAll(5)),
                onPressed: widget.uploaderViewController.isButtonEnabled == true
                    ? () => widget.uploaderViewController.uploadFile()
                    : null,
                label: const Text("Upload file"),
                icon: const Icon(Icons.upload),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Text(
            "Set a title and upload a PDF file to begin processing and generate your quiz!",
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
