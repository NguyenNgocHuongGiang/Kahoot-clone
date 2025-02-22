import 'package:flutter/material.dart';
import 'package:kahoot_clone/services/game-session/game_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ReportDetailScreen extends StatefulWidget {
  final String quizTitle;
  final int sessionId;

  const ReportDetailScreen({
    Key? key,
    required this.quizTitle,
    required this.sessionId,
  }) : super(key: key);

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  late Future<Map<String, dynamic>> reportData;
  String sortColumn = 'score'; // Chọn mặc định sắp xếp theo điểm số
  bool isAscending = false; // Chế độ sắp xếp giảm dần

  @override
  void initState() {
    super.initState();
    reportData = loadReport();
    print(reportData);
  }

  Future<Map<String, dynamic>> loadReport() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    return await GameSessionService().getReport(
      sessionId: widget.sessionId.toString(),
      token: token ?? '',
    );
  }

  // Hàm sắp xếp theo một cột
  void sortData(String column) {
    setState(() {
      if (sortColumn == column) {
        isAscending = !isAscending;
      } else {
        sortColumn = column;
        isAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Quiz ${widget.quizTitle}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.red,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.red,
                tabs: [
                  Tab(text: 'Player'),
                  Tab(text: 'Question'),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: reportData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  var data = snapshot.data!;
                  var playerDetails =
                      List<Map<String, dynamic>>.from(data['playerDetails']);

                  // Sắp xếp playerDetails theo tiêu chí sortColumn
                  if (sortColumn == 'score') {
                    playerDetails.sort((a, b) => isAscending
                        ? a['score'].compareTo(b['score'])
                        : b['score'].compareTo(a['score']));
                  } else if (sortColumn == 'correctAnswers') {
                    playerDetails.sort((a, b) => isAscending
                        ? a['correctAnswers'].compareTo(b['correctAnswers'])
                        : b['correctAnswers'].compareTo(a['correctAnswers']));
                  } else if (sortColumn == 'correctRatio') {
                    playerDetails.sort((a, b) {
                      double ratioA =
                          a['correctAnswers'] / data['questionsCount'];
                      double ratioB =
                          b['correctAnswers'] / data['questionsCount'];
                      return isAscending
                          ? ratioA.compareTo(ratioB)
                          : ratioB.compareTo(ratioA);
                    });
                  }

                  int totalQuestions = data['questionsCount'];
                  int above50Players = playerDetails
                      .where((p) => p['correctAnswers'] / totalQuestions >= 0.5)
                      .length;

                  int totalPlayers = data['playerCount'];

                  return TabBarView(
                    children: [
                      // Tab "Player"
                      ListView(
                        children: [
                          Container(
                            color: Colors.grey[300], // Màu nền xám
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Biểu đồ hình tròn chiếm 2 phần
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height:
                                              160, // Tăng kích thước nếu cần
                                          child: PieChart(
                                            PieChartData(
                                              pieTouchData: PieTouchData(),
                                              sectionsSpace:
                                                  0, // Giảm khoảng cách giữa các phần
                                              centerSpaceRadius:
                                                  0, // Xóa phần lỗ ở giữa
                                              sections: [
                                                PieChartSectionData(
                                                  value:
                                                      above50Players.toDouble(),
                                                  color: Colors.green,
                                                  title:
                                                      '${((above50Players / totalPlayers) * 100).toStringAsFixed(1)}%',
                                                  radius:
                                                      80, // Đặt radius lớn hơn để hình tròn đầy hơn
                                                  titleStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                PieChartSectionData(
                                                  value: (totalPlayers -
                                                          above50Players)
                                                      .toDouble(),
                                                  color: Colors.red,
                                                  title:
                                                      '${(((totalPlayers - above50Players) / totalPlayers) * 100).toStringAsFixed(1)}%',
                                                  radius:
                                                      80, // Đặt radius lớn hơn để hình tròn đầy hơn
                                                  titleStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 18),
                                        //Thêm các chú thích màu dưới biểu đồ
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Chú thích cho phần màu xanh (>=50% người chơi)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 13,
                                                  height: 13,
                                                  color: Colors.green,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Tỷ lệ đúng trên 50%',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 6),
                                            // Chú thích cho phần màu đỏ (<50% người chơi)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 13,
                                                  height: 13,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Tỷ lệ đúng dưới 50%',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                      width:
                                          16), // Khoảng cách giữa biểu đồ và Total Players

                                  // Total Players chiếm 1.5 phần
                                  Expanded(
                                    flex: 15 ~/
                                        10, // 1.5 tương đương với 15/10 để giữ nguyên integer
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          text: 'Total Players: ',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text: '$totalPlayers',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataTable(
                            columnSpacing:
                                16.0, // Điều chỉnh khoảng cách giữa các cột
                            columns: [
                              DataColumn(
                                label: const Text('Nickname'),
                                onSort: (columnIndex, _) =>
                                    sortData('nickname'),
                              ),
                              DataColumn(
                                label: const Text('Correct/Total'),
                                onSort: (columnIndex, _) =>
                                    sortData('correctRatio'),
                              ),
                              DataColumn(
                                label: const Text('Score'),
                                onSort: (columnIndex, _) => sortData('score'),
                              ),
                            ],
                            rows: playerDetails.map<DataRow>((player) {
                              return DataRow(
                                cells: [
                                  DataCell(Padding(
                                    padding: const EdgeInsets.all(
                                        8.0), // Thêm padding vào DataCell
                                    child: Text(player['nickname']),
                                  )),
                                  DataCell(Padding(
                                    padding: const EdgeInsets.all(
                                        8.0), // Thêm padding vào DataCell
                                    child: Text(
                                        '${player['correctAnswers']}/${data['questionsCount']}'),
                                  )),
                                  DataCell(Padding(
                                    padding: const EdgeInsets.all(
                                        8.0), // Thêm padding vào DataCell
                                    child: Text(player['score'].toString()),
                                  )),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      // Tab "Question"
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight, // Căn lề phải
                              child: Container(
                                margin: const EdgeInsets.only(right: 16.0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors
                                      .transparent, // Màu nền trắng cho khung
                                ),
                                child: Text(
                                  'Total questions: ${data['questionsCount']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Màu chữ đen
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('Tỷ lệ đúng của các câu hỏi',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                            const SizedBox(height: 10),
                            Expanded(
                                child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: data['questionStats']?.length ??
                                  0, // Kiểm tra null trước khi tính length
                              itemBuilder: (context, index) {
                                var questionId = data['questionStats']
                                    ?.keys
                                    .elementAt(index); // Lấy questionId từ keys
                                var questionData = data['questionStats'][
                                    questionId]; // Lấy dữ liệu câu hỏi từ questionStats
                                var correctAnswers = questionData[
                                    'value']; // Số câu trả lời đúng
                                var questionText =
                                    questionData['text']; // Tên câu hỏi
                                double correctPercentage =
                                    (correctAnswers / totalPlayers) * 100;

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Hiển thị tên câu hỏi với Expanded để nó chiếm phần không gian còn lại
                                        Expanded(
                                          flex: 8, // Tên câu hỏi chiếm 8 phần
                                          child: Text(
                                            questionText ??
                                                'Câu hỏi không có tên',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow
                                                .ellipsis, // Nếu tên câu hỏi quá dài thì hiển thị dấu "..."
                                            maxLines: 1, // Giới hạn số dòng
                                          ),
                                        ),
                                        // Biểu đồ tròn chiếm 2 phần
                                        Flexible(
                                          flex: 2, // Biểu đồ tròn chiếm 2 phần
                                          child: CircularPercentIndicator(
                                            radius: 30.0,
                                            lineWidth: 4.0,
                                            percent: correctPercentage / 100,
                                            center: Text(
                                              '${correctPercentage.toStringAsFixed(1)}%',
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            progressColor: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ))
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
