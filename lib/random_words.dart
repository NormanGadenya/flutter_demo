import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RandomWordsState();
  }

}

class RandomWordsState extends State<RandomWords>{
  final randomWordPairs = <WordPair>[];
  final savedWordPairs = Set<WordPair>();

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context,item){
          if(item.isOdd) return const Divider();
          final index = item ~/ 2;
          if(index >= randomWordPairs.length){
            randomWordPairs.addAll(generateWordPairs().take(10));
          }
          return buildRow(randomWordPairs[index]);
        }
    );
  }

  Widget buildRow(WordPair randomWordPair) {
    final alreadySaved = savedWordPairs.contains(randomWordPair);

    return ListTile(
        title: Text(randomWordPair.asString , style: const TextStyle(color: Colors.red)),
        trailing: Icon( alreadySaved ? Icons.favorite : Icons.favorite_border , color: alreadySaved ? Colors.red : Colors.black,),
      onTap: () {
          setState(() {
            if (alreadySaved){
              savedWordPairs.remove(randomWordPair);
            }else{
              savedWordPairs.add(randomWordPair);
            }
          });
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WordPair generator"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: pushSaved)
        ],

      ),
      body: _buildList(),
    );
  }

  pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context){
          final Iterable<ListTile> tiles = savedWordPairs.map((pair) => ListTile( title: Text(pair.asCamelCase)));
          final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: tiles
          ).toList();


          return Scaffold(
              appBar: AppBar(
                title: const Text("Saved word pairs"),
              ),
              body: ListView( children: divided)
          );
        })
    );

  }
}