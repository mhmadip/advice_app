import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const AdviceApp());
}

class Advice{
  int id;
  String advice;
  Advice({required this.id,required this.advice});

  factory Advice.fromJson(Map<String,dynamic> json){
    final advice =json['slip'];
    print(advice);
    return Advice(id:advice['id'],
        advice:advice['advice']
    );
  }
}

Future<Advice> fetchAdvice() async{
  final url='https://api.adviceslip.com/advice';
  final response= await get(Uri.parse(url));
  print(response.body);
  if(response.statusCode==200){
    final jsonResponse= json.decode(response.body);
    print(jsonResponse);
    return Advice.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to fetch weather data');
  }
}



class AdviceApp extends StatefulWidget {
  const AdviceApp({Key? key}) : super(key: key);

  @override
  State<AdviceApp> createState() => _AdviceAppState();
}

class _AdviceAppState extends State<AdviceApp> {
  Advice? _advice;

  Future<void> _getWeather() async{
    final advice= await fetchAdvice();
    setState(() {
      _advice= advice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Advice App',
      home: Scaffold(
        appBar: AppBar(title: const Text('Advice of the Day!'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network('https://i0.wp.com/oldpodcast.com/wp-content/uploads/2020/02/advice_podcasts.png?resize=400%2C200'),
              TextButton(onPressed: (){_getWeather();},
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.lightGreenAccent),
                ),
                  child: const Text('Advice Me :)',style: TextStyle(fontSize: 20.0),),
                
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(_advice!=null ? _advice!.advice : 'Something wrong!' ,
                      style: TextStyle(fontSize: 20.0,color: Colors.purpleAccent,letterSpacing: 10,fontStyle: FontStyle.italic)),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
