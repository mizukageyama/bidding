import 'dart:io';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Upload {
  static Future<String> photoToWeb({
    required XFile image,
    required String saveAs,
  }) async {
    String downloadUrl = '';
    final fileBytes = image.readAsBytes();
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': image.path});
    final ref = storageRef.child(saveAs);
    final uploadTask = ref.putData(await fileBytes, metadata);
    await uploadTask.then((res) async {
      downloadUrl = await res.ref.getDownloadURL();
    });
    return downloadUrl;
  }

  static Future<String> photo({
    required String filePathID,
    required String saveAs,
  }) async {
    String downloadUrl = '';
    final ref = storageRef.child(saveAs);
    final uploadTask = ref.putFile(File(filePathID));
    await uploadTask.then((res) async {
      downloadUrl = await res.ref.getDownloadURL();
    });
    return downloadUrl;
  }

  static Future<List<String>> multiImage({
    required List<XFile> images,
    required String saveAs,
  }) async {
    List<String> imagesDownloadUrl = List.empty(growable: true);
    for (var i = 0; i < images.length; i++) {
      final ref = storageRef.child('$saveAs/Image-$i');
      await ref.putFile(File(images[i].path)).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imagesDownloadUrl.add(value);
        });
      });
    }
    return imagesDownloadUrl;
  }

  static Future<List<String>> multiImageWeb({
    required List<XFile> images,
    required String saveAs,
  }) async {
    List<String> imagesDownloadUrl = List.empty(growable: true);
    for (var i = 0; i < images.length; i++) {
      final fileBytes = images[i].readAsBytes();
      final ref = storageRef.child('$saveAs/Image-$i');
      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': images[i].path});
      await ref.putData(await fileBytes, metadata).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imagesDownloadUrl.add(value);
        });
      });
    }

    return imagesDownloadUrl;
  }
}
