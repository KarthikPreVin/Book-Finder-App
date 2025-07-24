import 'package:flutter/material.dart';

class BookPopUpScreen extends StatefulWidget {
  final String imageUrl;
  final String bookTitle;
  final String bookDescription;

  const BookPopUpScreen({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    required this.bookDescription,
  });

  @override
  State<BookPopUpScreen> createState() => _BookPopUpScreenState();
}

class _BookPopUpScreenState extends State<BookPopUpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Book", style: TextStyle(color: Color(0xFFF5F5DC)),
          ),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: widget.imageUrl==''?
                Image.asset(
                  "assets/book_placeholder.png",
                  fit: BoxFit.cover,
                  height: 250,
                  width: 175,
                ):
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  height: 250,
                  width: 175,
                ),
              ),

              const SizedBox(height: 20),

              // Text below the image
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.bookTitle,
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    )
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0), // Adds padding around text
                child: Text(
                  widget.bookDescription,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}