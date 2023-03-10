import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/passenger_data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentpage = 1;

  late int totalpages;

  List<Datum> passengers = [];
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> getPassangersData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentpage = 1;
    } else {
      if (currentpage >= totalpages) {
        refreshController.loadNoData();
        return false;
      }
    }

    final Uri uri = Uri.parse(
        "https://api.instantwebtools.net/v1/passenger?page=$currentpage&size=10");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final result = passengersDataFromJson(response.body);

      if (isRefresh) {
        passengers = result.data;
      } else {
        passengers.addAll(result.data);
      }


      currentpage++;
      totalpages = result.totalPages;

      print(response.body);
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("PassangerData Api calling",
              style: TextStyle(color: Colors.white)),
        ),
        body: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          onRefresh: () async {
            final result = await getPassangersData(isRefresh: true);
            if (result) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result = await getPassangersData();
            if (result) {
              refreshController.loadComplete();
            } else {
              refreshController.loadFailed();
            }
          },
          child: ListView.separated(
              itemBuilder: (context, index) {
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
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: passengers.length),
        ));
  }
}
