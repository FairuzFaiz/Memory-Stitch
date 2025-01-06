class Memory {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String mood;
  final List<String> images;
  final String template;

  Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.mood,
    required this.images,
    required this.template,
  });
}
