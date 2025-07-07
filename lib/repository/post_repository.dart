import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostRepository {
  final _apiUrl = 'https://jsonplaceholder.typicode.com/posts';
  final _box = Hive.box('postsBox');

  Future<List<Post>> fetchPosts(String page, int limit) async {
    final response = await http.get(Uri.parse("$_apiUrl?_page=$page&_limit=$limit"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch posts");
    }
  }

  void savePostsToLocal(List<Post> posts) {
    _box.put('cachedPosts', posts.map((e) => e.toJson()).toList());
  }

  List<Post> loadPostsFromLocal() {
    final data = _box.get('cachedPosts', defaultValue: []);
    return (data as List).map((e) => Post.fromJson(e)).toList();
  }
}
