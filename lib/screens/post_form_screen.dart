import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/post_cubit.dart';
import '../models/post_model.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post;

  const PostFormScreen({Key? key, this.post}) : super(key: key);

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final newPost = Post(
        id: widget.post?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      final cubit = context.read<PostCubit>();
      if (widget.post == null) {
        cubit.addPost(newPost);
      } else {
        cubit.updatePost(newPost);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.post != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'Edit Post' : 'New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (val) => val == null || val.isEmpty ? 'Enter title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: 'Body'),
                validator: (val) => val == null || val.isEmpty ? 'Enter body' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _onSave,
                child: Text(isUpdate ? 'Update' : 'Add'),

              )
            ],
          ),
        ),
      ),
    );
  }
}
