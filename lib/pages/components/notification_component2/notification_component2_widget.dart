import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notification_component2_model.dart';
export 'notification_component2_model.dart';

class NotificationComponent2Widget extends StatefulWidget {
  const NotificationComponent2Widget({
    super.key,
    this.parameter1,
    required this.userID,
  });

  final String? parameter1;
  final String? userID;

  @override
  State<NotificationComponent2Widget> createState() =>
      _NotificationComponent2WidgetState();
}

class _NotificationComponent2WidgetState
    extends State<NotificationComponent2Widget> {
  late NotificationComponent2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationComponent2Model());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10.0, 40.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Notifications',
                    style: FlutterFlowTheme.of(context).headlineLarge.override(
                          fontFamily: 'Outfit',
                          fontSize: 28.0,
                        ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await ProfilesTable().update(
                          data: {
                            'last_notification_read_time':
                                supaSerialize<DateTime>(getCurrentTimestamp),
                          },
                          matchingRows: (rows) => rows.eq(
                            'id',
                            currentUserUid,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: FutureBuilder<ApiCallResponse>(
                      future: FetchNewNotficationsCall.call(
                        userID: widget.userID,
                      ),
                      builder: (context, snapshot) {
                        // Customize what your widget looks like when it's loading.
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            ),
                          );
                        }
                        final listViewFetchNewNotficationsResponse =
                            snapshot.data!;
                        return Builder(
                          builder: (context) {
                            final notifications =
                                listViewFetchNewNotficationsResponse.jsonBody
                                    .toList();
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: notifications.length,
                              itemBuilder: (context, notificationsIndex) {
                                final notificationsItem =
                                    notifications[notificationsIndex];
                                return Container(
                                  decoration: BoxDecoration(),
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: ExpandableNotifier(
                                      initialExpanded: false,
                                      child: ExpandablePanel(
                                        header: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (getJsonField(
                                              notificationsItem,
                                              r'''$.is_new''',
                                            ))
                                              FlutterFlowIconButton(
                                                borderColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                borderRadius: 20.0,
                                                borderWidth: 1.0,
                                                buttonSize: 15.0,
                                                fillColor: Color(0xFFE02222),
                                                disabledColor:
                                                    Color(0xFFE02222),
                                                disabledIconColor:
                                                    Color(0xFFE02222),
                                                icon: Icon(
                                                  Icons.lens_rounded,
                                                  color: Color(0xFFE02222),
                                                  size: 0.0,
                                                ),
                                                onPressed: !getJsonField(
                                                  notificationsItem,
                                                  r'''$.is_new''',
                                                )
                                                    ? null
                                                    : () {
                                                        print(
                                                            'IconButton pressed ...');
                                                      },
                                              ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        10.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  getJsonField(
                                                    notificationsItem,
                                                    r'''$.title''',
                                                  ).toString(),
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 16.0,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            if (functions
                                                        .returnDateYYYYMMDD() !=
                                                    null &&
                                                functions
                                                        .returnDateYYYYMMDD() !=
                                                    '')
                                              Text(
                                                getJsonField(
                                                  notificationsItem,
                                                  r'''$.formatted_time_created''',
                                                ).toString(),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 16.0,
                                                        ),
                                              ),
                                          ],
                                        ),
                                        collapsed: Container(),
                                        expanded: Container(
                                          decoration: BoxDecoration(),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                getJsonField(
                                                  notificationsItem,
                                                  r'''$.description''',
                                                ).toString(),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily: 'Readex Pro',
                                                      color: Color(0x8A000000),
                                                      fontSize: 16.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        theme: ExpandableThemeData(
                                          tapHeaderToExpand: true,
                                          tapBodyToExpand: false,
                                          tapBodyToCollapse: false,
                                          headerAlignment:
                                              ExpandablePanelHeaderAlignment
                                                  .center,
                                          hasIcon: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
