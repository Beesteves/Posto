import 'package:flutter/material.dart';
import '../controllers/carroController.dart';
import '../models/carro.dart';


class Meucarro extends StatelessWidget {
  const Meucarro({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Meus Veículos')),
      body: Center(
        child: StreamBuilder<List<Carro>>(
          stream: DaoCarro.getCarro(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Erro ao carregar dados');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Nenhum carro encontrado');
            } else {
              final carros = snapshot.data!;
              return ListView.builder(
                itemCount: carros.length,
                itemBuilder: (context, index) {
                final carro = carros[index];
                  return ListTile(
                    title: Text(carro.nome),
                    subtitle: Text('Modelo: ${carro.modelo} ${carro.ano}\nPlaca: ${carro.placa}\nConsumo médio: ${carro.consumo}'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
