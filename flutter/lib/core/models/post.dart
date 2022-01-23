class Post {
  Post(
      {required this.name,
      required this.title,
      required this.price,
      required this.img,
      required this.itemId,
      this.like = false});
  String name;
  String title;
  String price;
  BigInt itemId;
  String img;
  bool like;
}
