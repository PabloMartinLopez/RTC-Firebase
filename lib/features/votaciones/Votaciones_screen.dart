import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/barrar_votacion.dart';

class VotacionesScreen extends StatefulWidget {
  const VotacionesScreen({super.key});

  @override
  State<VotacionesScreen> createState() => _VotacionesScreenState();
}

class _VotacionesScreenState extends State<VotacionesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Votaciones"),
        centerTitle: true,
        backgroundColor: Color(0x0FFF0F0F0),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("encuestas")
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
                final data = docs[0].data() as Map<String, dynamic>;
                final List<MapEntry<String, dynamic>> lista = data.entries.toList();

                var totalvotos = lista.map((e) => e.value).reduce((a, b) => a + b);
                List<Color>Colores = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.purple, Colors.pink, Colors.brown, Colors.grey, Colors.black];

                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final data = lista[index];
                    Text("${data.key}: ${data.value}");
                    return BarraVotacion(label: data.key, votos: data.value, total: totalvotos, color: Colores[index], onTap: ()=>updateVoto(docs[index].id));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


void updateVoto(elementopulsado){
  print(elementopulsado);
  FirebaseFirestore.instance.collection("encuestas").doc(elementopulsado).update({
    elementopulsado: FieldValue.increment(1),
  });
}