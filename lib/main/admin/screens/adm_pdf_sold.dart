import 'dart:io';
import 'dart:typed_data';
import 'package:bidding/components/pdf_open.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:universal_html/html.dart' as html;

class AdminSoldPdf {
  static Future<File> generate(List<SoldItem> items) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(),
        buildInvoice(items),
        Divider(),
        buildTotal(items),
      ],
    ));
    //count
    return PdfApi.saveDocument(name: 'Sold Item Report.pdf', pdf: pdf);
  }

//webpdf version
  static Future<void> generateWeb({
    required List<SoldItem> items,
  }) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(),
        SizedBox(height: 20),
        Divider(),
        buildInvoice(items),
        Divider(),
        buildTotal(items),
      ],
    ));

    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "url");
    html.Url.revokeObjectUrl(url);
  }

  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sold Auctions Report',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('Report Date: ${Format.dateTime(DateTime.now())}',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal)),
        ],
      );

  static Widget buildInvoice(List<SoldItem> invoice) {
    final headers = [
      'Items',
      'Date Sold',
      'Seller',
      'Asking Price',
      'Sold At',
      'Winner'
    ];
    final data = invoice.map((item) {
      return [
        item.title,
        Format.date(
          item.dateSold,
        ),
        item.sellerInfo!.fullName,
        'Php ${item.askingPrice}',
        'Php ${item.soldAt}',
        item.buyerName,
      ];
    }).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 15),
      Text('Items Sold',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      SizedBox(height: 15),
      Table.fromTextArray(
        headers: headers,
        headerAlignment: Alignment.centerLeft,
        data: data,
        border: null,
        cellPadding: const EdgeInsets.all(5),
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: const BoxDecoration(color: PdfColors.grey300),
        cellHeight: 28,
        columnWidths: {
          0: const FlexColumnWidth(1.8),
          1: const FlexColumnWidth(1.5),
          2: const FlexColumnWidth(1),
          3: const FlexColumnWidth(1),
          4: const FlexColumnWidth(1),
          5: const FlexColumnWidth(1),
        },
      ),
    ]);
  }

  //Net Total
  static Widget buildTotal(List<SoldItem> invoice) {
    final totalSoldItem = invoice
        .map((item) => item.soldAt)
        .reduce((item1, item2) => item1 + item2);
    final netTotal = totalSoldItem;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(children: [
        Spacer(flex: 6),
        Expanded(
            flex: 4,
            child: Column(children: [
              buildText(
                title: 'Net Total',
                value: Format.amountShort(netTotal),
              ),
              SizedBox(height: 2 * PdfPageFormat.mm),
              Container(height: 1, color: PdfColors.grey400),
              SizedBox(height: 0.5 * PdfPageFormat.mm),
              Container(height: 1, color: PdfColors.grey400),
            ]))
      ]),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
