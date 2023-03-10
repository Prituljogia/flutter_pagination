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

static const _currentpage=1;
  late int totalpages;

  List<Datum> passengers = [];
  final PagingController<int, Datum> _pagingController =
      PagingController(firstPageKey: 0);

  Future<bool> getPassangersData(int pageKey) async {
    final Uri uri = Uri.parse(
        "https://api.instantwebtools.net/v1/passenger?page=$_currentpage&size=10");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final result = passengersDataFromJson(response.body);
      totalpages = result.totalPages;
      print(response.body);
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      getPassangersData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(

          child: RefreshIndicator(
            onRefresh: () => Future.sync(
                  () => _pagingController.refresh(),
            ),
            child: Container(
              child: PagedListView<int, Datum>.separated(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Datum>(
                    animateTransitions: true,
                    itemBuilder: (context, int, index) {
                      final passenger = passengers[index];

                      return ListTile(
                        leading: CircleAvatar(
                            radius: 25,
                            child: Image.network(
                              passenger.airline.first.logo,
                              fit: BoxFit.cover,
                            )),
                        title: Text(passenger.trips.toString()),
                        subtitle: Text(passenger.airline.first.country),
                      );
                    }),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          )
      )
       );

  }
}
