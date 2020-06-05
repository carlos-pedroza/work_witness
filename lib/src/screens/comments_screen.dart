import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/models/comment.dart';
import 'package:work_witness/src/controller/models/project.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';

class CommentsScreen extends StatefulWidget {
  final Project project;

  CommentsScreen({@required this.project});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool loading = false;
  List<Comment> comments = List<Comment>();
  String comment = '';

  @override
  void initState() {
    readComments();
    super.initState();
  }

  void readComments() {
    setState(() {
      loading = true;
    });
    Controller.listComments(widget.project.id).then((List<Comment> _comments) {
      setState(() {
        comments = _comments;
        loading = false;
        comment = '';
      });
    });
  }

  void add() {
    Controller.insertComment(
      Comment(
        id: null,
        idProject: widget.project.id,
        idEmployee: widget.project.idEmployee,
        employee: '',
        commentValue: comment,
        created: DateTime.now(),
        disabled: false,
      ),
    ).then((_) {
      readComments();
    });
  }

  Widget itemComment(Comment comment) {
    var idEmployee = widget.project.idEmployee;
    if (comment.idEmployee == idEmployee) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: CommentCard(commentItem: comment, idEmployee: idEmployee),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: CommentCard(commentItem: comment, idEmployee: idEmployee),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text('Work Witness',
            style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        key: UniqueKey(),
                        initialValue: comment,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'comment',
                        ),
                        onChanged: (String value) {
                          comment = value;
                        },
                        onEditingComplete: add,
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.send,
                            color: Theme.of(context).primaryColorDark),
                        onPressed: add,
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: !loading
                  ? Container(
                      child: ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (BuildContext context, int i) {
                          return itemComment(comments[i]);
                        },
                      ),
                    )
                  : LoadingIndicator(size: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment commentItem;
  final int idEmployee;

  CommentCard({
    @required this.commentItem,
    @required this.idEmployee,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      color: commentItem.idEmployee != idEmployee
          ? Colors.teal[100]
          : Colors.grey[50],
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              commentItem.employee,
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
            Text(
              commentItem.commentValue,
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
