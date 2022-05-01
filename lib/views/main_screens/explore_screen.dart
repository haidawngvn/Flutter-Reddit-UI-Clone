import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../widgets/end_drawer.dart';
import '../../widgets/start_drawer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({ Key? key }) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const StartDrawer(),
        endDrawer: const EndDrawer(),
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
            Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();   //openenddrawer
                }, 
                child: const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/image/reddit_avatar.png'),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          // height: 60,
          color: seperateColor,
          child: ListView(
            children: [
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Column(
                  children: [
                    Material(
                      elevation: 2,
                      child: Container(               //category
                        height: 60,
                        color: seperateColor,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: const [
                                SizedBox(width: 12,),
                                CategoryButtons(name: "Art"),
                                CategoryButtons(name: "Technology"),
                                CategoryButtons(name: "Celebrity"),
                                CategoryButtons(name: "Fashion"),
                                CategoryButtons(name: "Beauty"),
                                CategoryButtons(name: "Funny"),
                                CategoryButtons(name: "Memes"),
                                CategoryButtons(name: "Television"),
                                CategoryButtons(name: "Food"),
                                CategoryButtons(name: "Movies"),
                                CategoryButtons(name: "Hobbies"),
                                SizedBox(width: 12,),
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
        ),
      ),
    );
  }
}

class CategoryButtons extends StatelessWidget {
  final String name;

  const CategoryButtons({
    Key? key, required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(26.0),
            top: Radius.circular(26.0)
          ),
          color: Colors.white,
        ),
        child: Text(name,style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),),
      ),
    );
  }
}