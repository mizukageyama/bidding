import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/services/_services.dart';

class AttachedPhotosController extends GetxController {
  final log = getLogger('Attached Photos Controller');

  final crslController = CarouselController();
  final List<String> fetchedImages = List.empty(growable: true);
  RxInt selectedIndex = 0.obs;

  void init(List<String> images) {
    selectedIndex.value = 0;
    fetchedImages.clear();
    fetchedImages.addAll(images);
  }

  void animateToSlide(int index) => crslController.animateToPage(index);

  void nextPhoto() => crslController.nextPage();

  void prevPhoto() => crslController.previousPage();
}
