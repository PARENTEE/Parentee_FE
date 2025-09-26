class ArticleSection {
  final String header; // đầu đề nhỏ, có thể để rỗng nếu không có header
  final String body; // nội dung phần đó

  ArticleSection({required this.header, required this.body});
}

class Article {
  final String image;
  final String title;
  final List<ArticleSection> sections;

  Article({required this.image, required this.title, required this.sections});
}
