import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../models/post_model.dart';
import 'post_state.dart';


class PostCubit extends Cubit<PostState> {

  final List<Post> _allPosts = [];

  List<Post> get allPosts => _allPosts;
  PostCubit() : super(PostInitial());

  int page = 1;
  final int limit = 10;
  bool isFetching = false;
  List<Post> _posts = [];

  Future<void> fetchPosts({bool isRefresh = false}) async {
    if (isFetching) return;

    if (isRefresh) {
      page = 1;
      _posts.clear();
    }

    emit(PostLoading());
    isFetching = true;

    try {
      final response = await http.get(Uri.parse(
          'https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=$limit'));

      if (response.statusCode == 200) {
        final List json = jsonDecode(response.body);
        final List<Post> fetchedPosts =
        json.map((e) => Post.fromJson(e)).toList();

        if (fetchedPosts.isEmpty) {
          emit(PostLoaded(posts: _posts, hasReachedMax: true));
        } else {
          _posts.addAll(fetchedPosts);
          page++;
          emit(PostLoaded(posts: _posts, hasReachedMax: false));

           final box = Hive.box('postsBox');
          box.put('cachedPosts',
              _posts.map((p) => p.toJson()).toList());
        }
      } else {
        emit(PostError(message: 'Failed to load posts'));
      }
    } catch (e) {
      emit(PostError(message: e.toString()));
    }

    isFetching = false;
  }

  void addPost(Post post) {
    _posts.insert(0, post);
    emit(PostLoaded(posts: _posts, hasReachedMax: false));
  }

  void deletePost(int id) {
    _posts.removeWhere((post) => post.id == id);
    emit(PostLoaded(posts: _posts, hasReachedMax: false));
  }

  void updatePost(Post updatedPost) {
    final index = _posts.indexWhere((post) => post.id == updatedPost.id);
    if (index != -1) {
      _posts[index] = updatedPost;
      emit(PostLoaded(posts: _posts, hasReachedMax: false));
    }
  }

  void loadFromLocal() {
    final box = Hive.box('postsBox');
    final data = box.get('cachedPosts', defaultValue: []);
    try{
      final posts = (data as List).map((e) => Post.fromJson(e)).toList();
      _posts = posts;
      emit(PostLoaded(posts: _posts, hasReachedMax: false));
    }
    catch(e){
      log("error $e");
      emit(PostError(message: "something went wrong!"));
    }

  }
}
