import "dart:io";

import "package:filesystem_picker/filesystem_picker.dart";
import "package:flutter/material.dart";
import "package:upload_or_create_file_example/utilfunctions.dart";

class CreateFilePage extends StatefulWidget {
  const CreateFilePage({super.key});

  @override
  State<CreateFilePage> createState() => _CreateFilePageState();
}

class _CreateFilePageState extends State<CreateFilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fileNameController = TextEditingController();
  final _filePathController = TextEditingController();
  final _fileExtensionController = TextEditingController();

  Future<void> _selectDirectory() async {
    String? filePath = await FilesystemPicker.open(
      title: "Save to folder",
      context: context,
      rootDirectory: Directory("/storage/emulated/0/"),
      fsType: FilesystemType.folder,
      pickText: "Save file to this folder",
    );
    if (filePath != null) {
      setState(() {
        _filePathController.text = filePath;
      });
    }
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    _filePathController.dispose();
    _fileExtensionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      UtilFunctions.createFile(_filePathController.text,
          _fileNameController.text, _fileExtensionController.text);
      UtilFunctions.showFileCreatedSnackBar(ScaffoldMessenger.of(context));
      UtilFunctions.goBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new File"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fileNameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fileExtensionController,
                      decoration: InputDecoration(
                        labelText: "extension",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _filePathController,
                decoration: InputDecoration(
                  labelText: "Select a directory",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                onTap: () {
                  _selectDirectory();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please select a directory";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                onPressed: _submitForm,
                child: const Text("Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
