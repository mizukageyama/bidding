import 'dart:io';
import 'dart:typed_data';
import 'package:bidding/components/pdf_open.dart';
import 'package:bidding/models/bid_model.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;

class PdfService {
  static Future<File> generate({
    required SoldItem item,
    required List<Bid> bids,
  }) async {
    final pdf = Document();

    final image = await itemImage(item.images[0]);
    for (final bidItem in bids) {
      await bidItem.getBidderInfo();
    }

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        buildTitle(),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image(image),
            ),
            SizedBox(width: 20),
            Expanded(flex: 2, child: buildHeader(item)),
          ],
        ),
        Divider(),
        buildBidTable(bids),
      ],
    ));
    return PdfApi.saveDocument(name: '${item.itemId}.pdf', pdf: pdf);
  }

  static Future<void> generateWeb({
    required SoldItem item,
    required List<Bid> bids,
  }) async {
    final pdf = Document();

    final image = await itemImage(item.images[0]);
    for (final bidItem in bids) {
      await bidItem.getBidderInfo();
    }

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        buildTitle(),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Image(image),
            ),
            SizedBox(width: 20),
            Expanded(flex: 2, child: buildHeader(item)),
          ],
        ),
        Divider(),
        buildBidTable(bids),
      ],
    ));

    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "url");
    html.Url.revokeObjectUrl(url);
  }

  static Future<ImageProvider> itemImage(String imgUrl) async {
    if (imgUrl == '') {
      return await imageFromAssetBundle(
        'assets/images/default_image.png',
      );
    } else {
      return await networkImage(imgUrl);
    }
  }

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Auctioned Item Report',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('Report Date: ${Format.dateTime(DateTime.now())}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          SizedBox(height: 0.7 * PdfPageFormat.cm),
        ],
      );

  static Widget buildHeader(
    SoldItem item,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            item.title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: PdfColors.red900),
          ),
        ]),
        SizedBox(height: 18),
        Text(
          'Item #',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: PdfColors.black),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          item.itemId,
          style: const TextStyle(fontSize: 16, color: PdfColors.grey600),
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Seller',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          item.sellerInfo!.fullName,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 35,
        ),
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Asking Price',
                style: const TextStyle(fontSize: 18, color: PdfColors.black)),
            Text(
              'Php ${Format.amount(item.askingPrice)}',
              style: const TextStyle(fontSize: 16, color: PdfColors.grey600),
              textAlign: TextAlign.left,
            )
          ]),
          SizedBox(width: 25),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bought At',
                style: const TextStyle(fontSize: 18, color: PdfColors.black)),
            Text('Php ${Format.amount(item.soldAt)}',
                style:
                    const TextStyle(fontSize: 16, color: PdfColors.orange900),
                textAlign: TextAlign.left),
          ]),
        ]),
        SizedBox(
          height: 20,
        ),
        Wrap(
          runSpacing: 5,
          children: [
            Text('Posted:',
                style: const TextStyle(fontSize: 16, color: PdfColors.grey600)),
            SizedBox(
              width: 5,
            ),
            Text(
              Format.date(item.datePosted),
              style: const TextStyle(fontSize: 16, color: PdfColors.grey600),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          runSpacing: 5,
          children: [
            Text('Closed:',
                style: const TextStyle(fontSize: 16, color: PdfColors.grey600)),
            SizedBox(
              width: 5,
            ),
            Text(Format.date(item.endDate),
                style: const TextStyle(fontSize: 16, color: PdfColors.grey600))
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  static Widget buildBidTable(List<Bid> bids) {
    if (bids.isEmpty) {
      return Column(
        children: [
          SizedBox(height: 25),
          Text(
            'Item has no bids',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      );
    }

    final column = [
      'Bidder',
      'Amount',
      'Bid Date',
    ];

    final data = bids.map((invoice) {
      return [
        invoice.bidderInfo?.fullName,
        Format.amountShort(invoice.amount),
        Format.dateShort(invoice.bidDate),
      ];
    }).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 25),
      Text('Item Bids',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      SizedBox(height: 15),
      Table.fromTextArray(
        headers: column,
        data: data,
        border: null,
        cellPadding: const EdgeInsets.all(5),
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        tableWidth: TableWidth.max,
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerLeft,
          2: Alignment.centerLeft,
        },
      )
    ]);
  }
}
