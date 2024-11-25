import 'package:cloud_firestore/cloud_firestore.dart';
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

  static void salvarAutoID(Abastecimento a) {
    db.collection("abastecimento").add(a.toMap).catchError(
          // ignore: invalid_return_type_for_catch_error
          (error) => print("deu ruim: $error"),
        );
  }

  // Função para buscar clientes do Firestore
  static Stream<List<Abastecimento>> getAbasteciemnto() {
    return FirebaseFirestore.instance.collection('abastecimento').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Abastecimento(
            carro: doc['carro'],
            litros: doc['litros'],
            km: doc['km'],
            data: doc['data'],
          );
        }).toList();
      },
    );
  }

  static void remover(int _counter) {
    db.collection("abastecimento").doc("abastecimento$_counter").delete().then((_) {
      print("Documento removido com sucesso!");
    }).catchError((error) {
      print("Erro ao remover documento: $error");
    });
  }

  static void editar(Abastecimento a, int _counter) {
    db.collection("abastecimento").doc("abastecimento$_counter").update(a.toMap).then((_) {
      print("Documento atualizado com sucesso!");
    }).catchError((error) {
      print("Erro ao atualizar documento: $error");
    });
  }

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