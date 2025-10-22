import 'package:flutter/material.dart';
import '../domain/agenda_item.dart';

class ScheduleItem extends StatelessWidget {
  final AgendaItem item;
  
  const ScheduleItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    IconData iconData = _getIconFromString(item.icone);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Icon(iconData, color: const Color(0xFF4A90E2), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.tipo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.hora,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7F8C8D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.descricao,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7F8C8D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'medication':
        return Icons.medication;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'water_drop':
        return Icons.water_drop;
      default:
        return Icons.schedule;
    }
  }
}