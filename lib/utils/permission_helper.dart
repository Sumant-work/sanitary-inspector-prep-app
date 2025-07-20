import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isGranted) return true;

    final status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestMediaPermission() async {
    if (await Permission.photos.isGranted) return true;

    final status = await Permission.photos.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> checkAllPermissions() async {
    bool storage = await requestStoragePermission();
    bool media = await requestMediaPermission();
    return storage || media;
  }
}
