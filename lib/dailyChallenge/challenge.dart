

class Challenge {
  String id;
  String name;
  String category;
  int randIndex;

  Challenge({this.id, this.name, this.category, this.randIndex});

  Challenge.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    category = data['category'];
    randIndex = data['randIndex'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'randIndex' : randIndex,
    };
  }
}