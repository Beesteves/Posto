import 'package:flutter/material.dart';
import '../models/carro.dart';
import '../controllers/carroController.dart';

class EditarCarro extends StatefulWidget {
  final Carro carro;

  const EditarCarro({required this.carro, Key? key}) : super(key: key);

  @override
  State<EditarCarro> createState() => _EditarCarroScreenState();
}

class _EditarCarroScreenState extends State<EditarCarro> {
  late TextEditingController _nomeController;
  late TextEditingController _modeloController;
  late TextEditingController _anoController;
  late TextEditingController _placaController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.carro.nome);
    _modeloController = TextEditingController(text: widget.carro.modelo);
    _anoController = TextEditingController(text: widget.carro.ano.toString());
    _placaController = TextEditingController(text: widget.carro.placa);
  }



  Future<void> _salvar() async {
    final atualizado = Carro(
      id: widget.carro.id,
      nome: _nomeController.text,
      modelo: _modeloController.text,
      ano: int.tryParse(_anoController.text) ?? widget.carro.ano,
      placa: _placaController.text,
      ultimoKm: widget.carro.ultimoKm,
      consumo: widget.carro.consumo,
    );

    await DaoCarro.editar(atualizado);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Carro atualizado com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Carro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _modeloController,
              decoration: const InputDecoration(labelText: "Modelo"),
            ),
            TextField(
              controller: _anoController,
              decoration: const InputDecoration(labelText: "Ano"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _placaController,
              decoration: const InputDecoration(labelText: "Placa"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
