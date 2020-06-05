import 'package:flutter/foundation.dart';

class Settings {
  static final EnviromentEnum enviroment = EnviromentEnum.qas;
}

enum EnviromentEnum {
  qas,
  prod,
}

enum EndpointsEnum {
  employeeEmailLogin,
  employeeLogin,
  employee,
  project,
  projects,
  check,
  projectTypeQuestion,
  lastCheck,
  projectReport,
  listProjectReport,
  getProjectReport,
  projectReportQuestion,
  listProjectReportQuestion,
  getProjectReportQuestion,
  projectReportPhoto,
  listProjectReportPhoto,
  getProjectReportPhoto,
  uploadProjectReportPhoto,
  comment,
  listComments,
  photos,
  listSubscription,
  listSubscriptionBenefits,
  subscribeAccount,
  projectProjectTypes
}

class Endpoints {
  static String url(EndpointsEnum item) {
    if (Settings.enviroment == EnviromentEnum.qas) {
      switch (item) {
        case EndpointsEnum.employeeEmailLogin:
          return 'https://api.work-witness.app/api/employee-email-login';
        case EndpointsEnum.employeeLogin:
          return 'https://api.work-witness.app/api/employee-login';
        case EndpointsEnum.employee:
          return 'https://api.work-witness.app/api/employee';
        case EndpointsEnum.project:
          return 'https://api.work-witness.app/api/project';
        case EndpointsEnum.projects:
          return 'https://api.work-witness.app/api/list-view-project-employee';
        case EndpointsEnum.check:
          return 'https://api.work-witness.app/api/project-check';
        case EndpointsEnum.projectTypeQuestion:
          return 'https://api.work-witness.app/api/list-project-type-question';
        case EndpointsEnum.lastCheck:
          return 'https://api.work-witness.app/api/last-project-check';
        case EndpointsEnum.projectReport:
          return 'https://api.work-witness.app/api/project-report';
        case EndpointsEnum.listProjectReport:
          return 'https://api.work-witness.app/api/list-project-report';
        case EndpointsEnum.getProjectReport:
          return 'https://api.work-witness.app/api/get-project-report';
        case EndpointsEnum.projectReportQuestion:
          return 'https://api.work-witness.app/api/project-report-question';
        case EndpointsEnum.listProjectReportQuestion:
          return 'https://api.work-witness.app/api/list-project-report-question';
        case EndpointsEnum.getProjectReportQuestion:
          return 'https://api.work-witness.app/api/get-project-report-question';
        case EndpointsEnum.projectReportPhoto:
          return 'https://api.work-witness.app/api/project-report-photo';
        case EndpointsEnum.listProjectReportPhoto:
          return 'https://api.work-witness.app/api/list-project-report-photo';
        case EndpointsEnum.getProjectReportPhoto:
          return 'https://api.work-witness.app/api/get-project-report-photo';
        case EndpointsEnum.uploadProjectReportPhoto:
          return 'https://api.work-witness.app/api/upload-project-report-photo';
        case EndpointsEnum.comment:
          return 'https://api.work-witness.app/api/project-comment';
        case EndpointsEnum.listComments:
          return 'https://api.work-witness.app/api/list-comments';
        case EndpointsEnum.photos:
          return 'https://api.work-witness.app/project-report-photo/';
        case EndpointsEnum.listSubscription:
          return 'https://api.work-witness.app/api/list-subscription/';
        case EndpointsEnum.listSubscriptionBenefits:
          return 'https://api.work-witness.app/api/list-subscription-benefits/';
        case EndpointsEnum.subscribeAccount:
          return 'https://api.work-witness.app/api/subscribe-account/';
        case EndpointsEnum.projectProjectTypes:
          return 'https://api.work-witness.app/api/list-project-project-types/';
        default:
          return null;
      }
    } else if (Settings.enviroment == EnviromentEnum.prod) {
      switch (item) {
        case EndpointsEnum.employeeEmailLogin:
          return 'https://api.work-witness.app/api/employee-email-login';
        case EndpointsEnum.employeeLogin:
          return 'https://api.work-witness.app/api/employee-login';
        case EndpointsEnum.employee:
          return 'https://api.work-witness.app/api/employee';
        case EndpointsEnum.project:
          return 'https://api.work-witness.app/api/project';
        case EndpointsEnum.projects:
          return 'https://api.work-witness.app/api/list-view-project-employee';
        case EndpointsEnum.check:
          return 'https://api.work-witness.app/api/project-check';
        case EndpointsEnum.projectTypeQuestion:
          return 'https://api.work-witness.app/api/list-project-type-question';
        case EndpointsEnum.lastCheck:
          return 'https://api.work-witness.app/api/last-project-check';
        case EndpointsEnum.projectReport:
          return 'https://api.work-witness.app/api/project-report';
        case EndpointsEnum.listProjectReport:
          return 'https://api.work-witness.app/api/list-project-report';
        case EndpointsEnum.getProjectReport:
          return 'https://api.work-witness.app/api/get-project-report';
        case EndpointsEnum.projectReportQuestion:
          return 'https://api.work-witness.app/api/project-report-question';
        case EndpointsEnum.listProjectReportQuestion:
          return 'https://api.work-witness.app/api/list-project-report-question';
        case EndpointsEnum.getProjectReportQuestion:
          return 'https://api.work-witness.app/api/get-project-report-question';
        case EndpointsEnum.projectReportPhoto:
          return 'https://api.work-witness.app/api/project-report-photo';
        case EndpointsEnum.listProjectReportPhoto:
          return 'https://api.work-witness.app/api/list-project-report-photo';
        case EndpointsEnum.getProjectReportPhoto:
          return 'https://api.work-witness.app/api/get-project-report-photo';
        case EndpointsEnum.uploadProjectReportPhoto:
          return 'https://api.work-witness.app/api/upload-project-report-photo';
        case EndpointsEnum.comment:
          return 'https://api.work-witness.app/api/project-comment';
        case EndpointsEnum.listComments:
          return 'https://api.work-witness.app/api/list-comments';
        case EndpointsEnum.photos:
          return 'https://api.work-witness.app/project-report-photo/';
        case EndpointsEnum.listSubscription:
          return 'https://api.work-witness.app/api/list-subscription/';
        case EndpointsEnum.listSubscriptionBenefits:
          return 'https://api.work-witness.app/api/list-subscription-benefits/';
        case EndpointsEnum.subscribeAccount:
          return 'https://api.work-witness.app/api/subscribe-account/';
        case EndpointsEnum.projectProjectTypes:
          return 'https://api.work-witness.app/api/list-project-project-types/';
        default:
          return null;
      }
    }
  }
}
