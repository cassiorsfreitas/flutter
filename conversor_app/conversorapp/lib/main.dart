import 'package:flutter/material.dart';

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
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.amber),
)),
      ));
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
    return Scaffold(
      
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        title: Text("Meu conversor (\$)",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.amber
            )),
        centerTitle: false,
        
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

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Icon( Icons.monetization_on, size: 100.0, color: Colors.amber),
                        ),
                        Divider(),
                        buildTextField("Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dolares", "US\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroController, _euroChanged),
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
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix
    ),
    style: TextStyle(
      color: Colors.amber,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}