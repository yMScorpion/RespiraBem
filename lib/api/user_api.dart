import 'package:http/http.dart' as http;
import 'dart:convert';
import '../domain/usuario.dart';

class UserApi {
  // URL da API fake - ajuste para seu repositório
  final String baseUrl =
      'https://my-json-server.typicode.com/tarsisms/fake-api';

  Future<List<Usuario>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Usuario.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar usuários');
      }
    } catch (e) {
      throw Exception('Erro ao buscar usuários: $e');
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      final users = await getUsers();

      // Verifica se existe um usuário com o email e senha fornecidos
      final user = users.firstWhere(
        (u) => u.email?.toLowerCase() == email.toLowerCase(),
        orElse: () => Usuario(nome: ''),
      );

      // Na API fake, vamos apenas verificar se o usuário existe
      // Em produção, você validaria a senha também
      return user.nome.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Usuario?> getUserByEmail(String email) async {
    try {
      final users = await getUsers();
      return users.firstWhere(
        (u) => u.email?.toLowerCase() == email.toLowerCase(),
        orElse: () => Usuario(nome: ''),
      );
    } catch (e) {
      return null;
    }
  }
}
