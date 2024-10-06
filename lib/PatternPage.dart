// ignore_for_file: avoid_print, file_names, non_constant_identifier_names, prefer_const_constructors

import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'drawingBMP.dart';
import 'myimage.dart';
import 'support.dart';

class PatternPage extends StatefulWidget 
{
  	const PatternPage({super.key});

	@override
    State<PatternPage> createState() => PatternPageState();
}

class PatternPageState extends State<PatternPage> 
{
    ui.Image? image;

    //drawing function
    late ImageBMP Function(List<double>, double, bool, bool, bool) drawPattern;
	
    //settings
    int msecondsPerFrame = 40;
    final double printingScaleFactor = 39.24;
    String title = 'Pattern page';
    int slidersNumber = 0;
    late List<double> slidersValues = List<double>.filled(slidersNumber, 0.5);
    
	//settings by user
    double scaleFactor = 10; 
    bool isMainBold = false;
    bool isSupportBold = false;

    @override
    Widget build(BuildContext context) 
    {
        return Scaffold
        (
            body: Center
            (
                child: Row
                (
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: 
                    [
                        const SizedBox(width: 100),
                        //Left side
                        Column
                        (
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: 
                            [
                                Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),

                                //const Text("Top", style: TextStyle(fontSize: 20, color: Colors.black),),

                                for (int i = 0; i < slidersNumber; i++) Row(children: [Text((i + 1).toString(), style: const TextStyle(fontSize: 18)), MySlider(page: this, sliderNumber: i,)]),  
                            ],
                        ),

                        //Image
                        image == null
                        ? const SizedBox(width: 100, height: 100, child: CircularProgressIndicator()) 
                        : Expanded
                        (
                            child: Container
                            (
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white10,
                                child:FittedBox
                                (
                                    child: SizedBox
                                    (
                                        width: image!.width.toDouble(),
                                        height: image!.height.toDouble(),
                                        child: CustomPaint(painter: ImagePainter(image!)), 
                                    )
                                )
                            ),
                        ),

                        //Right side
                        Column
                        (
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: 
                            [
                                const Text("Preview settings", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                                const SizedBox(height: 20),
                                Container
                                (
                                    width: 250,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                    child: Column
                                    (
                                        children: 
                                        [
                                            const SizedBox(height: 5),
                                            const Text("Quality", style: TextStyle(fontSize: 20, color: Colors.black)),

                                            Slider
                                            (
                                                value: scaleFactor,
                                                min: 5,
                                                max: 15,
                                                onChanged: (newValue) 
                                                {
                                                    scaleFactor = newValue;
                                                    updateImage(false);
                                                },
                                                onChangeEnd: (newValue)
                                                {
                                                    scaleFactor = newValue; 
                                                    updateImage(true);
                                                },
                                            ),

                                            const SizedBox(height: 15),

                                            Row
                                            (
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: 
                                                [
                                                    Column
                                                    (
                                                        children: const 
                                                        [
                                                            Text("Bold main lines", style: TextStyle(fontSize: 20, color: Colors.black)),
                                                            SizedBox(height: 4),
                                                        ],
                                                    ),
                                                    Checkbox
                                                    (
                                                        value: isMainBold,
                                                        fillColor: MaterialStateProperty.all(Colors.black),
                                                        shape: const CircleBorder(),
                                                        onChanged: (newValue) 
                                                        {
                                                            isMainBold = newValue!;
                                                            updateImage(true);
                                                        }
                                                    ),
                                                ],
                                            ),

                                            const SizedBox(height: 15),

                                            Row
                                            (
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: 
                                                [
                                                    Column
                                                    (
                                                        children: const 
                                                        [
                                                            Text("Bold support lines", style: TextStyle(fontSize: 20, color: Colors.black)),
                                                            SizedBox(height: 4),
                                                        ],
                                                    ),
                                                    Checkbox
                                                    (
                                                        value: isSupportBold,
                                                        fillColor: MaterialStateProperty.all(Colors.black),
                                                        shape: const CircleBorder(),
                                                        onChanged: (newValue) 
                                                        {
                                                            isSupportBold = newValue!;
                                                            updateImage(true);
                                                        }
                                                    ),
                                                ],
                                            ),

                                            const SizedBox(height: 15),
                                        ],
                                    ),
                                ),

                                const SizedBox(height: 50),

                                SizedBox
                                (
                                    width: 200,
                                    height: 50,
                                    child: ElevatedButton
                                    (
                                        onPressed: () {exportImage();},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                                        child: const Text("Export"),
                                    )
                                ),

                                const SizedBox(height: 10),

                                SizedBox
                                (
                                    width: 200,
                                    height: 50,
                                    child: ElevatedButton
                                    (
                                        onPressed: () {updateImage(true);},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                                        child: const Text("display"),
                                    )
                                ),

                                const SizedBox(height: 10),

                                SizedBox
                                (
                                    width: 200,
                                    height: 50,
                                    child: ElevatedButton
                                    (
                                        onPressed: exportSquare,
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                                        child: const Text("Square"),
                                    )
                                ),

                                const SizedBox(height: 10),

                                SizedBox
                                (
                                    width: 200,
                                    height: 50,
                                    child: ElevatedButton
                                    (
                                        onPressed: () => Navigator.pop(context),
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                                        child: const Text("Back"),
                                    )
                                ),
                            ],
                        ),
                        const SizedBox(width: 100),
                    ],
                ),
            ),
        );
    }

