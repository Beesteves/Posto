import 'package:aula04/produto.dart';
import 'package:aula04/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DaoFirestore {
  //static final clientes = <String, String>{"nome": "André", "idade": "20"};
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static void inicializa() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static void salvar(Produto p, int _counter) {
    db.collection("produto").doc("produto$_counter").set(p.toMap).onError(
          (error, stackTrace) => print("deu ruim"),
        );
  }

  // Função para buscar clientes do Firestore
  static Stream<List<Produto>> getProduto() {
    return FirebaseFirestore.instance.collection('produto').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Produto(
            nome: doc['nome'],
            preco: doc['preco'],
          );
        }).toList();
      },
    );
  }
}
