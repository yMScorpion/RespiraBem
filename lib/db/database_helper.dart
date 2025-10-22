import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/usuario.dart';
import '../domain/agenda_item.dart';

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
        nome TEXT NOT NULL,
        email TEXT,
        cidade TEXT
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
    
    // Dados iniciais
    await db.insert('usuarios', {
      'nome': 'Isaac',
      'email': 'isaac@respirabem.com',
      'cidade': 'Maceió'
    });
    
    await db.insert('agenda_items', {
      'tipo': 'Medicamento',
      'hora': '09:00',
      'descricao': 'Tomar remédio para dores',
      'icone': 'medication'
    });
    
    await db.insert('agenda_items', {
      'tipo': 'Exercício',
      'hora': '14:00',
      'descricao': 'Caminhada leve - 15 min',
      'icone': 'directions_walk'
    });
    
    await db.insert('agenda_items', {
      'tipo': 'Hidratação',
      'hora': '16:00',
      'descricao': 'Lembrete para beber água',
      'icone': 'water_drop'
    });
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
    final List<Map<String, dynamic>> maps = await db.query(
      'agenda_items',
      orderBy: 'hora ASC'
    );
    return List.generate(maps.length, (i) => AgendaItem.fromMap(maps[i]));
  }
  
  Future<int> insertAgendaItem(AgendaItem item) async {
    final db = await database;
    return await db.insert('agenda_items', item.toMap());
  }
  
  Future<void> updateUsuario(Usuario usuario) async {
    final db = await database;
    await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id]
    );
  }
  
  Future<void> insertUsuario(Usuario usuario) async {
    final db = await database;
    await db.insert('usuarios', usuario.toMap());
  }
  
  Future<void> clearUsuarios() async {
    final db = await database;
    await db.delete('usuarios');
  }
}