import 'package:flutter/material.dart';

class CrearencuestaScreen extends StatefulWidget {
  const CrearencuestaScreen({super.key});

  @override
  State<CrearencuestaScreen> createState() => _CrearencuestaScreenState();
}

class _CrearencuestaScreenState extends State<CrearencuestaScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _encuestaController = TextEditingController();
  List<String> _campos = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear encuesta")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _encuestaController,
                decoration: InputDecoration(labelText: "Nombre encuesta"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Escribe el nombre de la encuesta";
                  }
                  return null;
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _campos.length+1,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      decoration: InputDecoration(labelText: "Campo ${index+1}"),
                      onChanged: (value){
                        print(index);
                        print(value);
                        setState(() {
                          _campos[index] = value;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
