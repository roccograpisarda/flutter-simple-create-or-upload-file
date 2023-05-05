import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upload_or_create_file_example/components/setting_page.dart';

late String tempDir;


class UtilFunctions {
  static AwesomeDialog showDialog(context, String message, String type) {
    String title = "Attention!";
    DialogType dialogType = DialogType.warning;
    if (type == "success") {
      title = "Success!";
      dialogType = DialogType.success;
    }
    return AwesomeDialog(
        context: context,
        dialogType: dialogType,
        title: title,
        desc: message,
        headerAnimationLoop: false,
        btnOkOnPress: () {
          if (type == "success") {
            goBack(context);
          }
        })
      ..show();
  }

  static Future<bool> prepareStorage() async {
    bool gotPermissions = false;

    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;

    if (Platform.isAndroid) {
      var storage = await Permission.storage.status;

      if (storage != PermissionStatus.granted) {
        await Permission.storage.request();
      }

      storage = await Permission.storage.status;

      if (storage == PermissionStatus.granted) {
        gotPermissions = true;
      }

      if (sdkInt >= 30) {
        var storageExternal = await Permission.manageExternalStorage.status;

        if (storageExternal != PermissionStatus.granted) {
          await Permission.manageExternalStorage.request();
        }
        storageExternal = await Permission.manageExternalStorage.status;

        if (storageExternal == PermissionStatus.granted ||
            storage == PermissionStatus.granted) {
          gotPermissions = true;
        }
      }
    }

    return gotPermissions;
  }

  static Future<void> getFile(BuildContext context, String fileExtension) async {
    bool hasPermission = await prepareStorage();
    if (!hasPermission) {
      return;
    }
    else if(context.mounted){
      await FilesystemPicker.open(
        title: "Select file",
        context: context,
        rootDirectory: Directory('/storage/emulated/0/'),
        fsType: FilesystemType.file,
        allowedExtensions: [fileExtension],
        fileTileSelectMode: FileTileSelectMode.wholeTile,
        folderIconColor: Theme.of(context).primaryColor,
        requestPermission: () async => await prepareStorage(),
      ).then((value) {
        if (value != null) {
          tempDir = value.toString();
          storeSelectedFilePath(tempDir);
          showDialog(context, "File uploaded correctly!", "success");
        } else {
          showDialog(context, "No file selected!", "alert");
        }
      });
    }


  }

  static Future<bool> createFile(String pathToSave, String fileName, String fileExtension) async {
    bool hasPermission = await prepareStorage();
    if (!hasPermission) {
      return false;
    }

    File file = File("$pathToSave/$fileName.$fileExtension");
    await file.writeAsString("");
    storeSelectedFilePath(file.path);
    return true;
  }

  static void showFileCreatedSnackBar(ScaffoldMessengerState scaffoldMessenger) {
    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('File created')),
    );
  }

  static void storeSelectedFilePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (path != "") {
      await prefs.setString("file_path", path);
    } else {
      await prefs.remove("file_path");
    }
  }


  static goBack(context) async {
    Navigator.pop(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

}