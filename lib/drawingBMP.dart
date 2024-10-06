// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:math';

import 'myimage.dart';

void fill(ImageBMP image, int r, int g, int b) 
{
    for (int y = 0; y < image.height; y++) 
    {
        for (int x = 0; x < image.width; x++) 
        {
            image.imageInt[(y * image.width + x) * 3 + y * image.paddingAmount + 54] = b;
            image.imageInt[(y * image.width + x) * 3 + y * image.paddingAmount + 54 + 1] = g;
            image.imageInt[(y * image.width + x) * 3 + y * image.paddingAmount + 54 + 2] = r;
        }
    }
}

void drawPoint(ImageBMP image, Point p) 
{
    for (int x = p.x - 1; x <= p.x + 1; x++) 
    {
        for (int y = p.y - 1; y <= p.y + 1; y++) 
        {
            if (x >= 0 && x < image.width && y >= 0 && y < image.height) 
            {
                image.imageInt[(y * image.width + x) * 3 + y * image.paddingAmount + 54] = 0;
                image.imageInt[(y * image.width + x) * 3 + y * image.paddingAmount + 54 + 1] = 0;
                image.imageInt[(y * image.width + x) * 3 + y * image.paddingAmount + 54 + 2] = 250;
            }
        }
    }
}

void drawLine(ImageBMP image, Point p1, Point p2, int thickness) 
{
    thickness = (thickness - 1) ~/ 2;

    if (p1.x == p2.x) 
    {
        for (int y = min(p1.y, p2.y); y <= max(p1.y, p2.y); y++) 
        {
            for (int i = p1.x - thickness; i <= p1.x + thickness; i++) 
            {
                for (int j = y - thickness; j <= y + thickness; j++) 
                {
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54] = 0;
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54 + 1] = 0;
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54 + 2] = 0;
                }
            }
        }
    } 
    else 
    {
        double slope = (p2.y - p1.y) / (p2.x - p1.x);

        for (int x = min(p1.x, p2.x); x <= max(p1.x, p2.x); x++) 
        {
            int y = (slope * (x - min(p1.x, p2.x)) + min(p1.y, p2.y)).toInt();

            if (slope < 0) 
            {
                y += (max(p1.y, p2.y) - min(p1.y, p2.y));
            }

            for (int i = x - thickness; i <= x + thickness; i++) 
            {
                for (int j = y - thickness; j <= y + thickness; j++) 
                {
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54] = 0;
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54 + 1] = 0;
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54 + 2] = 0;
                }
            }
        }
    }
}

Point findOffsetPoint(Point p, double slope, double offset, bool isRight) 
{
    double x = sqrt((offset * offset) / (1 + slope * slope));
    int y = (slope * x).toInt();

    if (!isRight) 
    {
        x *= -1;
        y *= -1;
    }

    Point r = Point((p.x + x).toInt(), p.y + y);

    return r;
}

void drawQuadraticBezier(ImageBMP image, Point a, Point b, Point c, double bt, int thickness, Point rs, Point rf, bool isExport) 
{
    double initialT = 0.0005;

    thickness = (thickness - 1) ~/ 2;

    Point control = Point(0, 0);
    control.x = (b.x - a.x + 2 * bt * a.x - bt * bt * a.x - bt * bt * c.x) ~/ (2 * bt - 2 * bt * bt);
    control.y = (b.y - a.y + 2 * bt * a.y - bt * bt * a.y - bt * bt * c.y) ~/ (2 * bt - 2 * bt * bt);

    if (!isExport)
    {
        drawPoint(image, b);
        drawPoint(image, control);
    }

    for (double t = initialT; t <= 1 - initialT; t += initialT) 
    {
        int x = (a.x * (1 - t) * (1 - t) + control.x * 2 * (1 - t) * t + c.x * t * t).toInt();
        int y = (a.y * (1 - t) * (1 - t) + control.y * 2 * (1 - t) * t + c.y * t * t).toInt();

        for (int i = x - thickness; i <= x + thickness; i++) 
        {
            for (int j = y - thickness; j <= y + thickness; j++) 
            {
                if (j > 0 && j < image.height && i >= rs.x && i < rf.x) 
                {
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54] = 0;
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54 + 1] = 0;
                    image.imageInt[(j * image.width + i) * 3 + j * image.paddingAmount + 54 + 2] = 0;
                }
            }
        }
    }
}

