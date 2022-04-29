import 'package:flutter/material.dart';
import 'package:midterm_519h0277/constants/colors.dart';
import 'package:midterm_519h0277/widgets/start_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const StartDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          color: seperateColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey),
                    icon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    )
                  ),
                )
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {

            }, 
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/reddit_avatar.png'),
            ),
          ),
        ],
      ),
    );
  }
}