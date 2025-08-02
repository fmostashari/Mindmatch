import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: app(),
  ));
}

int numofsq = 4;
List randomicons = [];

class app extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _app();
}

class _app extends State<app> {
  late double sqw;
  var lastmove = -1;
  int score = 0;
  bool onche = false; 
  List<bool> flags;
  String resultMessage = "";
  List<IconData> listicon = [
    Icons.account_tree,
    Icons.account_box,
    Icons.airplanemode_active,
    Icons.beach_access,
    Icons.cake,
    Icons.directions_car,
    Icons.email,
    Icons.face,
    Icons.circle,
    Icons.square,
    Icons.handshake,
    Icons.javascript,
    Icons.dangerous,
    Icons.school,
    Icons.scatter_plot,
    Icons.bedtime,
  ];

  _app()
      : flags = List.generate(numofsq * numofsq, (index) => false) {
    setupGame();
  }

  void setupGame() {
    randomicons.clear();
    List<IconData> iconsel = listicon.sublist(0,min((numofsq * numofsq) ~/ 2, listicon.length),);
    for (var icon in iconsel) {
      for (int i = 0; i < 2; i++) {
        randomicons.add(icon);
      }
    }
    randomicons.shuffle(Random());
    flags = List.generate(numofsq * numofsq, (index) => false);
    score = 0;
    lastmove = -1;
    onche = false;
    resultMessage = ""; 
  }

  void check(int index) {
    if (onche) return; 

    setState(() {
      flags[index] = true;

      if (lastmove == -1) {
        lastmove = index;
      } else {
        onche = true; 
        if (randomicons[index] == randomicons[lastmove]) {
          score += 1;
          lastmove = -1;
          onche = false; 
        } else {
          score -= 1;
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              flags[lastmove] = false;
              flags[index] = false;
              lastmove = -1;
              onche = false; 
            });
          });
        }
      }
if (score <= -9) {
        resultMessage = "!باختی 😔";
      } else if (flags.every((flag) => flag)) {
        resultMessage = "!بردی 🎉";
      }
    });
  }

     

  @override
  Widget build(BuildContext context) {
    double avaspace = MediaQuery.of(context).size.width - 2 * 10 - 2 * 20 - 2 * 10;
    sqw = avaspace / numofsq;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("اگر گفتی چی کجاست",
          style: TextStyle(
            color: Colors.white
            ,fontWeight: FontWeight.bold
          )
          ,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(width: 10, color: const Color.fromARGB(255, 233, 231, 231)),
              ),
              child: Column(
                children: [
                  Column(
                    children: List.generate(numofsq, (i) => row(i)),
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    child: Text("امتیاز: $score",style:TextStyle(
                      color: Colors.white,
                      fontWeight:FontWeight.bold,
                    ),),
                  ),
                ],
              ),
            ),

          ),
           Padding(
            padding:  EdgeInsets.all(20.0),
            child: Text(
              resultMessage,
              style: TextStyle(
                color:  Color.fromARGB(255, 38, 38, 38),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            
          ),
        ],
      ),
    );
  }

  Row row(int i) {
    return Row(
      children: List.generate(
        numofsq,
        (j) => sq(
          i * numofsq + j,
          flags[i * numofsq + j],
          check,
          sqw,
        ),
      ),
    );
  }
}

class sq extends StatelessWidget {
  final int index;
  final bool flag;
  final Function(int) check;
  final double sqw;

  sq(this.index, this.flag, this.check, this.sqw);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sqw,
      height: sqw,
      decoration: BoxDecoration(color: Colors.lightBlueAccent,
      border:Border.all(width: 5,color: Colors.black) ),
      child: IconButton(color: const Color.fromARGB(255, 253, 254, 255),
        icon: flag ? Icon(randomicons[index]) : Icon(Icons.question_mark,color: Colors.pinkAccent,),
        onPressed: () {
          if (!flag) {
            check(index);
          }
        },
      ),
    );
  }
}
