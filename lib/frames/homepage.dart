import "package:flutter/material.dart";
import "Book.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color bg = Colors.purple;
  Color fg = Color(0xFFF5F5DC);
  List<Book> books = [];
  void _bookmarks() {}

  void _settings() {
    Navigator.pushNamed(context, '/settings');
  }

  void _search() {
    Navigator.pushNamed(context, '/search');
  }


  Widget displayBook() {
    if (books.isEmpty) {
      return Column(
        children: [

          Text(
            '''📚 Welcome to Book Finder! 🌟
            
            
Discover your next favorite read with ease! Whether you're searching for timeless classics, hidden gems, or the latest bestsellers, Book Finder connects you to a world of stories at your fingertips.

🔍 Search effortlessly – Find books by title, author, or genre.

📖 Discover new favorites – Get personalized recommendations and trending picks.

📚 Save & Explore – Build your own reading list and never lose track of a great book again!

Start your journey now—your next great read is just a tap away!🚀📖
      ''',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          ElevatedButton(
            onPressed: _search,
            child: Text("Find Books", style: TextStyle(fontSize: 20)),
          ),

          Text(
            "\nCreated by: Karthik V, Kushaal Shyam, Padmashri R",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }
    return GridView.builder(
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
    );
  }

  @override
  void initState() {
    super.initState();
    books = <Book>[

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BOOK FINDER APP", style: TextStyle(color: fg)),
        backgroundColor: bg,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10), child: displayBook()),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border.all(width: 3.0)),
        child: BottomAppBar(
          color: Colors.purple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _bookmarks,
                icon: Icon(Icons.home),
                iconSize: 40,
                padding: EdgeInsets.zero,
                tooltip: "view saved books",
                color: Colors.red,
              ),
              IconButton(
                onPressed: _search,
                icon: Icon(Icons.search),
                iconSize: 40,
                padding: EdgeInsets.zero,
                tooltip: "search new books",
              ),
              IconButton(
                onPressed: _settings,
                icon: Icon(Icons.settings),
                iconSize: 40,
                padding: EdgeInsets.zero,
                tooltip: "go to settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
