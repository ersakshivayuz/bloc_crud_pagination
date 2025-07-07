
 import 'package:bloc_crud_pagination/models/post_model.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostLoaded({required this.posts, required this.hasReachedMax});
}

class PostError extends PostState {
  final String message;

  PostError({required this.message});
}
