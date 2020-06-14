

class Challenge {

  String id;
  String name;
  String category;
  String searchKey;
  

  Challenge({this.id, this.name, this.category, this.searchKey});

  // Do class challenge with uid

  Challenge.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    category = data['category'];
    searchKey = data['searchKey'];
  }

  Challenge.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    category = data['category'];
    searchKey = data['searchKey'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'searchKey': searchKey,
      
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'searchKey': searchKey,
    };
  }
}