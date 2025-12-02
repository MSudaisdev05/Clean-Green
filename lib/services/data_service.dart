import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DataService {
  static SharedPreferences? _prefs;
  static final Uuid _uuid = Uuid();

  // Initialize shared preferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== POSTS ==========
  static Future<List<Map<String, dynamic>>> getPosts() async {
    final postsJson = _prefs?.getString('posts') ?? '[]';
    final List<dynamic> postsList = jsonDecode(postsJson);
    return postsList.cast<Map<String, dynamic>>();
  }

  static Future<void> savePost(Map<String, dynamic> post) async {
    final posts = await getPosts();
    post['id'] = _uuid.v4();
    post['createdAt'] = DateTime.now().toIso8601String();
    posts.insert(0, post);
    await _prefs?.setString('posts', jsonEncode(posts));
  }

  static Future<void> deletePost(String id) async {
    final posts = await getPosts();
    posts.removeWhere((post) => post['id'] == id);
    await _prefs?.setString('posts', jsonEncode(posts));
  }

  // ========== REPORTS ==========
  static Future<List<Map<String, dynamic>>> getReports() async {
    final reportsJson = _prefs?.getString('reports') ?? '[]';
    final List<dynamic> reportsList = jsonDecode(reportsJson);
    return reportsList.cast<Map<String, dynamic>>();
  }

  static Future<void> saveReport(Map<String, dynamic> report) async {
    final reports = await getReports();
    report['id'] = _uuid.v4();
    report['createdAt'] = DateTime.now().toIso8601String();
    report['status'] = 'Pending';
    reports.insert(0, report);
    await _prefs?.setString('reports', jsonEncode(reports));
  }

  // ========== IMAGE MANAGEMENT ==========
  static String? _convertFileToBase64(File file) {
    try {
      final bytes = file.readAsBytesSync();
      return base64Encode(bytes);
    } catch (e) {
      print('Error converting image: $e');
      return null;
    }
  }

  static Future<String?> saveImage(File file) async {
    final base64Image = _convertFileToBase64(file);
    if (base64Image == null) return null;

    final imageId = _uuid.v4();
    final imagesJson = _prefs?.getString('images') ?? '{}';
    final Map<String, dynamic> images = jsonDecode(imagesJson);
    images[imageId] = base64Image;
    await _prefs?.setString('images', jsonEncode(images));
    
    return imageId;
  }

  static String? getImageBase64(String imageId) {
    final imagesJson = _prefs?.getString('images') ?? '{}';
    final Map<String, dynamic> images = jsonDecode(imagesJson);
    return images[imageId];
  }

  // ========== SAMPLE DATA ==========
  static Future<void> initializeSampleData() async {
    final posts = await getPosts();
    if (posts.isEmpty) {
      await _addSamplePosts();
    }
  }

  static Future<void> _addSamplePosts() async {
    final samplePosts = [
      {
        'id': _uuid.v4(),
        'title': 'Community Garden Project',
        'description': 'Creating a green space for everyone to grow vegetables and flowers together.',
        'author': 'Sarah Johnson',
        'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'likes': 45,
        'comments': 12,
        'category': 'Environment',
        'location': 'Central Park',
        'hasImage': true,
      },
      {
        'id': _uuid.v4(),
        'title': 'Youth Education Center',
        'description': 'Building a learning center for underprivileged children with free classes.',
        'author': 'Michael Chen',
        'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'likes': 89,
        'comments': 23,
        'category': 'Education',
        'location': 'Downtown Area',
        'hasImage': false,
      },
    ];

    await _prefs?.setString('posts', jsonEncode(samplePosts));
  }
}