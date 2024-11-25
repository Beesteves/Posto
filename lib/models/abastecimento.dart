import 'package:cloud_firestore/cloud_firestore.dart';

class Abastecimento{
    String? id;
    String ?carro;
    double litros;
    int km;
    DateTime data;
    Abastecimento({this.id, this.carro, required this.litros, required this.km, required this.data});

    @override
    bool operator ==(Object other) {
      if (identical(this, other)) return true;
      return other is Abastecimento && other.id == id;
    }

  // Sobrescrevendo o 'hashCode' para garantir consistência com '=='
    @override
    int get hashCode => id.hashCode;

    Map<String, dynamic> get toMap{return{
      if (id != null) "id": id,
      "carro": carro, 
      "litros": litros, 
      "km": km, 
      "data": data
      };
    }

    
    factory Abastecimento.fromMap(Map<String, dynamic> map) {
      return Abastecimento(
        id: map['id'] as String?,
        carro: map['carro'] as String?,
        litros: map['litros'] as double,
        km: map['km'] as int,
        data: (map['data'] as Timestamp).toDate(),
      );
    }

}