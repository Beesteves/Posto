import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static String? _getUid() {
    final User? usuario = FirebaseAuth.instance.currentUser;
    return usuario?.uid;
  }

  static Future<void> salvarAutoID(Carro c) async {
    try {
      // Obtém o usuário autenticado
      User? usuario = FirebaseAuth.instance.currentUser;
      if (usuario == null) {
        throw Exception("Usuário não autenticado.");
      }

      String uid = usuario.uid;

      // Referência para a subcoleção 'carros' dentro do documento do usuário
      CollectionReference carrosRef = db.collection('users').doc(uid).collection('carros');

      // Salva os dados do carro na subcoleção
      DocumentReference docRef = await carrosRef.add(c.toMap);

      print("Carro salvo com sucesso com ID: ${docRef.id}");
    } catch (error) {
      print("Erro ao salvar carro: $error");
    }
  }

  static Stream<List<Carro>> getCarro() {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }

    return db
        .collection('users')
        .doc(uid)
        .collection('carros')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Carro.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id; // Atribui o ID do documento ao objeto Carro
      }).toList();
    });
  }

  static Future<void> remover(String idCarro) async {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }

    try {
      await db
          .collection('users')
          .doc(uid)
          .collection('carros')
          .doc(idCarro)
          .delete();
      print("Carro com ID $idCarro removido com sucesso!");
    } catch (e) {
      print("Erro ao remover carro: $e");
    }
  }

  static Future<void> editar(Carro c) async {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }

    try {
      await db
          .collection('users')
          .doc(uid)
          .collection('carros')
          .doc(c.id)
          .update(c.toMap);
      print("Carro com ID ${c.id} atualizado com sucesso!");
    } catch (e) {
      print("Erro ao atualizar carro: $e");
    }
  }

  static Future<Carro?> buscarPorID(String idCarro) async {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await db
          .collection('users')
          .doc(uid)
          .collection('carros')
          .doc(idCarro)
          .get();

      if (doc.exists) {
        return Carro.fromMap(doc.data()!..["id"] = doc.id);
      } else {
        print("Carro com ID $idCarro não encontrado.");
        return null;
      }
    } catch (e) {
      print("Erro ao buscar carro: $e");
      return null;
    }
  }

  
  static Future<void> atualizarUltimoKmEConsumo(String idCarro, int ultimoKm, double consumo) async {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }
    try {
      await db
        .collection('users')
        .doc(uid)
        .collection('carros')
        .doc(idCarro)
        .update({
          "ultimoKm": ultimoKm,
          "consumo": consumo,
      });
      print("Campos 'ultimoKm' e 'consumo' atualizados com sucesso!");
    } catch (e) {
      print("Erro ao atualizar campos: $e");
    }
  }

  static Stream<List<Carro>> getTodosOsCarros() {
  return FirebaseFirestore.instance
      .collectionGroup('carros') 
      .snapshots()
      .map((QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return Carro.fromMap(doc.data() as Map<String, dynamic>)
        ..id = doc.id; 
    }).toList();
  });
}

  
}