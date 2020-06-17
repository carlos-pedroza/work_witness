import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/models/employee.dart';
import 'package:work_witness/src/controller/models/project.dart';
import 'package:intl/intl.dart';
import 'package:work_witness/src/widgets/dialog_action.dart';

class ProjectCard extends StatelessWidget {
  final BuildContext context;
  final Employee employee;
  final Project project;
  final Function refreshProjects;

  ProjectCard({
    @required this.context,
    @required this.employee,
    @required this.project,
    @required this.refreshProjects,
  });

  onArchived(BuildContext context) {
    DialogAction.open(context, 'Archive project', 'Are you sure to archive this project, this action cannot be undone?',
     () {
        Controller.archive(project);
        refreshProjects();
     });
  }

  List<Widget> secondaryActions(BuildContext context) {
    List<Widget> actions = [];
    if (employee.isAccount) {
      actions.add(
        IconSlideAction(
          color: Theme.of(context).primaryColorDark.withOpacity(0.9),
          foregroundColor: Colors.red,
          icon: Icons.archive,
          onTap: () {
            onArchived(context);
          } ,
        ),
      );
    }
    return actions;
  }

  Widget title() {
    if (MediaQuery.of(context).size.width>350) {
      return Text(
                project.project,
                style: Theme.of(context).textTheme.bodyText1,
              );
    } else {
      return Text(
              project.project,
              style: Theme.of(context).textTheme.bodyText2,
            );
    }
  }

  Widget subTitle(_initialDate) {
    if (MediaQuery.of(context).size.width>350) {
      return Row(
          children: <Widget>[
            Icon(Icons.linear_scale, color: Theme.of(context).dividerColor),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                _initialDate,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            )
          ],
        );
    } else {
        return Row(
          children: <Widget>[
            Icon(Icons.linear_scale, color: Theme.of(context).dividerColor, size: 10,),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                _initialDate,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            )
          ],
        );
    }
  }

  Widget listTile(BuildContext context, String _initialDate) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(
            Icons.assignment,
            color: Colors.white,
            size: 48,
          ),
        ),
        title: title(),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
        subtitle: subTitle(_initialDate),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 48.0),
      ),
      actions: <Widget>[],
      secondaryActions: secondaryActions(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String _initialDate =
        DateFormat.yMMMMd('en_US').format(project.inictialDate);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.transparent,
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(child: listTile(context, _initialDate)),
      ),
    );
  }
}