void drawNumber(ImageBMP image, int number, Point P1, double scaleFactor, double size, int thickness)
{
    Point P2 = Point((P1.x + size * scaleFactor).toInt(), P1.y);
    Point P3 = Point(P1.x, (P1.y + size * scaleFactor).toInt());
    Point P4 = Point((P1.x + size * scaleFactor).toInt(), (P1.y + size * scaleFactor).toInt());
    Point P5 = Point(P1.x, (P1.y + size * 2 * scaleFactor).toInt());
    Point P6 = Point((P1.x + size * scaleFactor).toInt(), (P1.y + size * 2 * scaleFactor).toInt());

    switch(number)
    {
        case 1:
            drawLine(image, P2, P6, thickness);
            break;
        case 2:
            drawLine(image, P1, P2, thickness);
            drawLine(image, P1, P3, thickness);
            drawLine(image, P3, P4, thickness);
            drawLine(image, P4, P6, thickness);
            drawLine(image, P5, P6, thickness);
            break;
        case 3:
            drawLine(image, P1, P2, thickness);
            drawLine(image, P2, P6, thickness);
            drawLine(image, P3, P4, thickness);
            drawLine(image, P5, P6, thickness);
            break;
        case 4:
            drawLine(image, P2, P6, thickness);
            drawLine(image, P3, P4, thickness);
            drawLine(image, P3, P5, thickness);
            break;
        case 5:
            drawLine(image, P1, P2, thickness);
            drawLine(image, P2, P4, thickness);
            drawLine(image, P3, P4, thickness);
            drawLine(image, P3, P5, thickness);
            drawLine(image, P5, P6, thickness);
            break;
        case 6:
            drawLine(image, P1, P2, thickness);
            drawLine(image, P2, P4, thickness);
            drawLine(image, P1, P5, thickness);
            drawLine(image, P3, P4, thickness);
            drawLine(image, P5, P6, thickness);
            break;
        case 7:
            drawLine(image, P2, P6, thickness);
            drawLine(image, P5, P6, thickness);
            break;
        case 8:
            drawLine(image, P1, P2, thickness);
            drawLine(image, P3, P4, thickness);
            drawLine(image, P5, P6, thickness);
            drawLine(image, P1, P5, thickness);
            drawLine(image, P2, P6, thickness);
            break;
        case 9:
            drawLine(image, P1, P2, thickness);
            drawLine(image, P3, P4, thickness);
            drawLine(image, P5, P6, thickness);
            drawLine(image, P3, P5, thickness);
            drawLine(image, P2, P6, thickness);
            break;
    }
}

