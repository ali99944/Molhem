// import 'package:http/http.dart' as http;
// import 'package:flutter_html/flutter_html.dart' as html;
//
// Future<String?> fetchPinterestImage(String url) async {
//   // Replace with your Pinterest pin URL
//   // Fetch the Pinterest pin page HTML content
//   // Use your preferred HTTP client for making the request
//   // Here, I'm using the http package as an example
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     // Parse the HTML content using flutter_html package
//     final document = html.parse(response.body);
//
//     // Find the image URL from the parsed HTML content
//     final imageElement = document.querySelector('.heightContainer img');
//     if (imageElement != null) {
//       final imageUrl = imageElement.attributes['src'];
//       return imageUrl;
//     }
//   }
//
//   return null;
// }