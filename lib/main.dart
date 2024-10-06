import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'SleevePage.dart';
import 'support.dart';

void main() 
{
    runApp
    (
      	MaterialApp
      	(
			theme: ThemeData(primarySwatch: black),
			routes: 
			{
				'/': (context) => HomePage(),
				'/sleevePage': (context) => const SleevePage(),
        '/sleeveMeasuresPage': (context) => SleeveMeasuresPage(),
			},
    	)
  	);
}


