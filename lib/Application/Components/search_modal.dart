import 'package:anonforum/Application/Pages/home_page.dart';
import 'package:anonforum/Application/Provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchModal extends StatelessWidget {
  late final TextEditingController _search = TextEditingController();

  SearchModal({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Search"),
      content: SizedBox(
        height: 100,
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                Provider.of<SearchProvider>(context, listen: false)
                    .setSearchQuery(value);
              },
              controller: _search,
              decoration: InputDecoration(
                hintText: 'Search...',
                contentPadding: const EdgeInsets.all(12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(search: _search.text),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Search",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
