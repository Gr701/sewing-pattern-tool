// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget
{
    @override
    Widget build (BuildContext context)
    {
        return Scaffold
        (
            body: Row
            (
                children: 
                [
                    SizedBox(width: 10),
                    Column
                    (
                        children: 
                        [
                            Text("Dress", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                            
                            Row
                            (
                                children: 
                                [
                                    SizedBox
                                    (
                                        width: 200,
                                        height: 400, 
                                        child: GestureDetector
                                        (
                                            onTap: () => Navigator.pushNamed(context, "/sleeveMeasuresPage"), 
                                            child: Column
                                            (
                                                children: 
                                                [
                                                    Text("Sleeve", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                                                    Image(image: AssetImage("assets/sleeve.png"))
                                                ]
                                            )
                                        ),
                                    )
                                ],
                            )
                        ],
                    ),
                ]
            )
        );
    }
}