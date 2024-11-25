import 'package:aula04/autenticacaoFirebase.dart';
import 'package:aula04/login.dart';
import 'package:aula04/screens/abastecida.dart';
import 'package:aula04/screens/cadastro.dart';
import 'package:aula04/screens/meuCarro.dart';
import 'package:flutter/material.dart';
import '../controllers/carroController.dart';
import '../models/carro.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Veículos Cadastrados')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Inicio'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp())),
            ),
            ListTile(
              title: Text('Meus veiculos'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Meucarro())),
            ),
            ListTile(
              title: Text('Adicionar Veículo'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro())),
            ),
            ListTile(
              title: Text('Histórico de Abastecimentos'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Abastecida())),
            ),
            ListTile(
              title: Text('Perfil'),
              onTap: () => Navigator.pushNamed(context, '/perfil'),
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                AutenticacaoFirebase aut = AutenticacaoFirebase();
                aut.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: StreamBuilder<List<Carro>>(
          stream: DaoCarro.getTodosOsCarros(),
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
