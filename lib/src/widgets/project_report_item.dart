import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_witness/src/controller/models/project_report.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProjectReportItem extends StatelessWidget {
  final ProjectReport projectReport;
  final Function(ProjectReport) showProjectReport;
  final Function(ProjectReport) publishProjectReport;
  final Function(ProjectReport) delete;

  ProjectReportItem({
    @required this.projectReport,
    @required this.showProjectReport,
    @required this.publishProjectReport,
    @required this.delete,
  });

  void deleteItem(ProjectReport projectReport) {
    delete(projectReport);
  }

  String getDescription(String description) {
    if (description.length > 10) {
      return 'Report: ' + description.substring(0, 10) + '...';
    } else {
      return 'Report: ' + description;
    }
  }

  Widget getItem(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          onTap: () {
            showProjectReport(projectReport);
          },
          leading: Icon(Icons.assignment),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(DateFormat.yMMMMd('en_US').format(projectReport.recordDate),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark, fontSize: 18)),
              SizedBox(width: 5),
              Text(
                DateFormat.Hm('en_US').format(projectReport.recordDate),
                style: TextStyle(
                      color: Theme.of(context).primaryColorDark, fontSize: 16),
              ),
            ],
          ),
          subtitle: Text(getDescription(projectReport.description),
              style: TextStyle(
                      color: Theme.of(context).primaryColorDark, fontSize: 14)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              !projectReport.isSended
                  ? IconButton(
                      icon: Icon(Icons.publish),
                      onPressed: () {
                        publishProjectReport(projectReport);
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.done, color: Colors.green),
                      onPressed: () {},
                    ),
              IconButton(
                icon: Icon(Icons.visibility),
                onPressed: () {
                  showProjectReport(projectReport);
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[],
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => delete(projectReport),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasPhotos = projectReport.projectReportPhotos.length > 0;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.blueGrey),
        ),
      ),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: getItem(context),
    );
  }
}
