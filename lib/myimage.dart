// ignore_for_file: avoid_print
import 'drawingBMP.dart';

class Point 
{
    int x;
    int y;
    Point(this.x, this.y);
}

class ImageBMP 
{
    int width;
    int height;
    late List<int> imageInt;
    int paddingAmount = 0;

    ImageBMP(this.width, this.height) 
    {
        paddingAmount = ((4 - (width * 3) % 4) % 4);
        imageInt = List<int>.filled((width * 3 + paddingAmount) * height + 54, 0);

        const int fileHeaderSize = 14;
        const int informationHeaderSize = 40;
        final int fileSize = fileHeaderSize + informationHeaderSize + width * height * 3 + paddingAmount * height;

        //File type
        imageInt[0] = 66;
        imageInt[1] = 77;
        // File size
        imageInt[2] = fileSize;
        imageInt[3] = fileSize >> 8;
        imageInt[4] = fileSize >> 16;
        imageInt[5] = fileSize >> 24;
        //Reserved 1 (not used)
        imageInt[6] = 0;
        imageInt[7] = 0;
        //Reserved 2 (not used)
        imageInt[8] = 0;
        imageInt[9] = 0;
        //Pixel data offset
        imageInt[10] = fileHeaderSize + informationHeaderSize;
        imageInt[11] = 0;
        imageInt[12] = 0;
        imageInt[13] = 0;

        //Header size
        imageInt[14] = informationHeaderSize;
        imageInt[15] = 0;
        imageInt[16] = 0;
        imageInt[17] = 0;
        //Image width
        imageInt[18] = width;
        imageInt[19] = width >> 8;
        imageInt[20] = width >> 16;
        imageInt[21] = width >> 24;
        //Image height
        imageInt[22] = height;
        imageInt[23] = height >> 8;
        imageInt[24] = height >> 16;
        imageInt[25] = height >> 24;
        //Planes
        imageInt[26] = 1;
        imageInt[27] = 0;
        //Bits per pixels (RGB)
        imageInt[28] = 24;
        imageInt[29] = 0;
        //Compression (no compression)
        imageInt[30] = 0;
        imageInt[31] = 0;
        imageInt[32] = 0;
        imageInt[33] = 0;
        //Image size (no compression)
        imageInt[34] = 0;
        imageInt[35] = 0;
        imageInt[36] = 0;
        imageInt[37] = 0;
        //X pixels per meter (not specified)
        imageInt[38] = 0;
        imageInt[39] = 0;
        imageInt[40] = 0;
        imageInt[41] = 0;
        //Y pixels per meter (not specified)
        imageInt[42] = 0;
        imageInt[43] = 0;
        imageInt[44] = 0;
        imageInt[45] = 0;
        //Total colors (colors palette bot used)
        imageInt[46] = 0;
        imageInt[47] = 0;
        imageInt[48] = 0;
        imageInt[49] = 0;
        //Important colors (Generally ignored)
        imageInt[50] = 0;
        imageInt[51] = 0;
        imageInt[52] = 0;
        imageInt[53] = 0;
    }
}

List<List<int>> divideImage(ImageBMP image) 
{
    List<List<int>> images = [];

    int widthA4 = 794;
    int heightA4 = 1123;
    int gap = 40;

    int pagesY = image.height ~/ heightA4 + 1;
    int pagesX = image.width ~/ widthA4 + 1;

    print(image.width);
    print(image.height);

    for (int pageY = 0; pageY < pagesY; pageY++) 
    {
        for (int pageX = 0; pageX < pagesX; pageX++) 
        {
            final imagePart = ImageBMP(widthA4, heightA4);
            fill(imagePart, 255, 255, 255);

            for (int y = 0; y < heightA4 - gap; y++) 
            {
                for (int x = 0; x < widthA4 - gap; x++) 
                {
                    if (x + (widthA4 - gap) * pageX < image.width && y + (heightA4 - gap) * pageY < image.height)
                    {
                        //B
                        imagePart.imageInt[(y * imagePart.width + x) * 3 + y * imagePart.paddingAmount + 54] 
                        =  
                        image.imageInt[((y + (heightA4 - gap) * pageY) * image.width + x + (widthA4 - gap) * pageX) * 3 + (y + (heightA4 - gap) * pageY) * image.paddingAmount + 54];
                        //G
                        imagePart.imageInt[(y * imagePart.width + x) * 3 + y * imagePart.paddingAmount + 54 + 1] 
                        =  
                        image.imageInt[((y + (heightA4 - gap) * pageY) * image.width + x + (widthA4 - gap) * pageX) * 3 + (y + (heightA4 - gap) * pageY) * image.paddingAmount + 54 + 1];
                        //R
                        imagePart.imageInt[(y * imagePart.width + x) * 3 + y * imagePart.paddingAmount + 54 + 2] 
                        =  
                        image.imageInt[((y + (heightA4 - gap) * pageY) * image.width + x + (widthA4 - gap) * pageX) * 3 + (y + (heightA4 - gap) * pageY) * image.paddingAmount + 54 + 2];
                    }
                    else
                    {
                        //B
                        imagePart.imageInt[(y * imagePart.width + x) * 3 + y * imagePart.paddingAmount + 54] = 255;
                        //G
                        imagePart.imageInt[(y * imagePart.width + x) * 3 + y * imagePart.paddingAmount + 54 + 1] = 255;
                        //R
                        imagePart.imageInt[(y * imagePart.width + x) * 3 + y * imagePart.paddingAmount + 54 + 2] = 255;
                    }
                }
            }

        images.add(imagePart.imageInt);
        }
    }
    return images;
}

