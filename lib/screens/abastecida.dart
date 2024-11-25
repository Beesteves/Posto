import 'package:flutter/material.dart';
import '../controllers/carroController.dart';
import '../models/carro.dart';
import '../controllers/abastecimentoContoller.dart';
import '../models/abastecimento.dart';

class Abastecida extends StatefulWidget {
  @override
  _AbastecidaState createState() => _AbastecidaState();
}

class _AbastecidaState extends State<Abastecida> {
  TextEditingController litrosController = TextEditingController();
  TextEditingController kmController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  Carro? carroSelecionado; // Carro atualmente selecionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Abastecimento')),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StreamBuilder<List<Carro>>(
                stream: DaoCarro.getCarro(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("Erro ao carregar carros: ${snapshot.error}");
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("Nenhum carro encontrado.");
                  }

                  final carros = snapshot.data!;

                  if (carroSelecionado != null && !snapshot.data!.any((carro) => carro.id == carroSelecionado!.id)) {
                    carroSelecionado = null;
                  }

                  return DropdownButton<Carro>(
                    value: carroSelecionado,
                    hint: const Text("Selecione o carro"),
                    items: carros.map((carro) {
                      return DropdownMenuItem<Carro>(
                        value: carro,
                        child: Text(carro.nome),
                      );
                    }).toList(),

                    onChanged: (novoCarro) {
                      setState(() {
                        carroSelecionado = novoCarro;
                      });
                    },
                  );
                },
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Litros abastecidos'),
                controller: litrosController,
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Kilometragem'),
                controller: kmController,
                keyboardType: TextInputType.number,
              ),
              // TextField(
              //   decoration: const InputDecoration(hintText: 'Data do abastecimento'),
              //   controller: dataController,
              //   keyboardType: TextInputType.datetime,
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (carroSelecionado == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Selecione um carro!")),
                    );
                    return;
                  }

                  try {
                    Abastecimento novoAbastecimento = Abastecimento(
                      carro: carroSelecionado!.id, 
                      litros: double.parse(litrosController.text),
                      km: int.parse(kmController.text),
                      data: DateTime.now(),//parse(dataController.text),
                    );

                    DaoAbastecimento.salvarAutoID(novoAbastecimento);
                    DaoAbastecimento.calculaConsumo(novoAbastecimento);

                    Navigator.pop(context);
                  } catch (e) {
                    print("Erro ao salvar abastecimento: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erro ao salvar abastecimento")),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
