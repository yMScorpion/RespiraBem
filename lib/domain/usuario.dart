class Usuario {
  int? id;
  String nome;
  String? email;
  String? cidade;
  
  Usuario({
    this.id, 
    required this.nome,
    this.email,
    this.cidade,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'nome': nome,
      'email': email,
      'cidade': cidade,
    };
  }
  
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'], 
      nome: map['nome'],
      email: map['email'],
      cidade: map['cidade'],
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      cidade: json['cidade'] ?? json['city'] ?? '',
    );
  }
}