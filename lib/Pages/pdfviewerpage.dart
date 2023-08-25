import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({super.key, required this.file});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDF VIEW",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: PDFView(
        fitEachPage: true,
        //  nightMode: true,
        // swipeHorizontal: true,
        filePath: widget.file.path,
      ),
    );
  }
}
