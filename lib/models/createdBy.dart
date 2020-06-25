class CreatedBy {
    CreatedBy({
        this.userId,
        this.name,
        this.type,
    });

    String userId;
    String name;
    String type;

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        userId: json["userId"],
        name: json["name"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "type": type,
    };
}