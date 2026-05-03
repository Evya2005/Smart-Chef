import 'package:flutter/material.dart';

enum InputSource { text, image, pdf, url }

class InputSourcePicker extends StatelessWidget {
  const InputSourcePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final InputSource selected;
  final ValueChanged<InputSource> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<InputSource>(
      segments: const [
        ButtonSegment(
          value: InputSource.text,
          icon: Icon(Icons.text_snippet_outlined),
          label: Text('טקסט'),
        ),
        ButtonSegment(
          value: InputSource.image,
          icon: Icon(Icons.image_outlined),
          label: Text('תמונה'),
        ),
        ButtonSegment(
          value: InputSource.pdf,
          icon: Icon(Icons.picture_as_pdf_outlined),
          label: Text('PDF'),
        ),
        ButtonSegment(
          value: InputSource.url,
          icon: Icon(Icons.link),
          label: Text('קישור'),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
