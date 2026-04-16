import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/logger.dart';

class PdfProcessorService {
  const PdfProcessorService();

  Future<String> extractText(Uint8List pdfBytes) async {
    PdfDocument? document;
    try {
      document = PdfDocument(inputBytes: pdfBytes);
      final extractor = PdfTextExtractor(document);
      final buffer = StringBuffer();

      for (var i = 0; i < document.pages.count; i++) {
        final pageText = extractor.extractText(startPageIndex: i, endPageIndex: i);
        buffer.writeln(pageText);
      }

      final result = buffer.toString().trim();
      AppLogger.d('Extracted ${result.length} chars from PDF');
      return result;
    } catch (e, st) {
      AppLogger.e('PDF extraction failed', e, st);
      throw IngestionException('Failed to extract PDF text.', e);
    } finally {
      document?.dispose();
    }
  }
}
