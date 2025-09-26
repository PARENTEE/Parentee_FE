import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parentee_fe/features/auth/models/article.dart';
import 'package:parentee_fe/features/auth/screens/ArticlePage/article_detail_page.dart';
import 'package:parentee_fe/features/auth/screens/BabyTracker/baby_profile.dart';
import 'package:parentee_fe/features/auth/screens/Chatbot/chat_topics_page.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/Notification/notification.dart';
import 'package:parentee_fe/features/auth/screens/MedicinePage/medicine_page.dart';
import 'package:parentee_fe/features/auth/screens/NutrientPage/nutrient_page.dart';
import 'package:parentee_fe/features/auth/widgets/bottom_nav.dart';
import 'package:parentee_fe/features/auth/screens/HomePage/Weather/weather.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Danh mục
  static final List<Map<String, dynamic>> categories = [
    {
      "icon": "assets/images/order-tracking.png",
      "label": "Bộ theo dõi",
      "page": const BabyProfilePage(),
    },
    {
      "icon": "assets/images/weather.png",
      "label": "Thời tiết",
      "page": const WeatherPage(),
    },
    {
      "icon": "assets/images/drugs.png",
      "label": "Thuốc",
      "page": const MedicinePage(),
    },
    {
      "icon": "assets/images/nutrient.png",
      "label": "Dinh dưỡng",
      "page": const NutrientPage(),
    },
  ];

  // Banner (carousel)
  static final List<String> banners = [
    "assets/images/carousel/carousel_1.jpg",
    "assets/images/carousel/carousel_2.jpg",
    "assets/images/carousel/carousel_3.jpg",
  ];

  static final List<Article> articles = [
    Article(
      image: "assets/images/homepage/family.jpg",
      title: "Giữ lửa hạnh phúc trong gia đình",
      sections: [
        ArticleSection(
          header: "",
          body:
              "Giữ lửa hạnh phúc trong gia đình không phải là việc dễ dàng, nhưng hoàn toàn có thể nếu mỗi thành viên biết quan tâm, chia sẻ và đồng hành cùng nhau trong cuộc sống. "
              "Một gia đình hạnh phúc không chỉ đơn giản là ở chung một mái nhà, mà còn là sự gắn kết trong tâm hồn, cùng nhau vượt qua khó khăn và cùng nhau tận hưởng những khoảnh khắc bình yên.",
        ),
        ArticleSection(
          header: "Làm sao để giữ sự kết nối?",
          body:
              "Một bữa cơm chung, một chuyến đi dã ngoại nhỏ hay chỉ đơn giản là một buổi trò chuyện cuối ngày cũng đủ giúp gia đình thêm gắn kết. "
              "Hãy dành thời gian lắng nghe nhau, kể cho nhau nghe những câu chuyện trong ngày, và chia sẻ niềm vui, nỗi buồn. "
              "Sự kết nối này sẽ giúp mọi người cảm thấy được yêu thương và thấu hiểu.",
        ),
        ArticleSection(
          header: "Tạo thói quen hằng ngày",
          body:
              "Thiết lập những thói quen nhỏ như cùng nhau ăn sáng, đọc truyện cho con trước khi ngủ hay cùng đi dạo vào buổi tối có thể tạo ra sự gắn bó bền vững. "
              "Những thói quen này dần dần trở thành một phần quan trọng trong cuộc sống gia đình, mang lại cảm giác ổn định và thân thuộc cho các thành viên.",
        ),
        ArticleSection(
          header: "Vượt qua thử thách",
          body:
              "Trong bất kỳ gia đình nào cũng sẽ có những lúc mâu thuẫn hoặc khó khăn. Điều quan trọng là học cách giải quyết mâu thuẫn trong tinh thần tôn trọng và yêu thương. "
              "Thay vì tranh cãi gay gắt, hãy học cách lắng nghe, kiềm chế cảm xúc và tìm ra giải pháp cùng nhau. "
              "Mỗi thử thách vượt qua sẽ khiến gia đình càng thêm vững mạnh.",
        ),
        ArticleSection(
          header: "Kết luận",
          body:
              "Tình yêu, sự thấu hiểu và thời gian bên nhau chính là chìa khóa để giữ lửa hạnh phúc trong gia đình. "
              "Đừng chờ đợi những điều lớn lao, hãy bắt đầu từ những hành động nhỏ mỗi ngày. "
              "Một cái ôm, một lời động viên hay một khoảnh khắc cùng nhau cũng đủ để thắp sáng ngọn lửa tình cảm trong gia đình.",
        ),
      ],
    ),
    Article(
      image: "assets/images/article_photo/article_1.jpg",
      title: "Bí quyết nuôi dạy con khỏe mạnh",
      sections: [
        ArticleSection(
          header: "Chất béo tốt – không phải tất cả đều giống nhau",
          body:
              "Không phải chất béo nào cũng xấu. Những loại chất béo lành mạnh trong quả bơ, dầu ô liu, các loại hạt, cá hồi và sản phẩm sữa tươi nguyên chất đều đóng vai trò quan trọng trong sự phát triển trí não và thể chất của trẻ. "
              "Điều quan trọng là biết cách cân bằng giữa các nhóm thực phẩm để đảm bảo dinh dưỡng toàn diện.",
        ),
        ArticleSection(
          header: "Thực đơn mẫu cho trẻ 1 tuổi (~9,5 kg)",
          body: """
Bữa sáng:  
• ½ chén ngũ cốc bổ sung sắt hoặc 1 quả trứng luộc  
• ½ chén sữa nguyên kem hoặc sữa 2% béo  
• ½ quả chuối, cắt lát  
• 2–3 quả dâu tây nhỏ, cắt lát  

Bữa ăn nhẹ:  
• 1 lát bánh mì nướng nguyên cám  
• 1 thìa bơ đậu phộng mỏng  
• Nước lọc hoặc ½ chén sữa  

Bữa trưa:  
• ½ chén cơm mềm hoặc nui nấu chín  
• 2–3 thìa thịt gà hoặc cá hấp, băm nhỏ  
• Rau luộc nghiền nhuyễn (bí đỏ, cà rốt, súp lơ xanh)  

Bữa tối:  
• 2–3 ounce thịt bò/ thịt gà nấu chín  
• ½ chén khoai tây nghiền  
• ½ chén sữa nguyên kem hoặc sữa 2% béo  
""",
        ),
        ArticleSection(
          header: "Giấc ngủ quan trọng thế nào?",
          body:
              "Trẻ nhỏ cần ngủ đủ từ 10–12 tiếng mỗi ngày để cơ thể phát triển toàn diện. Giấc ngủ sâu giúp cải thiện trí nhớ, tăng khả năng tập trung và hỗ trợ hệ miễn dịch. "
              "Cha mẹ nên tạo thói quen giờ ngủ cố định, hạn chế sử dụng thiết bị điện tử trước khi đi ngủ để trẻ dễ dàng đi vào giấc ngủ hơn.",
        ),
        ArticleSection(
          header: "Hoạt động thể chất",
          body:
              "Tập luyện không chỉ dành cho người lớn mà còn vô cùng quan trọng với trẻ. Các hoạt động đơn giản như bò, tập đi, chơi bóng hoặc chạy nhảy đều giúp xương chắc khỏe và tăng cường sức đề kháng. "
              "Cha mẹ nên khuyến khích trẻ vận động ít nhất 1 giờ mỗi ngày.",
        ),
        ArticleSection(
          header: "",
          body:
              "Việc kết hợp chế độ dinh dưỡng cân bằng, giấc ngủ đầy đủ và hoạt động thể chất hợp lý chính là chìa khóa giúp trẻ phát triển khỏe mạnh, thông minh và hạnh phúc.",
        ),
      ],
    ),
    Article(
      image: "assets/images/homepage/connections.jpg",
      title: "Thời gian chất lượng cùng gia đình",
      sections: [
        ArticleSection(
          header: "",
          body:
              "Trong nhịp sống hiện đại, con người ngày càng bận rộn với công việc, học tập và vô số trách nhiệm xã hội. "
              "Điều này khiến nhiều gia đình rơi vào tình trạng ở gần nhau về mặt vật lý nhưng lại xa cách về mặt tinh thần. "
              "Khái niệm 'thời gian chất lượng' ra đời để nhấn mạnh rằng giá trị của khoảnh khắc bên nhau không nằm ở số giờ, mà nằm ở mức độ kết nối và sự hiện diện trọn vẹn của mỗi thành viên.",
        ),
        ArticleSection(
          header: "Hoạt động tương tác",
          body:
              "Một trong những cách đơn giản nhất để xây dựng thời gian chất lượng là thông qua các hoạt động tương tác. "
              "Thay vì để con trẻ chìm đắm trong màn hình điện thoại hay TV, cha mẹ có thể cùng con chơi các trò chơi trí tuệ, đọc sách, vẽ tranh hoặc nấu ăn. "
              "Những khoảnh khắc này không chỉ giúp trẻ học thêm nhiều kỹ năng mới mà còn tạo điều kiện cho cha mẹ thấu hiểu tính cách, sở thích và ước mơ của con.",
        ),
        ArticleSection(
          header: "Tách khỏi màn hình",
          body:
              "Các nghiên cứu chỉ ra rằng việc sử dụng thiết bị điện tử quá nhiều làm giảm chất lượng giao tiếp trong gia đình. "
              "Đặt ra những 'khoảng thời gian không màn hình', ví dụ như trong bữa ăn hoặc một buổi tối cuối tuần, sẽ tạo ra cơ hội để cả nhà thật sự trò chuyện và lắng nghe nhau. "
              "Khi không bị gián đoạn bởi tiếng chuông thông báo, mọi người có thể tập trung vào ánh mắt, lời nói và cảm xúc của nhau.",
        ),
        ArticleSection(
          header: "Ý nghĩa của những khoảnh khắc nhỏ",
          body:
              "Không cần phải đợi đến những chuyến du lịch xa hoa hay kỳ nghỉ dài ngày để có thời gian chất lượng. "
              "Chính những hành động nhỏ bé như cùng nhau dọn dẹp nhà cửa, chăm sóc cây cối trong vườn hay đi dạo quanh khu phố cũng mang lại những ký ức đáng nhớ. "
              "Điều cốt lõi là mỗi thành viên đều cảm thấy mình có giá trị, được lắng nghe và được yêu thương trong từng khoảnh khắc.",
        ),
        ArticleSection(
          header: "Kết nối cảm xúc",
          body:
              "Ngoài hoạt động chung, sự kết nối cảm xúc cũng là yếu tố quan trọng. "
              "Đôi khi, chỉ cần một cái ôm ấm áp, một lời động viên sau ngày dài mệt mỏi hay đơn giản là ánh mắt thấu hiểu cũng đủ để gắn kết các thành viên trong gia đình. "
              "Những điều tưởng chừng nhỏ nhặt ấy lại tạo nên nền tảng bền vững cho mối quan hệ lâu dài.",
        ),
        ArticleSection(
          header: "Kết luận",
          body:
              "Thời gian chất lượng không được đo bằng số lượng, mà bằng cách bạn hiện diện và quan tâm đến nhau. "
              "Hãy bắt đầu từ những thay đổi nhỏ: bớt thời gian lướt mạng, thêm thời gian trò chuyện; bớt để tâm đến công việc, thêm sự chú ý dành cho người thân. "
              "Mỗi khoảnh khắc trọn vẹn bên gia đình sẽ trở thành ký ức quý giá, nuôi dưỡng tình yêu thương và sự gắn kết bền lâu.",
        ),
      ],
    ),
  ];

  // Khóa học
  static final List<Map<String, String>> courses = [
    {
      "image": "assets/images/homepage/co_parenting.jpg",
      "title": "Kỹ năng làm cha mẹ hiện đại",
    },
    {
      "image": "assets/images/homepage/happiness.jpg",
      "title": "Nuôi dạy con thông minh cảm xúc (EQ)",
    },
    {
      "image": "assets/images/homepage/healthy_parenting.jpg",
      "title": "Khóa học xây dựng gia đình hạnh phúc",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNav(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatTopicsPage()),
            );
          },
          child: Image.asset("assets/images/chatbot_1.png"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(
                        "assets/images/homepage/family.jpg",
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chào mừng! Admin",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Miễn phí",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    // Icon notification + badge đỏ
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications_none, size: 30),
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Banner Carousel
                CarouselSlider(
                  options: CarouselOptions(
                    height: 170,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                  items:
                      banners.map((banner) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            banner,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                // Danh mục
                const Text(
                  "Danh mục",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      categories
                          .map(
                            (cat) => _buildCategory(
                              context,
                              cat["icon"],
                              cat["label"],
                              cat["page"],
                            ),
                          )
                          .toList(),
                ),

                const SizedBox(height: 24),

                // Chuyên mục
                const Text(
                  "Chuyên mục",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        articles
                            .map(
                              (art) => _buildCard(
                                image: art.image,
                                title: art.title,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ArticleDetailPage(
                                            title: art.title,
                                            image: art.image,
                                            sections: art.sections,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Khóa học
                const Text(
                  "Khóa học",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        courses
                            .map(
                              (c) => _buildCard(
                                image: c["image"]!,
                                title: c["title"]!,
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget danh mục
  static Widget _buildCategory(
    BuildContext context,
    String image,
    String label, [
    Widget? page,
  ]) {
    return InkWell(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$label chưa có trang")));
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 56,
            width: 56,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Widget thẻ dùng chung cho Article & Course
  static Widget _buildCard({
    required String image,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.bottomLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
