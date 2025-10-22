import 'package:flutter/material.dart';
import '../domain/usuario.dart';

class WelcomeCard extends StatelessWidget {
  final Usuario? usuario;
  
  const WelcomeCard({super.key, this.usuario});

  @override
  Widget build(BuildContext context) {
    String nomeUsuario = usuario?.nome ?? 'Usuário';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF4A90E2),
                child: Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, $nomeUsuario!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const Text(
                    'Como você está se sentindo hoje?',
                    style: TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F4FD),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: const Row(
              children: [
                Icon(Icons.favorite, color: Color(0xFF4A90E2), size: 20),
                SizedBox(width: 8),
                Text(
                  'Lembre-se: cada dia é uma vitória!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A90E2),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}