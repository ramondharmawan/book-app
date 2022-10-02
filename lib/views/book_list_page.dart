import 'dart:convert';

import 'package:book_app/controllers/book_controller.dart';
import 'package:book_app/models/book_list_response.dart';
import 'package:book_app/views/detail_book_page.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookController? bookController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookController = Provider.of<BookController>(context,
        listen:
            false); // inisialisasi Provider -> ini cara menggunakan provider, dan <BookController> ini adalah tipenya
    bookController!
        .fetchBookApi(); // ditambahkan !(null safety karena BookController? -> boleh null)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Catalogue"),
      ),
      body: Consumer<BookController>(
        // consumer perlu jika memakai provider
        child: Center(child: CircularProgressIndicator()),
        builder: (context, controller, child) => Container(
          // child disini adalah parameter yang tidak akan dirender ulang oleh provider
          child: bookController!.bookList == null
              ? child // ini contoh yang tidak dirender ulang, walaupun ada perubahan hanya dihilangkan saja dari aplikasi kita
              : ListView.builder(
                  itemCount: bookController!.bookList!.books!.length,
                  itemBuilder: (context, index) {
                    final currrentBook =
                        bookController!.bookList!.books![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailBookPage(
                              isbn: currrentBook.isbn13!,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Image.network(
                            currrentBook.image!,
                            height: 100,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currrentBook.title!),
                                  Text(currrentBook.subtitle!),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Text(currrentBook.price!))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
