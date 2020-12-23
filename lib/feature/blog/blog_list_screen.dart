import 'package:flutter/material.dart';
import 'package:trocado_flutter/api/api_helper.dart';
import 'package:trocado_flutter/feature/blog/blog_post.dart';
import 'package:trocado_flutter/widget/trocado_app_bar.dart';
import 'package:http/http.dart' as http;

import 'blog_post_screen.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  Future<List<BlogPost>> loadPosts() async {
    ApiHelper apiHelper = ApiHelper();
    String url =
        "https://api.cosmicjs.com/v1/dc3f5e80-432a-11eb-8b3b-c59fea007426/objects?pretty=true&hide_metafields=true&type=posts&read_key=hSFUdhJeuLlkBtSxdV957Jn5hFvnPGYDgLtgHV9Y9zeGKBqy9S&limit=20&props=slug,title,content,metadata,created_at";
    dynamic response = await http.get(url);
    dynamic responseJson = apiHelper.returnResponse(response);
    List<BlogPost> posts = [];
    for (dynamic post in responseJson['objects']) {
      posts.add(BlogPost.fromJson(post));
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: trocadoAppBar("Blog"),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: FutureBuilder<List<BlogPost>>(
            future: loadPosts(),
            builder: (context, AsyncSnapshot<List<BlogPost>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }

              List<BlogPost> posts = snapshot.data;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, i) => Card(
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlogPostScreen(posts[i]))),
                    child: Column(
                      children: [
                        Hero(tag: posts[i].title, child: Image.network(posts[i].imageUrl, fit: BoxFit.cover)),
                        ListTile(
                          title: Text(posts[i].title),
                          subtitle: Text(
                            posts[i].creationDate,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.black45),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}