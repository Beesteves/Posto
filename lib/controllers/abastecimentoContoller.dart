import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../models/abastecimento.dart';
import '../models/carro.dart';
import 'carroController.dart';

class DaoAbastecimento {
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

  static Future<void> salvarAutoID(Abastecimento a) async {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }
    try {
      await db
          .collection("users")
          .doc(uid)
          .collection("carros")
          .doc(a.carro)
          .collection("abastecimentos")
          .add(a.toMap);
      print("Abastecimento salvo com sucesso!");
    } catch (error) {
      print("Erro ao salvar abastecimento: $error");
    }
  }

  static Stream<List<Abastecimento>> getAbastecimentos(String carroId) {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }
    return db
        .collection("users")
        .doc(uid)
        .collection("carros")
        .doc(carroId)
        .collection("abastecimentos")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Abastecimento.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id; // 
      }).toList();
    });
  }

  // Remove um abastecimento
  static Future<void> remover(Abastecimento a) async {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }

    try {
      await db
          .collection("users")
          .doc(uid)
          .collection("carros")
          .doc(a.carro)
          .collection("abastecimentos")
          .doc(a.id)
          .delete();
      print("Abastecimento removido com sucesso!");
    } catch (error) {
      print("Erro ao remover abastecimento: $error");
    }
  }

  // Edita um abastecimento
  static Future<void> editar(Abastecimento a) async {
    String? uid = _getUid();
    if (uid == null) {
      throw Exception("Usuário não autenticado.");
    }

    try {
      await db
          .collection("users")
          .doc(uid)
          .collection("carros")
          .doc(a.carro)
          .collection("abastecimentos")
          .doc(a.id)
          .update(a.toMap);
      print("Abastecimento atualizado com sucesso!");
    } catch (error) {
      print("Erro ao editar abastecimento: $error");
    }
  }

  // // Função para buscar clientes do Firestore
  // static Stream<List<Abastecimento>> getAbasteciemnto() {
  //   return FirebaseFirestore.instance.collection('abastecimento').snapshots().map(
  //     (snapshot) {
  //       return snapshot.docs.map((doc) {
  //         return Abastecimento(
  //           carro: doc['carro'],
  //           litros: doc['litros'],
  //           km: doc['km'],
  //           data: doc['data'],
  //         );
  //       }).toList();
  //     },
  //   );
  // }

   

  static Future<void> calculaConsumo(Abastecimento a) async {
    final String? idCarro = a.carro;

    if (idCarro == null) {
      throw ArgumentError("ID do carro não pode ser nulo.");
    }

    Carro? c = await DaoCarro.buscarPorID(idCarro);

    if (c == null) {
      throw Exception("Carro não encontrado para o ID: $idCarro");
    }

    double consumo = (a.km - c.ultimoKm) / a.litros;

    await DaoCarro.atualizarUltimoKmEConsumo(idCarro, a.km, consumo);
  }

}