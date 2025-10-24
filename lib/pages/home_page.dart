import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../domain/usuario.dart';
import '../domain/agenda_item.dart';
import '../widgets/welcome_card.dart';
import '../widgets/action_card.dart';
import '../widgets/schedule_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  Usuario? usuario;
  List<AgendaItem> agendaItems = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    try {
      final dbHelper = DatabaseHelper();
      final loadedUsuario = await dbHelper.getUsuario();
      final loadedItems = await dbHelper.getAgendaItems();
      
      setState(() {
        usuario = loadedUsuario;
        agendaItems = loadedItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: buildAppBar(),
        body: isLoading ? buildLoading() : buildBody(),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }
  
  Widget buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF4A90E2)),
          SizedBox(height: 16),
          Text(
            'Carregando dados...',
            style: TextStyle(color: Color(0xFF7F8C8D)),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF4A90E2),
      title: const Text(
        'RespiraBem',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: const [
        Icon(Icons.notifications, color: Colors.white),
        SizedBox(width: 16),
      ],
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          WelcomeCard(usuario: usuario),
          const SizedBox(height: 20),
          buildQuickActionsTitle(),
          const SizedBox(height: 16),
          buildQuickActionsGrid(),
          const SizedBox(height: 24),
          buildTodayScheduleTitle(),
          const SizedBox(height: 16),
          buildTodaySchedule(),
        ],
      ),
    );
  }

  Widget buildQuickActionsTitle() {
    return const Text(
      'Ações Rápidas',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget buildQuickActionsGrid() {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Sintomas',
                icon: Icons.health_and_safety,
                color: Color(0xFF27AE60),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ActionCard(
                title: 'Medicamentos',
                icon: Icons.medication,
                color: Color(0xFFE74C3C),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Dicas de Saúde',
                icon: Icons.lightbulb,
                color: Color(0xFFF39C12),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ActionCard(
                title: 'Consultas',
                icon: Icons.calendar_today,
                color: Color(0xFF9B59B6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTodayScheduleTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Agenda de Hoje',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        Text(
          '${agendaItems.length} itens',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF7F8C8D),
          ),
        ),
      ],
    );
  }

  Widget buildTodaySchedule() {
    if (agendaItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Nenhum item na agenda hoje',
            style: TextStyle(color: Color(0xFF7F8C8D)),
          ),
        ),
      );
    }
    
    List<Widget> scheduleWidgets = [];
    for (int i = 0; i < agendaItems.length; i++) {
      scheduleWidgets.add(ScheduleItem(item: agendaItems[i]));
      if (i < agendaItems.length - 1) {
        scheduleWidgets.add(const Divider(indent: 60, endIndent: 20));
      }
    }
    
    return Column(children: scheduleWidgets);
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF4A90E2),
      unselectedItemColor: const Color(0xFF7F8C8D),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety),
          label: 'Sintomas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medication),
          label: 'Remédios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}