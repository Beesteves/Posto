class Carro {
  String? id;  
  String nome;
  String modelo;
  int ano;
  String placa;
  int ultimoKm;
  double? consumo;

  Carro({this.id, required this.nome, required this.modelo, required this.ano, required this.placa, required this.ultimoKm, this.consumo});

 // Sobrescrevendo o operador '==' para comparar pelo 'id'
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Carro && other.id == id;
  }

  // Sobrescrevendo o 'hashCode' para garantir consistência com '=='
  @override
  int get hashCode => id.hashCode;


  Map<String, dynamic> get toMap {
  return {
    if (id != null) "id": id, // Inclui o ID apenas se não for nulo
    "nome": nome,
    "modelo": modelo,
    "ano": ano,
    "placa": placa,
    "ultimoKM": ultimoKm,
    "consumo": consumo,
  };
}

  factory Carro.fromMap(Map<String, dynamic> map) {
  return Carro(
    id: map['id'] as String?,
    nome: map['nome'] as String,
    modelo: map['modelo'] as String,
    ano: map['ano'] as int,
    placa: map['placa'] as String,
    ultimoKm: map['ultimoKM'] as int,
    consumo: map['consumo'] != null ? map['consumo'].toDouble() : null,
  );
}
}
