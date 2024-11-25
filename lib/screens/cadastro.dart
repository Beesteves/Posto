
import 'package:flutter/material.dart';
import '../controllers/carroController.dart';
import '../models/carro.dart';

class Cadastro extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    TextEditingController nomeController = TextEditingController();
    TextEditingController modeloController = TextEditingController();
    TextEditingController placaController = TextEditingController();
    TextEditingController anoController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Carro')),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Nome:'),
            controller: nomeController,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Modelo'),
            controller: modeloController,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Placa'),
            controller: placaController,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Ano'),
            controller: anoController,
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
              onPressed: () {
                Carro novoCarro = Carro(
                  nome: nomeController.text,
                  modelo: modeloController.text,
                  placa: placaController.text,
                  ano: int.parse(anoController.text),
                  ultimoKm: 0,
                  consumo: 0,
                );

                DaoCarro.salvarAutoID(novoCarro);

                Navigator.pop(context);
              },
              child: const Text('Salvar'))
        ],
      ),
    );
  }
}
