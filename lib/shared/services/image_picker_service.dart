import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/services/logger_service.dart';

class ImagePickerService {
  final log = getLogger('Image Picker Service');

  Future<void> pickImage(RxString image) async {
    log.i('pickImage called');
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image.value = pickedImage.path;
    }
  }

  Future<XFile?> pickImageOnWeb(RxString path) async {
    log.i('pickImage on web called');
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      path.value = pickedImage.path;
      return pickedImage;
    }
    return null;
  }

  Future<void> pickMultiImage(RxList<XFile> images) async {
    log.i('pickMultiImage called here | limits 10 images');
    final pickedFileList = await ImagePicker().pickMultiImage();
    if (pickedFileList != null) {
      if (pickedFileList.length > 10) {
        final newList = List<XFile>.from(pickedFileList.getRange(0, 10));
        images.value = newList;
      } else {
        images.value = pickedFileList;
      }
    }
  }
}
