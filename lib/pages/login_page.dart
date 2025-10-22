import 'package:flutter/material.dart';
import '../api/weather_api.dart';
import '../api/user_api.dart';
import '../domain/weather.dart';
import '../domain/usuario.dart';
import '../db/database_helper.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  late Future<Weather> weatherFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    weatherFuture = WeatherApi().getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    buildHeader(),
                    const SizedBox(height: 40),
                    buildLoginForm(),
                    const SizedBox(height: 24),
                    buildLoginButton(),
                    const SizedBox(height: 16),
                    buildInfoText(),
                  ],
                ),
              ),
            ),
            buildWeatherWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF4A90E2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.health_and_safety,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'RespiraBem',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Cuidando da sua saúde respiratória',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7F8C8D),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Entre na sua conta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'seu@email.com',
              prefixIcon: const Icon(Icons.email, color: Color(0xFF4A90E2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF4A90E2), width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: senhaController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: '••••••••',
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF4A90E2)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF4A90E2), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A90E2),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      onPressed: isLoading ? null : handleLogin,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Entrar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );
  }

  Widget buildInfoText() {
    return const Center(
      child: Text(
        'Use: joao@gmail.com / 123456',
        style: TextStyle(
          fontSize: 12,
          color: Color(0xFF7F8C8D),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget buildWeatherWidget() {
    return Positioned(
      top: 16,
      right: 16,
      child: FutureBuilder<Weather>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                ),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final weather = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wb_sunny,
                      color: Color(0xFF4A90E2),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  weather.city,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      showMessage('Por favor, preencha todos os campos');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Tenta fazer login usando a API fake
      final userApi = UserApi();
      final success = await userApi.login(email, senha);

      if (success) {
        // Busca dados completos do usuário
        final usuario = await userApi.getUserByEmail(email);

        if (usuario != null && usuario.nome.isNotEmpty) {
          // Salva usuário no banco local
          final db = DatabaseHelper();
          await db.clearUsuarios();
          await db.insertUsuario(usuario);

          // Navega para a home
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        } else {
          showMessage('Email ou senha incorretos');
        }
      } else {
        showMessage('Email ou senha incorretos');
      }
    } catch (e) {
      showMessage('Erro ao fazer login: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFE74C3C),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
