import 'package:aula04/autenticacaoFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});


  @override
  State<Perfil> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<Perfil> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    setState(() {
      _isLoading = true;
    });

    User? u = FirebaseAuth.instance.currentUser;

    if (u != null) {
      _nomeController.text = u.displayName ?? "";
      _emailController.text = u.email ?? "";
      _telefoneController.text = u.phoneNumber ?? "";
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _salvarPerfil() async {
    AutenticacaoFirebase.atualizarPerfil(_nomeController.text, _telefoneController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil salvo com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meu Perfil")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: "Nome"),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(labelText: "Telefone"),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _salvarPerfil,
                    child: const Text("Salvar"),
                  ),
                ],
              ),
            ),
    );
  }
}

