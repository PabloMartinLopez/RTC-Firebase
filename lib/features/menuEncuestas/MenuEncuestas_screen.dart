import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuencuestasScreen extends StatefulWidget {
  const MenuencuestasScreen({super.key});

  @override
  State<MenuencuestasScreen> createState() => _MenuencuestasScreenState();
}

class _MenuencuestasScreenState extends State<MenuencuestasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encuestas"),
        centerTitle: true,
        backgroundColor: Color(0xFFF0F0F0),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/createEncuestas'),
            child: Text("Crear encuesta"),
          ),
        ],
      ),
      body: Scaffold(
        body: Center(
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

              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(docs[index].id),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/votaciones',
                      arguments: docs[index].id,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: docs.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
