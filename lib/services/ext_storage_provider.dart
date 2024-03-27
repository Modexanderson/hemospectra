import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExtStorageProvider {
  // asking for permission
  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      final result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<String?> getExtStorage({required String dirName}) async {
    Directory? directory;

    try {
      // checking platform
      if (Platform.isAndroid) {
        if (await requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();

          // getting main path
          final String newPath = directory!.path
              .replaceFirst('Android/data/com.imagen.android/files', dirName);

          directory = Directory(newPath);

          if (!await directory.exists()) {
            await requestPermission(Permission.manageExternalStorage);
            //creating folder

            await directory.create(recursive: true);
          }
          if (await directory.exists()) {
            try {
              // if directory exists then returning the complete path
              return newPath;
            } catch (e) {
              rethrow;
            }
          }
        } else {
          return throw 'something went wrong';
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        return directory.path;
      } else {
        directory = await getDownloadsDirectory();
        return directory!.path;
      }
    } catch (e) {
      rethrow;
    }
    return directory.path;
  }
}
