import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override 
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final _randomWordPairs = <WordPair>[];
  final _savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if(item.isOdd) return Divider();

        final index = item ~/ 2;

        if(index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair) {

    // variable to store saved word pairs
    final alreadySaved = _savedWordPairs.contains(pair);

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

  Widget build(BuildContext context) {

  // This implements the stacked navigation screens.
  //
  // We're using this to add the "saved pairs" screen that we can
  // use to display filtered list of saved word pairs
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: TextStyle(fontSize: 24),
              )
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
  };

    return Scaffold(
      appBar: AppBar(
        title: Text("Wordpair Generator"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          ),
        ]
      ),
      body: _buildList()
    );
  }
}
