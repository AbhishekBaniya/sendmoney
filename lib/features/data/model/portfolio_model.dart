class PortfolioModel {
  final int id;
  final String name, username, email, phone, website;
  //final String description;

  PortfolioModel({required this.id, required this.name, required this.username, required this.email, required this.phone, required this.website,});

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json["id"],
      name: json["name"],
      username: json["username"],
      email: json["email"],
      phone: json["phone"],
      website: json["website"],
    );
  }
}
