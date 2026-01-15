import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _msgController = TextEditingController();
  String sender = "anonimo";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Chat en tiempo real"),
          centerTitle: true,
          backgroundColor: Color(0x0FFF0F0F0),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("messages")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(child: Text("No hay mensajes"));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      return ListTile(
                        title: Text(data['text'] ?? 'Sin texto'),
                        subtitle: Text(
                          "enviado por:  ${data['sender'] ?? 'Anonimo'}",
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        TextFormField(
                          controller: _msgController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Escribe un mensaje";
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(onPressed: () {}, child: Text("Enviar")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
