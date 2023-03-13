import 'package:example/listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:http/http.dart' as http;

import 'model/passenger_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int page = 0;


  final PagingController<int, Datum> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getPassangersData(pageKey);
    });

    super.initState();
  }

  Future<void> _getPassangersData(int pageKey) async {
    try {
      final Uri uri = Uri.parse(
          "https://api.instantwebtools.net/v1/passenger?page=$page&size=10");

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        passengersDataFromJson(response.body);
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title:
              Text("PassangerData Api ", style: TextStyle(color: Colors.white)),
        ),
        body:  RefreshIndicator(


          onRefresh: () => Future.sync(
                 () => _pagingController.refresh(),
                  ),
       child: PagedListView<int,Datum>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Datum>(
            itemBuilder: (context, item, index) =>  ListItem(
              passenger: item,
            ) ,
          ),
        )
        )




          );
  }
   @override
    void dispose() {
      _pagingController.dispose();
      super.dispose();
    }
}
