import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

//biblioteca que permite fazer as requisições em http
import 'package:http/http.dart' as http;

//biblioteca permite que façamos requisições sem precisar esperar pela resposta (requisição assincrona)
import 'dart:async';

//converter os dados json para ler e chamar conversão de map
import 'dart:convert';

//declarar como const ajuda a não fazer besteira depois sem querer...
const request = "https://api.hgbrasil.com/finance?key=7822b134";

void main() async {
  runApp(MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        ),
        
      )
      );
}



Future<Map> getData() async {
  //variavel que recebe a resposta do servidor | solicitação get request e não retorna na hora | await vai fazer esperar
  http.Response response = await http.get(request);
  //usado para transformar o nosso json em um map
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged (String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged (String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged (String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);   
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[800],
        child: Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.amber,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {})
          ],
        ),
      ),
      
      
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando dados...",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0),
                  textAlign: TextAlign.center,)
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Erro ao carregar dados :(",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0),
                    textAlign: TextAlign.center,)
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  
                  // LAYOUT COMEÇA AQUI
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(20.0),
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.amber,
                          boxShadow: [BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        ),
                        
                          padding: new EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              buildTextField("Reais", "R\$", realController, _realChanged),
                              SizedBox(height: 7),
                              buildTextField("Dolares", "US\$", dolarController, _dolarChanged),
                              SizedBox(height: 7),
                              buildTextField("Euros", "€", euroController, _euroChanged),
                            ],
                          ),
                        ),
                        SizedBox(height: 14),
                        Container(
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.cyan[100],
                          
                        ),
                          padding: new EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 60),
                            ],
                          ),
                        ),                        
                      ],
                    ),
                    );
                }
            }
          }),
    );
  }
}


Widget buildTextField(String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      prefixText: prefix,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber[800], width: 1.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      
    ),
    style: TextStyle(
      color: Colors.amber,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