	//fps controll
    var time1 = DateTime.now();
    var time2 = DateTime.now();

    void updateImage(bool isForced) 
    {
		time1 = DateTime.now();

        if ((time1.difference(time2).inMilliseconds > msecondsPerFrame) | isForced) 
        {
            time2 = DateTime.now();

            decodeImageFromList(Uint8List.fromList(drawPattern(slidersValues, scaleFactor, isMainBold, isSupportBold, false).imageInt)).then((value) => setState(() {image = value;}));
        }
		else
		{
			setState(() {});
		}
        
    }

	void exportImage() async
    {
        List<double> l_slidersValues = slidersValues;
		double l_scaleFactor = printingScaleFactor;
        bool l_isMainBold = isMainBold;
        bool l_isSupportBold = isSupportBold;
        

        ImageBMP Function(List<double>, double, bool, bool, bool) l_drawPattern = drawPattern;
		
		Isolate.run
        (
            () async 
            {
                ImageBMP patternImage = l_drawPattern(l_slidersValues, l_scaleFactor, l_isMainBold, l_isSupportBold, true);

                List<List<int>> imagesA4 = divideImage(patternImage);

                List<Uint8List> imagesA48 = [];
            
                for (int i = 0; i < imagesA4.length; i++) 
                {
                    imagesA48.add(Uint8List.fromList(imagesA4[i]));
                    
                }
                
                return await createPDF(imagesA48).then((value) {print("exported");}); 
		    },
        );
    }
}

//TODO remove
exportSquare() 
{
    List<int> square = drawSquare();
    List<Uint8List> imagesA48 = [Uint8List.fromList(square)];
    createPDF(imagesA48);
}

class MySlider extends StatelessWidget
{
	final PatternPageState page;
	final int sliderNumber;
	final double sliderValue;

	const MySlider({super.key, required this.page, required this.sliderNumber}) : sliderValue = 0.5;

	@override
	Widget build (BuildContext context)
	{
		return Slider
		(
			value: page.slidersValues[sliderNumber],
			min: 0.25,
			max: 0.75,
			onChanged: (newValue) 
			{
				page.slidersValues[sliderNumber] = newValue;
				page.updateImage(false);
			},
			onChangeEnd: (newValue) 
			{
				page.slidersValues[sliderNumber] = newValue;
				page.updateImage(true);
			},
		);
	}
}

class PatternMeasuresPage extends StatefulWidget
{
    @override
    State<PatternMeasuresPage> createState() => PatternMeasuresPageState();
}

class PatternMeasuresPageState extends State<PatternMeasuresPage>
{
    int measuresNumber = 10;
    late List<TextEditingController> textControllers = List<TextEditingController>.filled(measuresNumber, TextEditingController());
    late String patternPageRoute;

    @override
    Widget build (BuildContext context)
    {
        return Scaffold
        (
            body: Column
            (
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                    Row
                    (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 
                        [
                            Column
                            (
                                children:
                                [
                                    SizedBox(height: 5),

                                    for (int i = 0; i < measuresNumber; i ++) 
                                    Column
                                    (
                                        children:
                                        [
                                            SizedBox(height: 40, child: Text("$i measure: ", style: TextStyle(fontSize: 22, color: Colors.black))),
                                            SizedBox(height: 5),     
                                        ]
                                    ) 
                                ],
                            ),

                            Column
                            (
                                children: 
                                [
                                    for (int i = 0; i < measuresNumber; i++)
                                    Column
                                    (
                                        children:
                                        [
                                            Row
                                            (
                                                children: 
                                                [
                                                    SizedBox
                                                    (
                                                        width: 100,
                                                        height: 40,
                                                        child: TextField
                                                        (
                                                            controller: textControllers[i],
                                                            textAlign: TextAlign.center,
                                                            textAlignVertical: TextAlignVertical.top,
                                                            style: TextStyle(fontSize: 22, color: Colors.black),
                                                            decoration: const InputDecoration(border: OutlineInputBorder()),
                                                        ),
                                                    ),

                                                    Text(" cm", style: const TextStyle(fontSize: 22, color: Colors.black))
                                                ],
                                            ),

                                            SizedBox(height: 5)
                                        ]
                                    )
                                ],
                            ),
                        ]
                    ),

                    const SizedBox(height: 15),

                    SizedBox
                    (
                        width: 200,
                        height: 50,
                        child: ElevatedButton
                        (
                            onPressed: () => Navigator.pushNamed(context, patternPageRoute), 
                            child: const Text("Go")
                        ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox
                    (
                        width: 200,
                        height: 50,
                        child: ElevatedButton
                        (
                            onPressed: () => Navigator.pop(context), 
                            child: const Text("Back")
                        ),
                    ),

                ],
            )
        );
    }
}