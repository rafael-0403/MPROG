import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Newspage extends StatefulWidget {
  @override
  _NewspageState createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  late Future<List<Getnews>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  // Fetch posts from the API
  Future<List<Getnews>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData.map((item) => Getnews.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Page'),
      ),
      body: FutureBuilder<List<Getnews>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Model class for Getnews
class Getnews {
  final int id;
  final String title;
  final String body;

  Getnews({required this.id, required this.title, required this.body});

  factory Getnews.fromJson(Map<String, dynamic> json) {
    return Getnews(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}