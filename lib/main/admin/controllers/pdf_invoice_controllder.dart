import 'package:bidding/models/bid_model.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/logger_service.dart';

class PdfInvoiceController extends GetxController {
  final log = getLogger('Invoice Controller');

  final RxList<Bid> itemInvoice = RxList.empty(growable: true);
  final RxBool isDoneLoading = false.obs;
  @override
  void onInit() {
    itemInvoice.bindStream(getItemInvoice());
    Future.delayed(const Duration(seconds: 3), () {
      isDoneLoading.value = true;
    });
    super.onInit();
  }

  Stream<List<Bid>> getItemInvoice() {
    log.i('Streaming item invoice');
    return firestore
        .collection('bids')
        .snapshots(includeMetadataChanges: true)
        .map((query) {
      return query.docs.map((item) {
        return Bid.fromJson(item.data());
      }).toList();
    });
  }
}
