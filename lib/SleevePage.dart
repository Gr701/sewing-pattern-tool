// ignore_for_file: sized_box_for_whitespace, avoid_print, file_names

import 'package:flutter/material.dart';

import 'drawingBMP.dart';
import 'PatternPage.dart';

class SleevePage extends PatternPage 
{
    const SleevePage({super.key});

    @override
    State<PatternPage> createState() => SleevePageState();
}

class SleevePageState extends PatternPageState
{
    SleevePageState()
    {
        slidersNumber = 7;
        title = 'Sleeve pattern';
        drawPattern = drawSleeve;
        updateImage(true);
    }
}

class SleeveMeasuresPage extends PatternMeasuresPage
{
    @override
    State<PatternMeasuresPage> createState() => SleeveMeasuresPageState();
}

class SleeveMeasuresPageState extends PatternMeasuresPageState
{
    SleeveMeasuresPageState()
    {
        patternPageRoute = '/sleevePage';
    }
}