import 'dart:async';
import 'dart:convert';
import 'album/album.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Album>> fetchAlbum() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var albumList = jsonDecode(response.body) as List;
    var albums =
        albumList.map((albumJson) => Album.fromJson(albumJson)).toList();
    return albums;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: FutureBuilder<List<Album>>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  var albums = snapshot.data!;
                  return ListView.builder(
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      var album = albums[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        // Ajusta el espacio vertical entre los elementos
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      4.0), // Ajusta el padding vertical para "ID"
                              child: Text('ID: ${album.id}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      4.0), // Ajusta el padding vertical para "UserID"
                              child: Text('UserID: ${album.userId}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      4.0), // Ajusta el padding vertical para "Title"
                              child: Text('Title: ${album.title}'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
