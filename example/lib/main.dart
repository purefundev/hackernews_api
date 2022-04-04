import 'package:flutter/material.dart';
import 'package:hackernews_api/hackernews_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HackerNews news = HackerNews(
    newsType: NewsType.topStories,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          FutureBuilder(
              future: news.getStories(),
              builder: (context, AsyncSnapshot<List<Story>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) return Text(snapshot.error.toString());
                if (!snapshot.hasData) return const Text('No Data');

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    var title = data.title;

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(title),
                    );
                  },
                );
              })
        ],
      ))),
    );
  }
}
