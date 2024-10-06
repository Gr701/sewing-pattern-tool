import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:pdf/pdf.dart';

//DRAWING IMAGE TO SCREEN
class ImagePainter extends CustomPainter 
{
    final ui.Image image;

    const ImagePainter(this.image);

    @override
    void paint(Canvas canvas, Size size) 
    {
        final paint = Paint();

        canvas.drawImage(image, Offset.zero, paint);
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) => true;
}

//BLACK COLOR
Map<int, Color> color = 
{
    50: const ui.Color.fromRGBO(255, 0, 0, 0),
    100: const ui.Color.fromRGBO(255, 0, 0, 0),
    200: const ui.Color.fromRGBO(255, 0, 0, 0),
    300: const ui.Color.fromRGBO(255, 0, 0, 0),
    400: const ui.Color.fromARGB(255, 0, 0, 0),
    500: const ui.Color.fromRGBO(255, 0, 0, 0),
    600: const ui.Color.fromRGBO(255, 0, 0, 0),
    700: const ui.Color.fromRGBO(255, 0, 0, 0),
    800: const ui.Color.fromRGBO(255, 0, 0, 0),
    900: const ui.Color.fromARGB(255, 0, 0, 0),
};

MaterialColor black = MaterialColor(0xFF000000, color);

//CREATING PDF WITH images
Future<bool> createPDF(List<Uint8List> images) async 
{
    var pdf = pw.Document();

    String? path = await FilePicker.platform.saveFile(dialogTitle: 'Save file', fileName: 'pattern.pdf', allowedExtensions: ['pdf']);

    if (path == null)
    {
        print('Path null');
        return false;
    }
    else
    {
        List<String> pathSplitted = path.split('.');
        path = '${pathSplitted[0]}.pdf';

        //File(path).deleteSync();
    
        File file = File(path);
        
        for (int i = 0; i < images.length; i++) 
        {
            var assetImage = pw.MemoryImage(images[i]);

            pdf.addPage
            (
                pw.Page
                (
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) 
                    {
                        return pw.FullPage(ignoreMargins: true, child: pw.Image(assetImage));
                    },
                )
            );
        }
        await file.writeAsBytes(await pdf.save());
        return true;
    }
}




