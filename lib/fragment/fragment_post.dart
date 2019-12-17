import 'package:flutter/material.dart';
import 'package:learnflutter/add_post.dart';
import 'package:learnflutter/api/api_service.dart';
import 'package:learnflutter/model/post_model.dart';

class FragmentPost extends StatefulWidget {
  @override
  _FragmentPostState createState() => _FragmentPostState();
}

class _FragmentPostState extends State<FragmentPost> {
  ApiService apiService;
  BuildContext context;

  @override
  void initState(){
    super.initState();
    apiService = ApiService();
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar : AppBar(title: Text("Post"),backgroundColor: Colors.redAccent),
      body: FutureBuilder(
        //getprofilenya
        future: apiService.getProfiles(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
         //logika jika error dan gak error
          if (snapshot.hasError){
            return Center(child: Text(
              "Something Wrong : ${snapshot.error.toString()}",
            ),);
          }else if(snapshot.connectionState == ConnectionState.done){
            List<Post> posts = snapshot.data;
            return _buildListView(posts);
          }else {
            //progressbar kalo di android
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        //intent 
        onPressed: (){
          _settingModalBottomSheet(context);
        },
        // Navigator.of(context).push(
        //   new MaterialPageRoute(
        //     builder: (BuildContext context) => new AddPost(),
        //   )
        // ),
      ),
    );
  }

  void _settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext){
        return AddPost();
      }
    );
  }
}
//method build list view
Widget _buildListView(List<Post> posts) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
    child: ListView.builder(
      itemBuilder: (context, index) {
        Post post = posts[index];
        return Dismissible(
          key: UniqueKey(),
          background: Container(color : Colors.grey),
          onDismissed: (direction){
           ApiService apiService = ApiService();
           apiService.deletePost(post.id).then((isSuccess) {
             if(isSuccess){
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Delete Success"),
                ));
             }else {
               Scaffold.of(context).showSnackBar(SnackBar(
                 content: Text("Delete Fail"),
              ));
             }
           });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            child: new GestureDetector(
              onLongPress: (){
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (context){
                      return AddPost(post: post,);
                    })
                  );
              },
              child: Card(
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                  Text(
                    post.name,
                    style: Theme.of(context).textTheme.title,
                    
                  ),
                  Text(post.email),
                  Text(post.age.toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Swipe to Delete"
                      ),
                    ],
                  )
                ],
              ),
            ),
            ),
            )
            
            
          ),
          ));
      },
      itemCount: posts.length,
    )
  );
}
