import "package:flutter/material.dart";
import "book_popup.dart";

class Book extends Card {
  final String title;
  final String author;
  final String description;
  final String categories;
  final String imageUrl;
  final Color bg = Colors.purple;
  final Color fg = Colors.amberAccent;
  const Book({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.categories,
    required this.description,
  });

  void onclick(BuildContext context, String title, String url, String desc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BookPopUpScreen(
          imageUrl: url,
          bookTitle: title,
          bookDescription: desc,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onclick(
        context,
        this.title,
        this.imageUrl,
        this.description,
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: imageUrl==''?
              Image.asset(
                "assets/book_placeholder.png",
                fit: BoxFit.cover,
                height: 250,
                width: 175,
              ):
              Image.network(
                this.imageUrl,
                fit: BoxFit.cover,
                height: 250,
                width: 175,
              ),
            ),

            SizedBox(height: 10),

            Text(
              this.title,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}
