import 'package:bloc_crud_pagination/screens/post_form_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/post_cubit.dart';
import '../cubit/post_state.dart';


class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<PostCubit>().fetchPosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostCubit>();

    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return Center(child: Text("No posts yet"));
            }

            return RefreshIndicator(
              onRefresh: () async => await cubit.fetchPosts(isRefresh: true),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.posts.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= state.posts.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = state.posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        cubit.deletePost(post.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Post deleted')),
                        );
                      },
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PostFormScreen(post: post)),
                    ),
                  );
                },
              ),
            );
          } else if (state is PostError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text("No posts"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostFormScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