ImageBMP drawSleeve(List<double> t, double scaleFactor, bool isMainBold, bool isSupportBold, bool isExport) 
{
    int borderSize = (scaleFactor).toInt();

    int lineThickness = 1;
    if (isMainBold) 
    {
      lineThickness = 3;
    }

    int supportLineThickness = 1;
    if (isSupportBold) 
    {
      supportLineThickness = 3;
    }

    const int patternWidth = 36; //36;
    const int patternHeight = 58; //58;

    int width = (borderSize * 2 + patternWidth * scaleFactor).toInt();
    int height = (borderSize * 2 + patternHeight * scaleFactor).toInt();
    ImageBMP image = ImageBMP(width, height);

    fill(image, 255, 255, 255);

    Point A = Point(borderSize, (borderSize + patternHeight * scaleFactor).toInt());
    Point B = Point((borderSize + patternWidth * scaleFactor).toInt(), (borderSize + patternHeight * scaleFactor).toInt());
    Point C = Point((borderSize + patternWidth * scaleFactor).toInt(), borderSize);
    Point D = Point(borderSize, borderSize);

    drawLine(image, A, B, supportLineThickness);
    drawLine(image, B, C, supportLineThickness);
    drawLine(image, C, D, supportLineThickness);
    drawLine(image, D, A, supportLineThickness);

    Point P = Point(A.x, (A.y - 15 * scaleFactor).toInt());
    Point P1 = Point(B.x, (B.y - 15 * scaleFactor).toInt());

    drawLine(image, P, P1, supportLineThickness);

    Point O = Point(A.x + patternWidth * scaleFactor ~/ 2, A.y);
    Point O1 = Point(A.x + patternWidth * scaleFactor ~/ 4, A.y);
    Point O2 = Point(B.x - patternWidth * scaleFactor ~/ 4, B.y);
    Point O3 = Point((O.x + P.x) ~/ 2, (O.y + P.y) ~/ 2);
    Point O4 = Point(O2.x, (A.y + P.y) ~/ 2);
    Point O5 = Point(O1.x, (A.y + P.y) ~/ 2 + (1.5 * scaleFactor).toInt());

    Point N = Point(O1.x, D.y);
    Point N1 = Point(O.x, D.y);
    Point N2 = Point(O2.x, D.y);
    Point N3 = Point(D.x, (D.y + 1 * scaleFactor).toInt());
    Point N4 = Point(C.x, (C.y + 1 * scaleFactor).toInt());
    Point N5 = Point(N2.x, N2.y + (1.5 * scaleFactor).toInt());

    drawLine(image, O1, N, supportLineThickness);
    drawLine(image, O, N1, supportLineThickness);
    drawLine(image, O2, N2, supportLineThickness);

    //y = PO*x + P.y
    drawLine(image, P, O, supportLineThickness);
    Point E = Point((O3.x + O.x) ~/ 2, (O3.y + O.y) ~/ 2);
    Point E2 = Point((O3.x + P.x) ~/ 2, (O3.y + P.y) ~/ 2);
    double PO = (P.y - O.y) / (P.x - O.x);
    double EE1 = -1 / PO;
    Point E1 = findOffsetPoint(E, EE1, (2 * scaleFactor).toDouble(), false);
    Point E3 = findOffsetPoint(E2, EE1, 0.5 * scaleFactor, true);

    //y = OP1*x + smth
    drawLine(image, O, P1, supportLineThickness);
    Point E4 = Point((O.x + O4.x) ~/ 2, (O.y + O4.y) ~/ 2);
    Point E6 = Point((P1.x + O4.x) ~/ 2, (P1.y + O4.y) ~/ 2);
    double OP1 = (P1.y - O.y) / (P1.x - O.x);
    double E4E5 = -1 / OP1;
    Point E5 = findOffsetPoint(E4, E4E5, 1.5 * scaleFactor, true);
    Point E7 = findOffsetPoint(E6, E4E5, (2 * scaleFactor.toDouble()), false);

    //top
    drawQuadraticBezier(image, P, E3, O5, t[0], lineThickness, P, P1, isExport);
    drawQuadraticBezier(image, O5, E1, O, t[1], lineThickness, P, P1, isExport);
    drawQuadraticBezier(image, O, E5, O4, t[2], lineThickness, P, P1, isExport);
    drawQuadraticBezier(image, O4, E7, P1, t[3], lineThickness, P, P1, isExport);
    //bottom
    drawQuadraticBezier(image, N3, N, N1, t[4], lineThickness, N3, N, isExport);
    drawQuadraticBezier(image, N, N1, N5, t[5], lineThickness, N1, N5, isExport);
    drawQuadraticBezier(image, N1, N5, N4, t[6], lineThickness, N5, N4, isExport);
    //drawCubicBezier(image, N, N1, N5, N4, t[5], t[6], lineThickness, N, N4);

    Point N6 = Point((N.x - 2 * scaleFactor).toInt(), N.y);
    Point N7 = Point(N6.x, (N6.y + 10 * scaleFactor).toInt());
    drawLine(image, N6, N7, lineThickness);
    drawLine(image, P, N3, lineThickness);
    drawLine(image, P1, N4, lineThickness);
    drawLine(image, N, N1, lineThickness);

    if (!isExport)
    {
        drawNumber(image, 1, Point(E2.x, O3.y), scaleFactor, 1, 1);
        drawNumber(image, 2, Point(E.x, (P.y * 1.15).toInt()), scaleFactor, 1, 1);
        drawNumber(image, 3, Point(E4.x, (P.y * 1.15).toInt()), scaleFactor, 1, 1);
        drawNumber(image, 4, Point(E6.x, O4.y), scaleFactor, 1, 1);
        drawNumber(image, 5, Point(E2.x, (D.y * 2).toInt()), scaleFactor, 1, 1);
        drawNumber(image, 6, Point(E4.x, (D.y * 3).toInt()), scaleFactor, 1, 1);
        drawNumber(image, 7, Point(E6.x, (D.y * 4).toInt()), scaleFactor, 1, 1);
    }

    return image;
}

List<int> drawSmallSquare(double a, double b) {
    ImageBMP image = ImageBMP((a * 100).toInt(), (b * 100).toInt());

    //fill(image);

    //drawLine(image, Point(0, 0), Point(1, 1), 1);
    drawPoint(image, Point(4, 4));

    //print(image.imageInt);

    return image.imageInt;
}

List<int> drawSquare() {

    double scaleFactor = 60;
    ImageBMP image = ImageBMP(794, 1123);

    fill(image, 255, 255, 255);

    Point A = Point(0, 0);
    Point B = Point(0, (0 + 15 * scaleFactor).toInt());
    Point C = Point((0 + 15 * scaleFactor).toInt(), (0 + 15 * scaleFactor).toInt());
    Point D = Point((0 + 15 * scaleFactor).toInt(), 0);

    drawLine(image, A, B, 1);
    drawLine(image, C, D, 1);
    drawLine(image, B, C, 1);
    drawLine(image, A, D, 1);

    return image.imageInt;
}
