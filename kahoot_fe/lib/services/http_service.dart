// import 'dart:convert';
// import 'package:http/http.dart' as http;
// // import 'package:kahoot_clone/common/constants.dart';

// class HttpService {
//   final String baseUrl;

//   HttpService({required this.baseUrl});

//   // Interceptor: Thêm token vào headers trước khi gửi request
//   Future<http.Response> get(String endpoint, {Map<String, String>? headers}) async {
//     final Map<String, String> defaultHeaders = {
//       'Content-Type': 'application/json',
//       //'Authorization': 'Bearer ${Constants.ACCESS_TOKEN}',  // Token lấy từ Constants
//     };

//     if (headers != null) {
//       defaultHeaders.addAll(headers);
//     }

//     try {
//       print('Request URL: $baseUrl$endpoint');
//       final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: defaultHeaders);
//       print('Response Status: ${response.statusCode}');
//       return response;
//     } catch (e) {
//       print('Request failed: $e');
//       rethrow;
//     }
//   }

//   Future<http.Response> post(String endpoint, {Map<String, String>? headers, dynamic body}) async {
//     final Map<String, String> defaultHeaders = {
//       'Content-Type': 'application/json',
//       // 'Authorization': 'Bearer ${Constants.ACCESS_TOKEN}',
//     };

//     if (headers != null) {
//       defaultHeaders.addAll(headers);
//     }

//     try {
//       print('Request URL: $baseUrl$endpoint');
//       final response = await http.post(Uri.parse('$baseUrl$endpoint'),
//           headers: defaultHeaders, body: jsonEncode(body));
//       print('Response Status: ${response.statusCode}');
//       return response;
//     } catch (e) {
//       print('Request failed: $e');
//       rethrow;
//     }
//   }
// }
