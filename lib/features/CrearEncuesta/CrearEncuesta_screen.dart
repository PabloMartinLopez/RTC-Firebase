import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearencuestaScreen extends StatefulWidget {
  const CrearencuestaScreen({super.key});

  @override
  State<CrearencuestaScreen> createState() => _CrearencuestaScreenState();
}

class _CrearencuestaScreenState extends State<CrearencuestaScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _encuestaController = TextEditingController();
  List<String> _campos = [""];
  int _contador = 1;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  ElevatedButton(
                    child: Icon(Icons.add),
                    onPressed: () => _crearCampoNuevo(),
                  ),
                  Text("Opciones"),
                  SizedBox(),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _contador,
                  itemBuilder: (context, index) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: "Campo ${index + 1}",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _campos[index] = value;
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => _guardarenfirebase(),
                child: Text("Crear encuesta"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _crearCampoNuevo() {
    setState(() {
      _contador++;
      _campos.add("");
    });
  }

  Future<void> _guardarenfirebase() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance
        .collection("encuestas")
        .doc(_encuestaController.text).set(
          _campos.asMap().map((key, value) {
            return MapEntry(value, 0);
          }),
        );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Encuesta creada correctamente")));
  }
}
