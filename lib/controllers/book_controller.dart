import 'package:book_app/models/book_detail_response.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:book_app/models/book_list_response.dart';
import 'package:book_app/views/detail_book_page.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class BookController extends ChangeNotifier {
  // bookList? diambil dari BookListResponse variable yang dapat diakses darimanapun
  BookListResponse? bookList;

  fetchBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    //print(await http.read(Uri.https('example.com', 'foobar.txt')));
    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookList = BookListResponse.fromJson(jsonBookList);
      //setState(() {}); ini diganti dengan yang dibawah
      notifyListeners();
    }
  }

  BookDetailResponse? detailBook;

  fetchDetailBookApi(isbn) async {
    print(isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/books/$isbn');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    //print(await http.read(Uri.https('example.com', 'foobar.txt')));

    if (response.statusCode == 200) {
      final jsonDetail =
          jsonDecode(response.body); // dari string body menjadi sebuah json
      detailBook = BookDetailResponse.fromJson(
          jsonDetail); // melakukan parsing ke model dari json
      //setState(() {});
      notifyListeners();
      fetchSimiliarBookApi(detailBook!.title!);
    }
  }

  BookListResponse? similiarBooks;
  fetchSimiliarBookApi(String title) async {
    //print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/search/${title}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    //print(await http.read(Uri.https('example.com', 'foobar.txt')));

    if (response.statusCode == 200) {
      final jsonDetail =
          jsonDecode(response.body); // dari string body menjadi sebuah json
      similiarBooks = BookListResponse.fromJson(
          jsonDetail); // melakukan parsing ke model dari json
      //setState(() {});
      notifyListeners();
    }
  }
}
