import 'dart:ffi';

class Produto{
  String nome;
  Float preco;
  Produto({required this.preco, required this.nome});

  Map<String, dynamic> get toMap =>
    <String, dynamic>{"nome": nome, "preco": preco};
}