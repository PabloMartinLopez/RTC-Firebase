import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/components/barrar_votacion.dart';

class VotacionesScreen extends StatefulWidget {
  const VotacionesScreen({super.key});

  @override
  State<VotacionesScreen> createState() => _VotacionesScreenState();
}

class _VotacionesScreenState extends State<VotacionesScreen> {

  // Incrementar el voto en Firestore
  void _updateVoto(String docId, String campo) {
    FirebaseFirestore.instance.collection("encuestas").doc(docId).update({
      campo: FieldValue.increment(1),
    });
  }

  @override
  Widget build(BuildContext context) {

    var documentos = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Votaciones"),
        centerTitle: true,
        backgroundColor: const Color(0xFFF0F0F0),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("encuestas")
                  .doc(documentos)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar datos"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final doc = snapshot.data!;
                final dataMap = doc.data() as Map<String, dynamic>;
                final List<MapEntry<String, dynamic>> lista = dataMap.entries.toList();

                // Ordenar la lista
                lista.sort((a, b) => b.key.compareTo(a.key));

                final totalVotos = lista.fold<int>(0, (sum, item) => sum + (item.value as int));

                final List<Color> colores = [
                  Colors.red, Colors.blue, Colors.green, Colors.yellow,
                  Colors.orange, Colors.purple, Colors.pink, Colors.brown,
                  Colors.grey, Colors.black
                ];

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final entrada = lista[index];

                    return BarraVotacion(
                      label: entrada.key,
                      votos: entrada.value,
                      total: totalVotos,
                      color: colores[index % colores.length],
                      onTap: () => _updateVoto(doc.id, entrada.key),
                    );
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