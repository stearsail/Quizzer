import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UploaderView extends StatefulWidget {
  const UploaderView({super.key});

  @override
  State<UploaderView> createState() => _UploaderViewState();
}

class _UploaderViewState extends State<UploaderView> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {},
        icon: const Icon(
          Icons.upload_file,
          size: 30,
        ),
        label: const Text(
          'Select file',
          style: TextStyle(fontSize: 20),
        ),
      )),
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButton: const SizedBox(
        height: 70.0,
        width: 70.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: null,
            tooltip: 'Upload a new PDF!',
            child: Icon(
              Icons.arrow_back,
              size: 28,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
