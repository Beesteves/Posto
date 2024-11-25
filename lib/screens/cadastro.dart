
import 'package:flutter/material.dart';
//import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../controllers/carroController.dart';
import '../models/carro.dart';

class Cadastro extends StatelessWidget {
  // final DaoCarro c;

  // const Cadastro(
  //   {super.key, required this.c}); // Recebe o controlador como argumento
// // Função para validar o email
//   bool _isEmailValid(String email) {
//     final RegExp emailRegex = RegExp(
//       r'^[^@]+@[^@]+\.[^@]+',
//     );
//     return emailRegex.hasMatch(email);
//   }

//   // Função para validar o telefone
//   bool _isTelefoneValid(String phone) {
//     final RegExp phoneRegex = RegExp(r'^\(\d{2}\) \d{4,5}-\d{4}$');
//     return phoneRegex.hasMatch(phone);
//   }

  @override
  Widget build(BuildContext context) {
    TextEditingController nomeController = TextEditingController();
    TextEditingController modeloController = TextEditingController();
    TextEditingController placaController = TextEditingController();
    TextEditingController anoController = TextEditingController();
    //MaskedTextController placaController = MaskedTextController(mask: '(00) 00000-0000');
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
                // Validação do e-mail
                // if (!_isEmailValid(emailController.text)) {
                //   // Exibe um alerta se o email for inválido
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //         content: Text('Por favor, insira um e-mail válido.')),
                //   );
                //   return; // Sai da função se o e-mail não for válido
                // }

                // Criação da nova pessoa
                Carro novoCarro = Carro(
                  nome: nomeController.text,
                  modelo: modeloController.text,
                  placa: placaController.text,
                  ano: int.parse(anoController.text),
                  ultimoKm: 0,
                  consumo: 0,
                );

                // Adiciona a nova pessoa ao controlador
                DaoCarro.salvarAutoID(novoCarro);

                Navigator.pop(context);
              },
              child: const Text('Salvar'))
        ],
      ),
    );
  }
}
