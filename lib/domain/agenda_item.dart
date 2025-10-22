class AgendaItem {
  int? id;
  String tipo;
  String hora;
  String descricao;
  String icone;
  
  AgendaItem({
    this.id, 
    required this.tipo, 
    required this.hora, 
    required this.descricao, 
    required this.icone,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'tipo': tipo, 
      'hora': hora, 
      'descricao': descricao, 
      'icone': icone,
    };
  }
  
  factory AgendaItem.fromMap(Map<String, dynamic> map) {
    return AgendaItem(
      id: map['id'], 
      tipo: map['tipo'], 
      hora: map['hora'], 
      descricao: map['descricao'],
      icone: map['icone'],
    );
  }
}