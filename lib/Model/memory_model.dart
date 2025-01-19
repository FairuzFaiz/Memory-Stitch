class MemoryModel {
  final String id;
  late final String judul;
  late final String desc1;
  final String desc2;
  final String desc3;
  final String pict1;
  final String pict2;
  final String pict3;
  final String tanggal;
  final String template;

  MemoryModel({
    required this.id,
    required this.judul,
    required this.desc1,
    required this.desc2,
    required this.desc3,
    required this.pict1,
    required this.pict2,
    required this.pict3,
    required this.tanggal,
    required this.template,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['_id'] ?? '',
      judul: json['judul'] ?? '',
      desc1: json['desc1'] ?? '',
      desc2: json['desc2'] ?? '',
      desc3: json['desc3'] ?? '',
      pict1: json['pict1'] ?? '',
      pict2: json['pict2'] ?? '',
      pict3: json['pict3'] ?? '',
      tanggal: json['tanggal'] ?? '',
      template: json['template'] ?? '',
    );
  }
}
