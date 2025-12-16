import 'package:http/http.dart' as http;
import 'dart:convert';
import '../domain/usuario.dart';

class UserApi {
  // URL da API fake
  final String baseUrl =
      'https://my-json-server.typicode.com/yMScorpion/apifake';

  Future<List<Usuario>> getUsers() async {
    try {
      print('Tentando buscar usuários em: $baseUrl/users');

      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        // Verifica se é uma lista
        if (data is List) {
          return data.map((json) => Usuario.fromJson(json)).toList();
        } else {
          throw Exception('Resposta da API não é uma lista');
        }
      } else {
        throw Exception(
            'Falha ao carregar usuários. Status: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('Erro de cliente HTTP: $e');
      throw Exception('Erro de conexão: Verifique sua internet');
    } on FormatException catch (e) {
      print('Erro ao decodificar JSON: $e');
      throw Exception('Erro ao processar dados do servidor');
    } catch (e) {
      print('Erro geral: $e');
      throw Exception('Erro ao buscar usuários: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String senha) async {
    try {
      print('Iniciando login para: $email');

      final users = await getUsers();

      print('Usuários encontrados: ${users.length}');

      // Busca o usuário pelo email
      Usuario? foundUser;
      for (var user in users) {
        print('Comparando: ${user.email} com $email');
        if (user.email?.toLowerCase() == email.toLowerCase()) {
          foundUser = user;
          break;
        }
      }

      // Se não encontrou o usuário
      if (foundUser == null) {
        print('Usuário não encontrado');
        return {
          'success': false,
          'message': 'Email não encontrado',
          'user': null,
        };
      }

      print('Usuário encontrado: ${foundUser.nome}');

      // Validação de senha
      final senhaApi = foundUser.senha ?? '';

      print('Comparando senhas...');

      if (senhaApi.isEmpty) {
        print('Senha vazia na API, aceitando qualquer senha');
        return {
          'success': true,
          'message': 'Login realizado com sucesso',
          'user': foundUser,
        };
      }

      if (senhaApi == senha) {
        print('Login bem-sucedido!');
        return {
          'success': true,
          'message': 'Login realizado com sucesso',
          'user': foundUser,
        };
      } else {
        print('Senha incorreta');
        return {
          'success': false,
          'message': 'Senha incorreta',
          'user': null,
        };
      }
    } catch (e) {
      print('Erro no login: $e');
      return {
        'success': false,
        'message': 'Erro ao conectar: ${e.toString()}',
        'user': null,
      };
    }
  }

  Future<Usuario?> getUserByEmail(String email) async {
    try {
      final users = await getUsers();
      for (var user in users) {
        if (user.email?.toLowerCase() == email.toLowerCase()) {
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Erro ao buscar usuário por email: $e');
      return null;
    }
  }
}
