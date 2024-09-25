class Service{
  String name;
  String description;
  String imageUrl;
  int appearanceInDB;

  Service({required this.name, required this.description, required this.imageUrl, required this.appearanceInDB});

  @override
  String toString() {
    return 'Service{name: $name, description: $description, imageUrl: $imageUrl, appearanceInDB: $appearanceInDB}';
  }

}