import '/flutter_flow/flutter_flow_util.dart';
import 'tower_catalog_widget.dart' show TowerCatalogWidget;
import 'package:flutter/material.dart';

class TowerCatalogModel extends FlutterFlowModel<TowerCatalogWidget> {
  String? selectedBrandFilter;
  bool isFilterExpanded = false;

  @override
  void initState(BuildContext context) {
    selectedBrandFilter = null; // null means "All"
    isFilterExpanded = false;
  }

  @override
  void dispose() {}
}
