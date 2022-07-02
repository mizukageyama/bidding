import 'dart:io';
import 'package:bidding/components/pdf_open.dart';
import 'package:bidding/main/admin/controllers/pdf_invoice_controllder.dart';
import 'package:bidding/models/sold_item.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/services/format.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../models/_models.dart';

class PdfInvoice {
  static Future<File> generate(List<Bid> invoice, SoldItem item) async {
    final pdf = pw.Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(),
        SizedBox(height: 10),
        buildHeader(item),
        Divider(),
        SizedBox(height: 25),
        Text('Item Bids',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        SizedBox(height: 15),
        buildInvoice(invoice, item),
      ],
    ));

    return PdfApi.saveDocument(name: 'Invoice.pdf', pdf: pdf);
  }

  //pdf title
  static Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Auction Item Report',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('Report Date: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          SizedBox(height: 0.7 * PdfPageFormat.cm),
        ],
      );

  //header pdf
  static Widget buildHeader(SoldItem item) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              item.itemId, //Title
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
            height: 10,
          ),
          Text(
            'Test Test', //seller
            style: const TextStyle(fontSize: 16, color: PdfColors.grey600),
            textAlign: TextAlign.justify,
          ),
          // Text(
          //   item.sellerInfo!.fullName,
          //   style: const TextStyle(fontSize: kIsWeb ? 13 : 16),
          //   textAlign: TextAlign.justify,
          // ),
          SizedBox(
            height: 35,
          ),
          Row(children: [
            Column(children: [
              Text('Asking Price',
                  style: const TextStyle(fontSize: 18, color: PdfColors.black)),
              Text('₱ ${Format.amount(item.askingPrice)}',
                  style:
                      const TextStyle(fontSize: 16, color: PdfColors.grey600),
                  textAlign: TextAlign.left)
            ]),
            SizedBox(width: 25),
            Column(children: [
              Text('Bought At',
                  style: const TextStyle(fontSize: 18, color: PdfColors.black)),
              Text('₱ ${Format.amount(item.soldAt)}',
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
                  style:
                      const TextStyle(fontSize: 16, color: PdfColors.grey600)),
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
                  style:
                      const TextStyle(fontSize: 16, color: PdfColors.grey600)),
              SizedBox(
                width: 5,
              ),
              Text(Format.date(item.endDate),
                  style:
                      const TextStyle(fontSize: 16, color: PdfColors.grey600))
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      );

  //pdf database info
  static Widget buildInvoice(List<Bid> invoice, SoldItem item) {
    // final PdfInvoiceController pdfInvoiceController =
    //     Get.put(PdfInvoiceController());

    final headers = [
      'Bidder',
      'Amount',
      'Bid Date',
      'Status',
    ];

    final data = invoice.map((invoice) {
      invoice.getBidderInfo();
      return [
        invoice.bidderInfo!.fullName,
        Format.amountShort(invoice.amount),
        Format.dateShort(invoice.bidDate),
        invoice.isApproved, //status
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
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
        3: Alignment.centerLeft,
      },
    );
  }

  // static Future<pw.Widget> getDate() async {

  //   DateTime? selected = await showDatePicker(
  //                       context: context,
  //                       initialDate: boughtItems.selectedDate.value,
  //                       firstDate: DateTime(2010),
  //                       lastDate: DateTime(2025),
  //                     );
  //                     if (selected != null) {
  //                       boughtItems.date.value =
  //                           DateFormat.yMMMd().format(selected);
  //                     }

  // }
}
