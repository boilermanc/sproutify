import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/notifications/notification_component/notification_component_widget.dart';
import 'dart:ui';
import 'notifications_main_widget.dart' show NotificationsMainWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
