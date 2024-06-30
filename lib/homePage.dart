import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List movies = [];

  Future<void> fetchMovies(String mood) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/discover/movie?api_key=9932fd4ee5586bc8489c8f2d553ead66&language=fr&sort_by=popularity.desc&with_genres=$mood'));
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      setState(() {
        movies = data['results'];
        isLoading = false;
        print(movies);
      });
    }else{
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Color(0xFFBB4046),
            appBar: AppBar(
              backgroundColor: Color(0xFFBB4046),
              title: Text(""),
              leading: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.verified_user,
                      color: Colors.white,
                    ))
              ],
            ),
            body: Container(
                padding: EdgeInsets.only(left: 18, right: 15, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Trouvons le film parfait pour ton humeur du jour",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "comment tu te sens aujourd'hui ?",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          button("🙂", '27'),
                          button("😢", '18'),
                          button("❤️", '10749'),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          button("😃", '35'),
                          button("😌", '80'),
                          button("😴", '27'),
                        ]),
                    SizedBox(
                      height: 30,
                    ),
                    movies.isEmpty ? Text("Aucun film ne correspond à tes critères d'humeur.") :
                    isLoading ? 
                    Center(
                      child: CircularProgressIndicator(),
                    )
             :
                    Expanded(
                      child: 
                      
                      ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return movieCard(
                              "https://image.tmdb.org/t/p/w500${movies[index]['backdrop_path']}",
                              movies[index]['title'],
                              "genre",
                              movies[index]['overview']);


                        },
                        padding: EdgeInsets.all(16.0),
                        
                      ),
                    ),
                  ],
                ))));
  }

  Widget button(String icon, String mood) {
    return GestureDetector(
      onTap: () {
        fetchMovies(mood);
      },
      child: Container(
        child: Text(
          "$icon",
          style: TextStyle(fontSize: 22),
        ),
        padding: EdgeInsets.all(6),
        decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.white)),
      ),
    );
  }

  Widget movieCard(
      String imageUrl, String title, String genre, String description, {String? duration}) {
        print(imageUrl);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  genre,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  description.length > 50
                      ? '${description.substring(0, 50)}...'
                      : description,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
