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
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(isUpdate ? 'Edit Post' : 'New Post'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isUpdate ? 'Update Your Post' : 'Create a New Post',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'Enter title' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _bodyController,
                        decoration: InputDecoration(
                          labelText: 'Body',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                        validator: (val) => val == null || val.isEmpty ? 'Enter body' : null,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _onSave,
                          child: Text(
                            isUpdate ? 'Update Post' : 'Add Post',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
