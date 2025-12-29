import '/flutter_flow/flutter_flow_util.dart';
import '/notifications/notification_component/notification_component_widget.dart';
import 'notifications_main_widget.dart' show NotificationsMainWidget;
import 'package:flutter/material.dart';

class NotificationsMainModel extends FlutterFlowModel<NotificationsMainWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for notificationComponent component.
  late NotificationComponentModel notificationComponentModel;

  @override
  void initState(BuildContext context) {
    notificationComponentModel =
        createModel(context, () => NotificationComponentModel());
  }

  @override
  void dispose() {
    notificationComponentModel.dispose();
  }
}
