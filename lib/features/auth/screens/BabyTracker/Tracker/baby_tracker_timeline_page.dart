import 'package:flutter/material.dart';

class BabyTrackerTimelinePage extends StatefulWidget {
  const BabyTrackerTimelinePage({super.key});

  @override
  State<BabyTrackerTimelinePage> createState() => _BabyTrackerTimelinePageState();
}

class _BabyTrackerTimelinePageState extends State<BabyTrackerTimelinePage> {
  int _selectedDay = 3; // Wednesday (index 3)

  final List<String> _weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  final List<int> _dates = [15, 16, 17, 18, 19, 20, 21];

  // Timeline activities for each day - 7 columns
  final Map<int, List<Map<String, dynamic>>> _weekActivities = {
    0: [ // Sunday
      {'time': '7a', 'color': Colors.cyan, 'height': 1.5},
      {'time': '9a', 'color': Colors.orange, 'height': 1.5},
      {'time': '11a', 'color': Colors.red.shade900, 'height': 1.0},
      {'time': '1p', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '3p', 'color': Colors.red.shade900, 'height': 1.0},
      {'time': '5p', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '7p', 'color': Colors.yellow, 'height': 1.0},
      {'time': '9p', 'color': Colors.transparent, 'height': 0.8},
      {'time': '11p', 'color': Colors.cyan, 'height': 3.0},
      {'time': '1a', 'color': Colors.cyan, 'height': 1.0},
      {'time': '3a', 'color': Colors.orange, 'height': 0.5},
      {'time': '5a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '7a', 'color': Colors.cyan, 'height': 1.5},
    ],
    1: [ // Monday
      {'time': '7a', 'color': Colors.transparent, 'height': 1.5},
      {'time': '9a', 'color': Colors.cyan, 'height': 2.0},
      {'time': '11a', 'color': Colors.red.shade900, 'height': 1.5},
      {'time': '1p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '3p', 'color': Colors.orange, 'height': 1.0},
      {'time': '5p', 'color': Colors.brown, 'height': 1.0},
      {'time': '7p', 'color': Colors.yellow, 'height': 1.5},
      {'time': '9p', 'color': Colors.transparent, 'height': 0.8},
      {'time': '11p', 'color': Colors.cyan, 'height': 3.0},
      {'time': '1a', 'color': Colors.cyan, 'height': 1.0},
      {'time': '3a', 'color': Colors.transparent, 'height': 0.5},
      {'time': '5a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '7a', 'color': Colors.cyan, 'height': 1.5},
    ],
    2: [ // Tuesday
      {'time': '7a', 'color': Colors.transparent, 'height': 1.5},
      {'time': '9a', 'color': Colors.cyan, 'height': 1.0},
      {'time': '11a', 'color': Colors.orange, 'height': 0.5},
      {'time': '1p', 'color': Colors.cyan.shade100, 'height': 2.0},
      {'time': '3p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '5p', 'color': Colors.orange, 'height': 1.5},
      {'time': '7p', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '9p', 'color': Colors.orange, 'height': 1.0},
      {'time': '11p', 'color': Colors.cyan, 'height': 3.0},
      {'time': '1a', 'color': Colors.cyan, 'height': 1.0},
      {'time': '3a', 'color': Colors.transparent, 'height': 0.5},
      {'time': '5a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '7a', 'color': Colors.cyan, 'height': 1.5},
    ],
    3: [ // Wednesday - Selected day with detailed activities
      {'time': '7a', 'color': Colors.cyan, 'height': 1.5},
      {'time': '9a', 'color': Colors.orange, 'height': 1.5},
      {'time': '11a', 'color': Colors.red.shade900, 'height': 1.0},
      {'time': '1p', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '3p', 'color': Colors.orange, 'height': 1.0},
      {'time': '5p', 'color': Colors.red.shade900, 'height': 1.0},
      {'time': '7p', 'color': Colors.yellow, 'height': 1.0},
      {'time': '9p', 'color': Colors.orange, 'height': 0.8},
      {'time': '11p', 'color': Colors.cyan, 'height': 4.0},
      {'time': '1a', 'color': Colors.yellow, 'height': 0.5},
      {'time': '3a', 'color': Colors.orange, 'height': 0.5},
      {'time': '5a', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '7a', 'color': Colors.transparent, 'height': 1.0},
    ],
    4: [ // Thursday
      {'time': '7a', 'color': Colors.yellow, 'height': 0.8},
      {'time': '9a', 'color': Colors.orange, 'height': 1.5},
      {'time': '11a', 'color': Colors.brown, 'height': 1.0},
      {'time': '1p', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '3p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '5p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '7p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '9p', 'color': Colors.cyan, 'height': 3.5},
      {'time': '11p', 'color': Colors.cyan, 'height': 2.0},
      {'time': '1a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '3a', 'color': Colors.transparent, 'height': 0.5},
      {'time': '5a', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '7a', 'color': Colors.transparent, 'height': 1.0},
    ],
    5: [ // Friday
      {'time': '7a', 'color': Colors.yellow, 'height': 0.8},
      {'time': '9a', 'color': Colors.orange, 'height': 1.5},
      {'time': '11a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '1p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '3p', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '5p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '7p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '9p', 'color': Colors.cyan, 'height': 3.0},
      {'time': '11p', 'color': Colors.cyan, 'height': 2.5},
      {'time': '1a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '3a', 'color': Colors.transparent, 'height': 0.5},
      {'time': '5a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '7a', 'color': Colors.transparent, 'height': 1.0},
    ],
    6: [ // Saturday
      {'time': '7a', 'color': Colors.yellow, 'height': 0.8},
      {'time': '9a', 'color': Colors.orange, 'height': 1.5},
      {'time': '11a', 'color': Colors.brown, 'height': 1.0},
      {'time': '1p', 'color': Colors.cyan.shade100, 'height': 1.0},
      {'time': '3p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '5p', 'color': Colors.transparent, 'height': 1.0},
      {'time': '7p', 'color': Colors.yellow, 'height': 1.0},
      {'time': '9p', 'color': Colors.cyan, 'height': 3.5},
      {'time': '11p', 'color': Colors.cyan, 'height': 2.0},
      {'time': '1a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '3a', 'color': Colors.transparent, 'height': 0.5},
      {'time': '5a', 'color': Colors.transparent, 'height': 1.0},
      {'time': '7a', 'color': Colors.transparent, 'height': 1.0},
    ],
  };

  final List<Map<String, dynamic>> _activityList = [
    {
      'icon': Icons.bedtime,
      'iconColor': Colors.cyan,
      'title': 'Oscar slept 11h 46m',
      'subtitle': '9:00 PM - 8:46 AM',
      'leftBarColor': Colors.green,
    },
    {
      'icon': Icons.baby_changing_station,
      'iconColor': Colors.orange,
      'title': 'Oscar had pee',
      'subtitle': 'Aug 18, 9:15 AM 💧',
      'leftBarColor': Colors.orange,
    },
    {
      'icon': Icons.local_drink,
      'iconColor': Colors.red,
      'title': 'Oscar had 7.25oz bottle of Formula',
      'subtitle': 'Aug 18, 8:46 AM',
      'leftBarColor': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double maxColumnHeight = _getMaxColumnHeight();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Theo dõi bé",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Week header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aug\n2023',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                ...List.generate(7, (index) {
                  final isSelected = index == _selectedDay;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDay = index),
                      child: Column(
                        children: [
                          Text(
                            _weekDays[index],
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? Colors.cyan : Colors.grey,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_dates[index]}',
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? Colors.cyan : Colors.grey,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Timeline and Activity list
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Timeline chart with 7 columns
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time labels
                        Column(
                          children: _weekActivities[0]!.map((activity) {
                            return SizedBox(
                              height: 30,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  activity['time'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(width: 8),
                        // Timeline bars for 7 days
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(7, (dayIndex) {
                              final activities = _weekActivities[dayIndex]!;
                              final totalHeight =
                              activities.fold<double>(0, (sum, a) => sum + (a['height'] as double));
                              final remaining = maxColumnHeight - totalHeight;

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Column(
                                    children: [
                                      ...activities.map((activity) {
                                        return Container(
                                          height: 30 * (activity['height'] as double),
                                          margin: const EdgeInsets.symmetric(vertical: 0.5),
                                          decoration: BoxDecoration(
                                            color: activity['color'],
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                        );
                                      }),
                                      if (remaining > 0)
                                        SizedBox(height: 30 * remaining), // phần bù để đồng bộ chiều cao
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Activity list
                    // ..._activityList.map((activity) {
                    //   return Container(
                    //     margin: const EdgeInsets.only(bottom: 12),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(12),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.shade200,
                    //           blurRadius: 4,
                    //           offset: const Offset(0, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: IntrinsicHeight(
                    //       child: Row(
                    //         children: [
                    //           // Left color bar
                    //           Container(
                    //             width: 4,
                    //             decoration: BoxDecoration(
                    //               color: activity['leftBarColor'],
                    //               borderRadius: const BorderRadius.only(
                    //                 topLeft: Radius.circular(12),
                    //                 bottomLeft: Radius.circular(12),
                    //               ),
                    //             ),
                    //           ),
                    //           // Content
                    //           Expanded(
                    //             child: ListTile(
                    //               contentPadding: const EdgeInsets.symmetric(
                    //                 horizontal: 16,
                    //                 vertical: 8,
                    //               ),
                    //               leading: CircleAvatar(
                    //                 backgroundColor: activity['iconColor'].withOpacity(0.1),
                    //                 child: Icon(
                    //                   activity['icon'],
                    //                   color: activity['iconColor'],
                    //                   size: 24,
                    //                 ),
                    //               ),
                    //               title: Text(
                    //                 activity['title'],
                    //                 style: const TextStyle(
                    //                   fontSize: 15,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //               subtitle: Padding(
                    //                 padding: const EdgeInsets.only(top: 4),
                    //                 child: Text(
                    //                   activity['subtitle'],
                    //                   style: TextStyle(
                    //                     fontSize: 13,
                    //                     color: Colors.grey.shade600,
                    //                   ),
                    //                 ),
                    //               ),
                    //               trailing: Icon(
                    //                 Icons.chevron_right,
                    //                 color: Colors.grey.shade400,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   );
                    // }).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxColumnHeight() {
    double maxHeight = 0;
    for (var day in _weekActivities.values) {
      double totalHeight = 0;
      for (var act in day) {
        totalHeight += act['height'] as double;
      }
      if (totalHeight > maxHeight) maxHeight = totalHeight;
    }
    return maxHeight;
  }
}