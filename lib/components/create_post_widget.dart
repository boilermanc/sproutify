import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/services/community_service.dart';
import '/flutter_flow/upload_data.dart';
import '/backend/supabase/database/tables/userplants.dart';
import '/backend/supabase/database/tables/my_towers.dart';
import '/backend/supabase/database/tables/plants.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for creating a new community post
class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({
    super.key,
    this.onPostCreated,
  });

  final VoidCallback? onPostCreated;

  @override
  State<CreatePostWidget> createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget> {
  SelectedFile? _selectedFile;
  TextEditingController? _captionController;
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;
  bool _isPosting = false;
  final int _maxCaptionLength = 500;
  
  // Tag selection
  List<int> _selectedPlantIds = [];
  int? _selectedTowerId;
  List<Map<String, dynamic>> _userPlants = [];
  List<Map<String, dynamic>> _userTowers = [];
  bool _isLoadingTags = false;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
    _loadUserTags();
  }
  
  Future<void> _loadUserTags() async {
    setState(() {
      _isLoadingTags = true;
    });
    
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) return;
      
      // Load user plants
      final plants = await UserplantsTable().queryRows(
        queryFn: (q) => q.eq('user_id', userId).eq('archived', false),
      );
      
      // Get plant details
      final plantDetails = <Map<String, dynamic>>[];
      for (final plant in plants) {
        if (plant.plantId != null) {
          try {
            final plantInfo = await PlantsTable().querySingleRow(
              queryFn: (q) => q.eq('plant_id', plant.plantId!),
            );
            if (plantInfo.isNotEmpty) {
              plantDetails.add({
                'id': plant.plantId!,
                'name': plantInfo.first.plantName,
              });
            }
          } catch (e) {
            print('Error loading plant info: $e');
          }
        }
      }
      
      // Load user towers
      final towers = await MyTowersTable().queryRows(
        queryFn: (q) => q.eq('user_id', userId).eq('archive', false),
      );
      
      final towerDetails = towers.map((tower) => {
        'id': tower.towerId,
        'name': tower.towerName,
      }).toList();
      
      setState(() {
        _userPlants = plantDetails;
        _userTowers = towerDetails;
        _isLoadingTags = false;
      });
    } catch (e) {
      print('Error loading user tags: $e');
      setState(() {
        _isLoadingTags = false;
      });
    }
  }
  
  /// Extract hashtags from caption text
  List<String> _extractHashtags(String text) {
    final hashtagRegex = RegExp(r'#(\w+)');
    final matches = hashtagRegex.allMatches(text);
    return matches.map((match) => match.group(1)!).toList();
  }

  @override
  void dispose() {
    _captionController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final mediaFiles = await selectMediaWithSourceBottomSheet(
      context: context,
      allowPhoto: true,
      allowVideo: false,
      imageQuality: 85,
      includeDimensions: true,
    );

    if (mediaFiles != null && mediaFiles.isNotEmpty) {
      setState(() {
        _selectedFile = mediaFiles.first;
      });
    }
  }

  double _calculateAspectRatio(MediaDimensions? dimensions) {
    if (dimensions == null || dimensions.width == null || dimensions.height == null) {
      return 1.0;
    }
    return dimensions.width! / dimensions.height!;
  }

  Future<void> _createPost() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a photo first'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload photo to Supabase Storage
      final photoUrl = await CommunityService.uploadPhoto(
        selectedFile: _selectedFile!,
      );

      setState(() {
        _isUploading = false;
        _isPosting = true;
      });

      // Calculate aspect ratio
      final aspectRatio = _calculateAspectRatio(_selectedFile!.dimensions);

      // Extract hashtags from caption
      final caption = _captionController!.text.trim();
      final hashtags = caption.isNotEmpty ? _extractHashtags(caption) : <String>[];
      
      // Create post
      final result = await CommunityService.createPost(
        photoUrl: photoUrl,
        photoAspectRatio: aspectRatio,
        caption: caption.isEmpty ? null : caption,
        plantIds: _selectedPlantIds.isNotEmpty ? _selectedPlantIds : null,
        towerId: _selectedTowerId,
        hashtagTags: hashtags.isNotEmpty ? hashtags : null,
      );

      if (result['success'] == true) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );

        // Reset form
        setState(() {
          _selectedFile = null;
          _captionController!.clear();
        });

        // Notify parent
        widget.onPostCreated?.call();

        // Navigate back
        if (mounted) {
          context.pop();
        }
      } else {
        throw Exception(result['error'] ?? 'Failed to create post');
      }
    } catch (e) {
      print('Error creating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create post: ${e.toString()}'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _isPosting = false;
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: true,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          'Create Post',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.outfit(
                  fontWeight: FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                ),
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Image picker section
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                    ),
                    child: _selectedFile == null
                        ? InkWell(
                            onTap: _pickImage,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  size: 64.0,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Tap to add photo',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        font: GoogleFonts.readexPro(),
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Camera or Gallery',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.readexPro(),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.memory(
                                  _selectedFile!.bytes,
                                  width: double.infinity,
                                  height: 300.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8.0,
                                right: 8.0,
                                child: InkWell(
                                  onTap: _removeImage,
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                // Caption input section
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: TextFormField(
                    controller: _captionController,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Caption (optional)',
                      labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.readexPro(),
                            letterSpacing: 0.0,
                          ),
                      hintText: 'Share your garden story...',
                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.readexPro(),
                            letterSpacing: 0.0,
                          ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 24.0, 16.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.readexPro(),
                          letterSpacing: 0.0,
                        ),
                    maxLines: 5,
                    maxLength: _maxCaptionLength,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) =>
                        Text(
                      '$currentLength / ${maxLength ?? _maxCaptionLength}',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.readexPro(),
                            color: maxLength != null && currentLength > maxLength * 0.9
                                ? FlutterFlowTheme.of(context).error
                                : FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                    validator: (value) {
                      if (value != null && value.length > _maxCaptionLength) {
                        return 'Caption must be $_maxCaptionLength characters or less';
                      }
                      return null;
                    },
                  ),
                ),
                // Tag selection section
                if (_isLoadingTags)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    ),
                  )
                else if (_userPlants.isNotEmpty || _userTowers.isNotEmpty)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plant tags
                        if (_userPlants.isNotEmpty) ...[
                          Text(
                            'Tag Plants (optional)',
                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                          ),
                          SizedBox(height: 8.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: _userPlants.map((plant) {
                              final isSelected = _selectedPlantIds.contains(plant['id']);
                              return FilterChip(
                                label: Text(plant['name'] as String),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedPlantIds.add(plant['id'] as int);
                                    } else {
                                      _selectedPlantIds.remove(plant['id'] as int);
                                    }
                                  });
                                },
                                selectedColor: FlutterFlowTheme.of(context).primary,
                                checkmarkColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context).primaryText,
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16.0),
                        ],
                        // Tower tag
                        if (_userTowers.isNotEmpty) ...[
                          Text(
                            'Tag Tower (optional)',
                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                          ),
                          SizedBox(height: 8.0),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: _userTowers.map((tower) {
                              final isSelected = _selectedTowerId == tower['id'];
                              return FilterChip(
                                label: Text(tower['name'] as String),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedTowerId = selected ? tower['id'] as int : null;
                                  });
                                },
                                selectedColor: FlutterFlowTheme.of(context).primary,
                                checkmarkColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : FlutterFlowTheme.of(context).primaryText,
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Tip: Use #hashtags in your caption to help others discover your post!',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  font: GoogleFonts.readexPro(),
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                // Loading indicator
                if (_isUploading || _isPosting)
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          _isUploading ? 'Uploading photo...' : 'Creating post...',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.readexPro(),
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                // Post button
                if (_selectedFile != null && !_isUploading && !_isPosting)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
                    child: FFButtonWidget(
                      onPressed: _createPost,
                      text: 'Post',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                              ),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  )
                else
                  SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

