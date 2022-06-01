import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/layout/_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataTableFormat extends StatelessWidget {
  const DataTableFormat({
    Key? key,
    required this.columns,
    required this.columnsMobile,
    required this.rows,
    required this.rowsMobile,
  }) : super(key: key);
  final List<DataColumn> columns;
  final List<DataColumn> columnsMobile;
  final List<DataRow> rows;
  final List<DataRow> rowsMobile;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      dataRowColor: MaterialStateColor.resolveWith((states) => whiteColor),
      minWidth: kIsWeb && Get.width >= 600 ? 1200 : Get.width,
      showBottomBorder: true,
      dataTextStyle: robotoRegular,
      headingRowColor: MaterialStateColor.resolveWith((states) => maroonColor),
      headingTextStyle: robotoMedium.copyWith(color: whiteColor),
      headingRowHeight: kIsWeb ? 35 : 50,
      horizontalMargin: 10,
      columns: kIsWeb && Get.width >= 600 ? columns : columnsMobile,
      rows: kIsWeb && Get.width >= 600 ? rows : rowsMobile,
    );
  }
}
