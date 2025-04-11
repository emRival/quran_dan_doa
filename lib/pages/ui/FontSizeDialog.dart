import 'package:flutter/material.dart';

class FontSizeDialog extends StatefulWidget {
  final double initialFontSize;
  final ValueChanged<double> onFontSizeChanged;

  const FontSizeDialog({
    Key? key,
    required this.initialFontSize,
    required this.onFontSizeChanged,
  }) : super(key: key);

  @override
  _FontSizeDialogState createState() => _FontSizeDialogState();
}

class _FontSizeDialogState extends State<FontSizeDialog> {
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Font Size: $_fontSize'),
          SizedBox(height: 16.0),
          Row(
            children: [
              const Icon(
                Icons.format_size,
                size: 18, // Ukuran ikon kecil
              ),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 16.0,
                  max: 30.0,
                  divisions: 100,
                  label: _fontSize.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _fontSize = value;
                      widget.onFontSizeChanged(_fontSize);
                    });
                  },
                ),
              ),
              const Icon(
                Icons.format_size,
                size: 25, // Ukuran ikon besar
              ),
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              widget.onFontSizeChanged(_fontSize);
              Navigator.pop(
                  context); // Tutup modal bottom sheet saat tombol ditekan
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}
