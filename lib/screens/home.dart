import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = nouns.take(50).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random English words'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (context, box, child) {
          return ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                final isFavorite = box.get(index) != null;
                return ListTile(
                  title: Text(word),
                  trailing: IconButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        if (isFavorite) {
                          await box.delete(index);
                          const snackbar = SnackBar(
                            content: Text('Removed Successfully'),
                            backgroundColor: Colors.red,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        } else {
                          await box.put(index, word);
                          const snackbar = SnackBar(
                            content: Text('Added Successfully'),
                            backgroundColor: Colors.blue,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      )),
                );
              });
        },
      ),
    );
  }
}
