import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class Usuario {
  int? id;
  String nome;
  
  Usuario({this.id, required this.nome});
  
  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }
  
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(id: map['id'], nome: map['nome']);
  }
}

class AgendaItem {
  int? id;
  String tipo;
  String hora;
  String descricao;
  String icone;
  
  AgendaItem({this.id, required this.tipo, required this.hora, required this.descricao, required this.icone});
  
  Map<String, dynamic> toMap() {
    return {'id': id, 'tipo': tipo, 'hora': hora, 'descricao': descricao, 'icone': icone};
  }
  
  factory AgendaItem.fromMap(Map<String, dynamic> map) {
    return AgendaItem(
      id: map['id'], 
      tipo: map['tipo'], 
      hora: map['hora'], 
      descricao: map['descricao'],
      icone: map['icone']
    );
  }
}


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'respirabem.db');
    await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE agenda_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        hora TEXT NOT NULL,
        descricao TEXT NOT NULL,
        icone TEXT NOT NULL
      )
    ''');
    
    
    await db.insert('usuarios', {'nome': 'isaac'});
    await db.insert('agenda_items', {'tipo': 'Medicamento', 'hora': '09:00', 'descricao': 'Tomar remédio para dores', 'icone': 'medication'});
    await db.insert('agenda_items', {'tipo': 'Exercício', 'hora': '14:00', 'descricao': 'Caminhada leve - 15 min', 'icone': 'directions_walk'});
    await db.insert('agenda_items', {'tipo': 'Hidratação', 'hora': '16:00', 'descricao': 'Lembrete para beber água', 'icone': 'water_drop'});
  }
  
  Future<Usuario?> getUsuario() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios', limit: 1);
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }
  
  Future<List<AgendaItem>> getAgendaItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('agenda_items', orderBy: 'hora ASC');
    return List.generate(maps.length, (i) => AgendaItem.fromMap(maps[i]));
  }
  Future<int> insertAgendaItem(AgendaItem item) async {
    final db = await database;
    return await db.insert('agenda_items', item.toMap());
  }
  Future<void> updateUsuario(Usuario usuario) async {
    final db = await database;
    await db.update('usuarios', usuario.toMap(), where: 'id = ?', whereArgs: [usuario.id]);
  }
}

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
          Text('Carregando dados...', style: TextStyle(color: Color(0xFF7F8C8D))),
        ],
      ),
    );
  }

  buildAppBar() {
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

  buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          buildWelcomeCard(),
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

  buildWelcomeCard() {
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

  buildQuickActionsTitle() {
    return const Text(
      'Ações Rápidas',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  buildQuickActionsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: buildActionCard('Sintomas', Icons.health_and_safety, const Color(0xFF27AE60))),
            const SizedBox(width: 12),
            Expanded(child: buildActionCard('Medicamentos', Icons.medication, const Color(0xFFE74C3C))),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: buildActionCard('Dicas de Saúde', Icons.lightbulb, const Color(0xFFF39C12))),
            const SizedBox(width: 12),
            Expanded(child: buildActionCard('Consultas', Icons.calendar_today, const Color(0xFF9B59B6))),
          ],
        ),
      ],
    );
  }

  buildActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  buildTodayScheduleTitle() {
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

  buildTodaySchedule() {
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
      scheduleWidgets.add(buildScheduleItem(agendaItems[i]));
      if (i < agendaItems.length - 1) {
        scheduleWidgets.add(const Divider(indent: 60, endIndent: 20));
      }
    }
    
    return Column(children: scheduleWidgets);
  }

  buildScheduleItem(AgendaItem item) {
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
                  style: const TextStyle(fontSize: 13, color: Color(0xFF7F8C8D)),
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

  buildBottomNavigationBar() {
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
        BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Sintomas'),
        BottomNavigationBarItem(icon: Icon(Icons.medication), label: 'Remédios'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}