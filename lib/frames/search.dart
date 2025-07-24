import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "Book.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchControl = TextEditingController();
  List<Book> books = [];
  final Color bg = Colors.purple;
  final Color fg = Color(0xFFF5F5DC);

  void _search() async{
    String inputTitle = _searchControl.text.replaceAll(' ', '+');
    String query = 'https://www.googleapis.com/books/v1/volumes?q=';
    String defaultBookLink = '';
    if (inputTitle.isNotEmpty) {
      query = '$query$inputTitle&maxResults=20';
    }
    http.Response response = await http.get(Uri.parse(query));
    if (response.statusCode==200){
      Map<String,dynamic> jsonData = json.decode(response.body);
      List<dynamic> bookData = jsonData["items"];
      setState(() {
        books =[];
        for (var d in bookData) {
          var volumeInfo = d["volumeInfo"];
          if (volumeInfo['title'] != null) {
            String title = volumeInfo["title"] ?? "No title available";
            String authors = (volumeInfo["authors"] != null)
                ? volumeInfo["authors"].join(", ")
                : "No author available";
            String description = volumeInfo["description"] ??
                "No description available";
            String categories = (volumeInfo["categories"] != null)
                ? volumeInfo["categories"].join(", ")
                : "No categories";
            Map<String, String> thumbnails = (volumeInfo["imageLinks"] != null)
                ? Map<String, String>.from(volumeInfo["imageLinks"])
                : {"none": ""};
            String link = thumbnails["medium"] ?? thumbnails["small"] ??
                thumbnails["large"] ?? thumbnails["thumbnail"] ??
                thumbnails["extraLarge"] ?? thumbnails["smallThumbnail"] ??
                defaultBookLink;
            books.add(Book(
              title: title,
              author: authors,
              description: description,
              categories: categories,
              imageUrl: link,
            ));
          }
        }
      });
    }
    else{
      print("Error: $response.statusCode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Books", style: TextStyle(fontSize: 24)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchControl,
                      style: TextStyle(fontSize: 12, color: bg),
                      keyboardType: TextInputType.webSearch,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fg,
                        hintText: "Search",
                        hintStyle: TextStyle(color: bg),
                      ),
                    ),
                  ),

                  IconButton(onPressed: _search, icon: Icon(Icons.search)),
                ],
              ),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.55,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return books[index];
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
