class Recipe {
  final String id;
  final String title;
  final String description;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'ingredients': ingredients,
    };
  }
}
