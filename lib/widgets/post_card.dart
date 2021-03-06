import 'dart:convert';

import 'package:flutter/material.dart';
import '../constants/custom_icons.dart';
import '../models/post.dart';
import '../models/reddit.dart';
import '../views/function_screens/channel_screen.dart';
import '../views/function_screens/chat_box_screen.dart';
import '../views/function_screens/post_detail_screen.dart';
import '../widgets/dialog_option_without_tick.dart';

import '../constants/colors.dart';
import '../models/redditor.dart';
import '../views/function_screens/profile_screen.dart';

class PostCard extends StatefulWidget {
  
  final Post post;

  const PostCard({ Key? key, required this.post }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  
  late Redditor redditor;
  late Reddit reddit;
  bool isVoted = false;

  void getRedditor(BuildContext context) async{
    String data = await DefaultAssetBundle.of(context).loadString("assets/redditor.json");
    var tagObjsJson = jsonDecode(data)['redditor'] as List;
    List<Redditor> redditors = tagObjsJson.map((tagJson) => Redditor.fromJSON(tagJson)).toList();
    for (Redditor r in redditors){
      if (r.name == widget.post.username){
        redditor = r;
      }
    }
  }

  void getReddit(BuildContext context) async{
    String data = await DefaultAssetBundle.of(context).loadString("assets/reddit.json");
    var tagObjsJson = jsonDecode(data)['reddit'] as List;
    List<Reddit> reddits = tagObjsJson.map((tagJson) => Reddit.fromJSON(tagJson)).toList();
    for (Reddit r in reddits){
      if (r.name == widget.post.channel){
        reddit = r;
      }
    }
  }

  void changeColor() {
    if (isVoted == true ){
      setState(() {
        isVoted = false;
      });
    }
    else{
      setState(() {
        isVoted = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRedditor(context);
    getReddit(context);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostDetailScreen(post: widget.post)));
          },
          child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(    //row contain channel avt, channel name, username, post time, join button
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(widget.post.avatarUrl),
                      backgroundColor: seperateColor,
                    ),
                    const SizedBox(width: 8,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 100)).then((value) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChannelScreen(reddit: reddit)));
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text("r/"+widget.post.channel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                            )),
                        ),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              showGeneralDialog(
                                context: context, 
                                transitionDuration: const Duration(milliseconds: 310),
                                barrierDismissible: true,
                                barrierLabel: "Barrier",
                                barrierColor: Colors.black.withOpacity(0.6),
                                transitionBuilder: (_, anim, __, child) {
                                  Tween<Offset> tween;
                                  if (anim.status == AnimationStatus.reverse) {
                                    tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
                                  } else {
                                    tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
                                  }
                                  return SlideTransition(
                                    position: tween.animate(anim),
                                    child: FadeTransition(
                                      opacity: anim,
                                      child: child,
                                    ),
                                  );
                                },
                                pageBuilder: (_,__,___) => Dialog(
                                  alignment: Alignment.center,
                                  // insetPadding: EdgeInsets.only(top: 100),
                                  insetPadding: EdgeInsets.zero,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.95,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(12.0),
                                        top: Radius.circular(12.0)
                                      ),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DialogHead(username: widget.post.username,),
                                        Material(
                                          color: Colors.white,
                                          child: InkWell(
                                            onTap: () {
                                              Future.delayed(const Duration(milliseconds: 100)).then((value) {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(redditor: redditor, doublePop: true,)));
                                              });
                                            },
                                            child: const DialogOption2(icon: Icons.person, text: 'View Profile'),
                                          ),
                                        ),
                                        Material(
                                          color: Colors.white,
                                          child: InkWell(
                                            onTap: () {
                                              Future.delayed(const Duration(milliseconds: 100)).then((value) {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatBoxScreen(redditor: redditor, doublePop: true,)));
                                              });
                                            },
                                            child: const DialogOption2(icon: Icons.chat, text: 'Start Chat')
                                          ),
                                        ),
                                        const DialogOption2(icon: CustomIcon.block, text: 'Block Account'),
                                      ],
                                    ),
                                  ),
                                ) 
                              );
                              
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Row(
                                children: [
                                  Text("u/"+widget.post.username + " ", style: const TextStyle(color: textColor2, fontSize: 14),),
                                  const Icon(Icons.circle, color: textColor2,size: 4,),
                                  Text(" " + widget.post.time, style: const TextStyle(color: textColor2, fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(child: Container()),
                    widget.post.isMember == "true" 
                    ? Container()
                    : Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(26.0),
                          top: Radius.circular(26.0)
                        ),
                        color: darkblue,
                      ),
                      child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                    const Icon(Icons.more_vert, color: textColor2,size: 20,)
                  ],
                ),
                widget.post.awards == 0          //award cua~ post
                ? Container()
                : widget.post.awards == 1
                ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage('assets/image/aw1.jpg'),
                      ),
                      SizedBox(width: 4,),
                      Text('1 Award', style: TextStyle(color: textColor2, fontSize: 12),)
                    ],
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage('assets/image/aw2.jpg'),
                      ),
                      SizedBox(width: 4,),
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: AssetImage('assets/image/aw3.jpg'),
                      ),
                      SizedBox(width: 4,),
                      Text('2 Awards', style: TextStyle(color: textColor2, fontSize: 12),)
                    ],
                  ),
                ),
                Hero(
                  tag: {widget.post.title},
                  child: Padding(                                //title
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Text(widget.post.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                ),
                widget.post.caption != "" 
                ? Hero(tag: {widget.post.caption},child: Text(widget.post.caption, style: const TextStyle(color: textColor2,fontSize: 12),))
                : widget.post.imageUrl != ""
                ? Hero(
                  tag: {widget.post.imageUrl},
                  child: Image(
                    image: AssetImage(widget.post.imageUrl),
                    fit: BoxFit.fitWidth,
                  ),
                )
                : Container(),
                Padding(                                      //bottom cua post card
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Row(
                              children: [
                                Material(
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: changeColor,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                                      child: Icon(
                                        CustomIcon.up_bold,
                                        color: isVoted == true ? Colors.green : textColor2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Text(
                                  widget.post.upvotes.toString(), 
                                  style: TextStyle(
                                    color: isVoted ? Colors.green : textColor2, 
                                    fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 8,),
                                const Icon(CustomIcon.down_bold, color: textColor2,),
                      
                              ],
                            )),
                            Expanded(child: Row(
                              children: [
                                const SizedBox(width: 8,),
                                const Icon(Icons.chat_bubble_outline, color: textColor2,),
                                const SizedBox(width: 8,),
                                Text(widget.post.comments.toString(), style: const TextStyle(color: textColor2, fontWeight: FontWeight.w600),)
                              ],
                            )),
                          ],
                        )
                      ),
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: const [
                                  Icon(Icons.share_outlined, color: textColor2,),
                                  SizedBox(width: 8,),
                                  Text('Share', style: TextStyle(color: textColor2, fontWeight: FontWeight.w600),)
                                ],
                              ),
                            ),
                            const Icon(Icons.card_giftcard_outlined, color: textColor2,),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
              ),
        ),
      Container(color: seperateColor, height: 8,)
      ]
    );
  }
}

class DialogHead extends StatelessWidget {

  const DialogHead({
    Key? key, required this.username,
  }) : super(key: key);

  final String username;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,    //center casc children
              children: [
              Container(
                color: Colors.white,
                height: 200, 
                width: MediaQuery.of(context).size.width*0.66, 
              ),
            Positioned(
              top: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                                          
                      },
                      child: const Image(
                        image: AssetImage('assets/image/reddit_figure.png'),
                        height: 160,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('u/'+username, style:const TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              )
            ),
            
          ],
        )
        ],
      ),
      const SizedBox(height: 8,),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const[
                Text('--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 4,),
                Text('Post Karma', style: TextStyle(color: textColor2),)
              ],
            )
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 4,),
                Text('Comment Karma', style: TextStyle(color: textColor2),)
              ],
            )
          )
        ],
      ),
      const SizedBox(height: 12,),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const[
                Text('--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 4,),
                Text('Awarder Karma', style: TextStyle(color: textColor2),)
              ],
            )
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('--', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(height: 4,),
                Text('Awardee Karma', style: TextStyle(color: textColor2),)
              ],
            )
          )
        ],
      ),
      const SizedBox(height: 8,),

      ],
    );
  }
}