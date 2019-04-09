import 'dart:async';
import 'package:permission/permission.dart';

Future<void> queryPermissions() async {
  List<PermissionName> perms = [PermissionName.Storage];

  while (true) {
    List<Permissions> permissionsStatus =
        await Permission.getPermissionsStatus(perms);

    bool allGranted = permissionsStatus.every(
        (Permissions perm) => perm.permissionStatus == PermissionStatus.allow);

    if (!allGranted) {
      await Permission.requestPermissions(perms);
    } else {
      break;
    }
  }
}
