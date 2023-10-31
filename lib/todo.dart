class Todo {
  int? id;
  String nama;
  String deksripsi;
  bool checkmark;

  Todo(this.nama, this.deksripsi, {this.checkmark=false, this.id});

  // Trial
  static List<Todo> dummyData = [
    Todo("Minum Kopi", "Minum Kopi terus nyantai"),
    Todo("Makan Sarapan", "Perut isi tenaga full beraktifitas", checkmark: true),
    Todo("Jalan-jalan", "Pergi jalan-jalan sekitar Temabalang"),
  ];

  // Map sesuai variabel database
  Map<String, dynamic> mapDatabase() {
    return <String, dynamic> {
      'id': id,
      'nama': nama,
      'deskripsi': deksripsi,
      'checkmark': checkmark,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      map['nama'] as String,
      map['deskrip'] as String,
      checkmark: map['checkmark'] == 0 ? false : true,
      id: map['id'],
    );
  }
}