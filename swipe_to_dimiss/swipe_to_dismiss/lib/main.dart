import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _fruits = ['Apple', 'Banana', 'Orange', 'Watermelong'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Swipe to dismiss'),
          centerTitle: true,
        ),
        body: Center(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _fruits.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('${_fruits[index]}'),
                    background: Container(
                        color: Colors.green,
                        child: Icon(Icons.mode_edit)),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Icon( Icons.delete ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      child: Text(
                        _fruits[index],
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart){
                        _fruits.removeAt(index);
                      }
                      if (direction == DismissDirection.startToEnd){
                        
                      }
                    },
                  );
                })));
  }
}
