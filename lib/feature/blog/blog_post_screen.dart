import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';

import 'blog_post.dart';

class BlogPostScreen extends StatelessWidget {
  final BlogPost post;
  BlogPostScreen(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar(""),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Hero(tag: post.title, child: Image.network(post.imageUrl)),
          ListTile(
            title: Text(post.title),
            subtitle: Text(post.creationDate),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Html(data: post.content),
          ),
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(post.authorImageUrl)),
            title: Text(post.authorName),
            subtitle: const Text("Autor"),
          ),
        ],
      ),
    );
  }
}
