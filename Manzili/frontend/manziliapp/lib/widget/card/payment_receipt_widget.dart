import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PaymentReceipt extends StatefulWidget {
  const PaymentReceipt({super.key});

  @override
  State<PaymentReceipt> createState() => _PaymentReceiptState();
}

class _PaymentReceiptState extends State<PaymentReceipt> {
  PlatformFile? pickedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  void _removeFile() {
    setState(() {
      pickedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pickedFile != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                weight: 16,
              ),
              onPressed: _removeFile,
            ),
            Expanded(
              child: Text(
                pickedFile!.name,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickFile,
          child: Image.asset(
            'assets/image/Upload icon.png',
            width: 80,
            height: 80,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: _pickFile,
              child: const Text(
                'Browse',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'Drag & drop files or',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Supported formats: JPEG, PNG, GIF, MP4, PDF, PSD, AI, Word, PPT',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
