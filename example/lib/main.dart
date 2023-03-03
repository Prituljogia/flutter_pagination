import 'package:example/user.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagination/flutter_pagination.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pagination ',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pagination ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: PaginationList<User>(
        physics: const AlwaysScrollableScrollPhysics(),

        shrinkWrap: true,
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        separatorWidget: Container(
          height: 0.5,
          color: Colors.black,
        ),
        itemBuilder: (BuildContext context, User user) {
          return ListTile(
            title:
            Text("${user.prefix} ${user.firstName} ${user.lastName}"),
            subtitle: Text(user.designation),
            leading: IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: (){},
            ),
            trailing: const Icon(
              Icons.call,
              color: Colors.green,
            ),
          );
        },
        pageFetch: pageFetch,
        onError: (dynamic error) => const Center(
          child: Text('Something Went Wrong'),
        ),
        initialData: <User>[
          User(
            faker.person.prefix(),
            faker.person.firstName(),
            faker.person.lastName(),
            faker.company.position(),
          ),
          User(
            faker.person.prefix(),
            faker.person.firstName(),
            faker.person.lastName(),
            faker.company.position(),
          ),
        ],
        onEmpty: const Center(
          child: Text('Empty List'),
        ),
      ),
    );
  }

  Future<List<User>> pageFetch(int offset) async {
    final Faker faker = Faker();
    final List<User> upcomingList = List.generate(
      15,
          (int index) => User(
        faker.person.prefix(),
        faker.person.firstName(),
        faker.person.lastName(),
        faker.company.position(),
      ),
    );
    await Future<List<User>>.delayed(
      const Duration(milliseconds: 1500),
    );
    return upcomingList;
  }
}
