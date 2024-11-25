import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../models/carro.dart';

class DaoCarro {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static void inicializa() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static void salvarAutoID(Carro c) {
    db.collection("carro").add(c.toMap).then((docRef) {
      print("Documento salvo com ID: ${docRef.id}");
    }).catchError((error) {
      print("Erro ao salvar documento: $error");
    });
  }

  static Stream<List<Carro>> getCarro() {    
    return FirebaseFirestore.instance.collection('carro').snapshots().map((QuerySnapshot) {
      print("Carros carregados: ${QuerySnapshot.docs.map((doc) => doc.data())}");
      return QuerySnapshot.docs.map((doc) {
        return Carro.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id; // Atribui o ID do documento ao objeto Carro
        }).toList();
      },
    );
  }

  static void remover(int _counter) {
    db.collection("carro").doc("carro$_counter").delete().then((_) {
      print("Documento removido com sucesso!");
    }).catchError((error) {
      print("Erro ao remover documento: $error");
    });
  }

  static void editar(Carro c, int _counter) {
    db.collection("carro").doc("carro$_counter").update(c.toMap).then((_) {
      print("Documento atualizado com sucesso!");
    }).catchError((error) {
      print("Erro ao atualizar documento: $error");
    });
  }

  static Future<Carro?> buscarPorID(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = 
        await db.collection("carro").doc(id).get();

      if (doc.exists) {
        return Carro.fromMap(doc.data()!..["id"] = doc.id);
      } else {
        print("Documento com ID $id não encontrado.");
        return null;
      }
    } catch (e) {
      print("Erro ao buscar documento: $e");
      return null;
    }
  }

  static Future<void> atualizarUltimoKmEConsumo(String idCarro, int ultimoKm, double consumo) async {
    try {
      await db.collection("carro").doc(idCarro).update({
        "ultimoKm": ultimoKm,
        "consumo": consumo,
      });
      print("Campos 'ultimoKm' e 'consumo' atualizados com sucesso!");
    } catch (e) {
      print("Erro ao atualizar campos: $e");
    }
  }

}