import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AutenticacaoFirebase {
  Future<String> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Usuário autenticado: ${userCredential.user!.uid}";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Usuário não encontrado";
      } else if (e.code == 'wrong-password') {
        return "Senha incorreta";
      }
      return "Erro de autenticação";
    }
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return "Usuário autenticado com Google";
    } else {
      return "Erro ao autenticar com Google";
    }
  }

  Future<String> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://sua-api.com/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String token = data['token'];
      // Salve o token em um armazenamento seguro
      return "Autenticação bem-sucedida, token: $token";
    } else {
      return "Erro de autenticação";
    }
  }

  Future<String> registerWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Usuário registrado com sucesso: ${userCredential.user!.uid}";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "A senha é muito fraca.";
      } else if (e.code == 'email-already-in-use') {
        return "A conta já existe para esse email.";
      }
      return "Erro de registro";
    } catch (e) {
      return "Erro: $e";
    }
  }

  Future<String> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn()
          .signOut(); // Se o usuário tiver feito login com Google, faça logout
      return "Usuário desconectado com sucesso";
    } catch (e) {
      return "Erro ao desconectar: $e";
    }
  }

  Future<bool> isUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user !=
        null; // Retorna true se o usuário estiver logado, caso contrário, false
  }

  Future<void> salvarDadosDoUsuario(Map<String, dynamic> dados) async {
   try {
      User? usuario = FirebaseAuth.instance.currentUser; // Usuário autenticado

      if (usuario != null) {
        String uid = usuario.uid; // UID único do usuário
        await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(dados, SetOptions(merge: true)); // Salva os dados
        print("Dados salvos com sucesso!");
      } else {
        print("Usuário não autenticado.");
      }
    } catch (e) {
      print("Erro ao salvar dados: $e");
    }
  }

  Future<Map<String, dynamic>?> buscarDadosDoUsuario() async {
    try {
      User? usuario = FirebaseAuth.instance.currentUser;

      if (usuario != null) {
        String uid = usuario.uid;
        DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        } else {
          print("Documento não encontrado.");
          return null;
        }
      } else {
        print("Usuário não autenticado.");
        return null;
      }
    } catch (e) {
      print("Erro ao buscar dados: $e");
      return null;
    }
  }

  void atualizarPerfil(String novoNome) async {
    await salvarDadosDoUsuario({
      "nome": novoNome, // Atualiza apenas o campo 'nome'
    });

    print("Perfil atualizado!");
  }

}
