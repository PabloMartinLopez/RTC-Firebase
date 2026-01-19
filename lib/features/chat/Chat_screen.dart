import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat en tiempo real"),
        centerTitle: true,
        backgroundColor: Color(0x0FFF0F0F0),
        actions: [
          ElevatedButton(
            onPressed: () => _borrarTodo(),
            child: Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .orderBy("date")
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
                    return Dismissible(
                      background: Container(color: Colors.redAccent),
                      key: Key(docs[index].id),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          _borrar(docs[index].id);
                        }
                      },

                      child: ListTile(
                        title: Text(data['text'] ?? 'Sin texto'),
                        subtitle: Text(
                          "enviado por:  ${data['sender'] ?? 'Anonimo'}",
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _borrar(docs[index].id),
                          child: Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Container(
                          width: 300,
                          height: 50,
                          child: TextFormField(
                            controller: _msgController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Escribe un mensaje";
                              }
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _enviarMsg(_msgController),
                          child: Text("Enviar"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _enviarMsg(dynamic _msgController) {
  String usuario = "Pablo";

  FirebaseFirestore.instance
      .collection("messages")
      .doc()
      .set({
        "text": _msgController.text,
        "sender": usuario,
        "date": FieldValue.serverTimestamp(),
      })
      .then((value) {
        print("Mensaje enviado");
      });
}

void _borrar(String id) {
  FirebaseFirestore.instance.collection("messages").doc(id).delete().then((
    value,
  ) {
    print("Mensaje borrado");
  });
}

void _borrarTodo() {
  Future<QuerySnapshot> msgs = FirebaseFirestore.instance
      .collection("messages")
      .get();

  msgs.then((value) {
    for (var doc in value.docs) {
      doc.reference.delete();
      print("Mensaje borrado");
    }
  });
}
