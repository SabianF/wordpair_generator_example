import "package:flutter/material.dart";
import "package:english_words/english_words.dart";

class RandomWords extends StatefulWidget {
  RandomWords({Key? key}) : super(key: key);

  @override 
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        if(item.isOdd) return Divider();

        final index = item ~/ 2;

        if(index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      },
      physics: AlwaysScrollableScrollPhysics(),
    );
  }

  // This is the widget to generate each list item as a word pair
  Widget _buildRow(WordPair pair) {

    // This is the variable to check saved word pairs
    final alreadySaved = _savedWordPairs.contains(pair);

    // ListTile is the widget for each item, row, or "tile"
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(fontSize: 24),
      ),
      // showing an icon after the list item
      trailing: Icon(
        (alreadySaved ? Icons.favorite : Icons.favorite_border),
        color: (alreadySaved ? Colors.red : null),
      ),
      onTap: () {
        setState(
          () {
            if(alreadySaved) {
              _savedWordPairs.remove(pair);
            } else {
              _savedWordPairs.add(pair);
            }
          }
        );
      }
    );
  }

  // This implements the stacked navigation screens.
  //
  // We're using this to add the "saved pairs" screen that we can
  // use to display filtered list of saved word pairs
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {

            final alreadySaved = _savedWordPairs.contains(pair);

            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: TextStyle(fontSize: 24),
              ),

              trailing: Icon(
                (alreadySaved ? Icons.favorite : Icons.favorite_border),
                color: (alreadySaved ? Colors.red : null),
              ),

              onTap: () {
                setState(() {
                  if(!alreadySaved) {
                    _savedWordPairs.add(pair);
                  } else {
                    _savedWordPairs.remove(pair);
                  }
                  // Janky: To refresh the list and remove all unfavourited items
                  Navigator.pop(context);
                  if(_savedWordPairs.isNotEmpty) {
                    _pushSaved();
                  }
                });
              }
            );
          });
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text("Saved Word Pairs"),
            ),
            body: ListView(
              children: divided,
            ),
          );
        }
      )
    );
  }

  // This is the widget for the main word pair list screen
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Wordpair Generator"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: _pushSaved,
          ),
        ]
      ),
      body: _buildList()
    );
  }
}
