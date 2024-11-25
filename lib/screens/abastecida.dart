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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown para selecionar o carro
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

                  // Reseta o carro selecionado se ele não estiver na lista atual
                  if (carroSelecionado != null &&
                      !snapshot.data!.any((carro) => carro.id == carroSelecionado!.id)) {
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
              // Campos de entrada para abastecimento
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
              const SizedBox(height: 20),
              // Botão para salvar o abastecimento
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
                      data: DateTime.now(), // Use a data atual
                    );

                    DaoAbastecimento.salvarAutoID(novoAbastecimento);
                    DaoAbastecimento.calculaConsumo(novoAbastecimento);

                    // Limpa os campos após salvar
                    litrosController.clear();
                    kmController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Abastecimento salvo com sucesso!")),
                    );
                  } catch (e) {
                    print("Erro ao salvar abastecimento: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erro ao salvar abastecimento")),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 20),
              const Text(
                "Histórico de Abastecimentos",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Histórico de abastecimentos
              if (carroSelecionado != null)
                StreamBuilder<List<Abastecimento>>(
                  stream: DaoAbastecimento.getAbastecimentos(carroSelecionado!.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text("Erro ao carregar histórico: ${snapshot.error}");
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("Nenhum abastecimento registrado para este carro.");
                    }

                    final abastecimentos = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: abastecimentos.length,
                      itemBuilder: (context, index) {
                        final abastecimento = abastecimentos[index];
                        return ListTile(
                          title: Text("Litros: ${abastecimento.litros}"),
                          subtitle: Text(
                            "Km: ${abastecimento.km}\nData: ${abastecimento.data.toString()}",
                          ),
                        );
                      },
                    );
                  },
                )
              else
                const Text("Selecione um carro para ver o histórico de abastecimentos."),
            ],
          ),
        ),
      ),
    );
  }
}
