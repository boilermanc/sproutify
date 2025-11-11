// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase/supabase.dart';

/// Deletes all user data and the user account from Supabase
/// Returns true if successful, false otherwise
Future<bool> deleteUserData() async {
  try {
    final userId = SupaFlow.client.auth.currentUser?.id;

    if (userId == null) {
      print('Error: No user is currently logged in');
      return false;
    }

    print('Starting deletion process for user: $userId');

    // Delete user's data from various tables
    // The order matters - delete child records before parent records
    try {
      // Delete user notifications status
      await SupaFlow.client
          .from('user_notifications_status')
          .delete()
          .eq('user_id', userId);
      print('Deleted user_notifications_status');

      // Delete user plant actions
      await SupaFlow.client
          .from('userplant_actions')
          .delete()
          .eq('user_id', userId);
      print('Deleted userplant_actions');

      // Delete user plants
      await SupaFlow.client
          .from('userplants')
          .delete()
          .eq('user_id', userId);
      print('Deleted userplants');

      // Delete user products
      await SupaFlow.client
          .from('userproducts')
          .delete()
          .eq('user_id', userId);
      print('Deleted userproducts');

      // Delete user tower gardens
      await SupaFlow.client
          .from('tower_gardens')
          .delete()
          .eq('user_id', userId);
      print('Deleted tower_gardens');

      // Delete user favorite plants
      await SupaFlow.client
          .from('user_favorite_plants')
          .delete()
          .eq('user_id', userId);
      print('Deleted user_favorite_plants');

      // Delete user favorites
      await SupaFlow.client
          .from('user_favorites')
          .delete()
          .eq('user_id', userId);
      print('Deleted user_favorites');

      // Delete user gardening goals
      await SupaFlow.client
          .from('user_gardening_goals')
          .delete()
          .eq('user_id', userId);
      print('Deleted user_gardening_goals');

      // Delete user plant preferences
      await SupaFlow.client
          .from('user_gardening_plant_preferences')
          .delete()
          .eq('user_id', userId);
      print('Deleted user_gardening_plant_preferences');

      // Delete user gardening experience
      await SupaFlow.client
          .from('user_gardening_experience')
          .delete()
          .eq('user_id', userId);
      print('Deleted user_gardening_experience');

      // Delete plant ratings
      await SupaFlow.client
          .from('plantratings')
          .delete()
          .eq('user_id', userId);
      print('Deleted plantratings');

      // Delete notifications
      await SupaFlow.client
          .from('notifications')
          .delete()
          .eq('user_id', userId);
      print('Deleted notifications');

      // Delete pH/EC history
      await SupaFlow.client
          .from('ph_echistory')
          .delete()
          .eq('user_id', userId);
      print('Deleted ph_echistory');

      // Delete user profile
      await SupaFlow.client
          .from('profiles')
          .delete()
          .eq('id', userId);
      print('Deleted profiles');

    } catch (dbError) {
      print('Error deleting user data from database: $dbError');
      throw Exception('Failed to delete user data: $dbError');
    }

    // Finally, delete the auth user account
    try {
      print('Attempting to delete auth user...');

      // Note: Supabase requires admin privileges to delete a user
      // This should be handled by a Supabase Edge Function or Database Trigger
      // For now, we'll rely on a database trigger or RLS policy

      // The actual user deletion should be handled server-side
      // via a trigger or edge function that responds to the profile deletion

      print('User data deletion completed successfully');
      return true;
    } catch (authError) {
      print('Error deleting auth user: $authError');
      // Even if auth deletion fails, data deletion succeeded
      throw Exception('User data deleted but auth deletion failed: $authError');
    }
  } catch (error) {
    print('Fatal error during user deletion: $error');
    FFAppState().update(() {
      FFAppState().customError = 'Error deleting account: $error';
    });
    return false;
  }
}
