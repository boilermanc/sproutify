import 'dart:async';

import 'package:flutter/material.dart';
import '/auth/auth_manager.dart';
import '/backend/supabase/supabase.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'email_auth.dart';
import 'google_auth.dart';

import 'supabase_user_provider.dart';

export '/auth/base_auth_user_provider.dart';

class SupabaseAuthManager extends AuthManager
    with EmailSignInManager, GoogleSignInManager {
  @override
  Future signOut() {
    return SupaFlow.client.auth.signOut();
  }

  @override
  Future deleteUser(BuildContext context) async {
    try {
      if (!loggedIn) {
        print('Error: delete user attempted with no logged in user!');
        return;
      }
      await currentUser?.delete();
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  @override
  Future updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        print('Error: update email attempted with no logged in user!');
        return;
      }
      await currentUser?.updateEmail(email);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Email change confirmation email sent'),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
      ),
    );
  }

  Future<bool> updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        print('Error: update password attempted with no logged in user!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You must be logged in to update your password',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                fontSize: 16.0,
              ),
            ),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: Duration(seconds: 3),
          ),
        );
        return false;
      }
      await currentUser?.updatePassword(newPassword);
      return true;
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      // Clean up error messages
      String errorMessage = e.message;
      if (errorMessage.toLowerCase().contains('password') && 
          (errorMessage.toLowerCase().contains('6') || 
           errorMessage.toLowerCase().contains('minimum') ||
           errorMessage.toLowerCase().contains('length'))) {
        errorMessage = 'Password must be at least 8 characters and meet all requirements';
      } else if (errorMessage.toLowerCase().contains('password')) {
        errorMessage = 'Password does not meet requirements. Please check all password requirements.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              fontSize: 16.0,
            ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: Duration(seconds: 4),
        ),
      );
      return false;
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred while updating your password. Please try again.',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              fontSize: 16.0,
            ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: Duration(seconds: 4),
        ),
      );
      return false;
    }
  }

  Future<void> exchangeCodeForSession(String code) async {
    try {
      await SupaFlow.client.auth.exchangeCodeForSession(code);
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'Unknown error occurred';
    }
  }

  @override
  Future<bool> resetPassword({
    required String email,
    required BuildContext context,
    String? redirectTo,
  }) async {
    try {
      await SupaFlow.client.auth
          .resetPasswordForEmail(email, redirectTo: redirectTo);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return false;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset email sent'),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        duration: Duration(seconds: 5),
      ),
    );
    return true;
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailSignInFunc(email, password),
      );

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailCreateAccountFunc(email, password),
      );

  @override
  Future<BaseAuthUser?> signInWithGoogle(BuildContext context) =>
      _signInOrCreateAccount(context, googleSignInFunc);

  /// Tries to sign in or create an account using Supabase Auth.
  /// Returns the User object if sign in was successful.
  Future<BaseAuthUser?> _signInOrCreateAccount(
    BuildContext context,
    Future<User?> Function() signInFunc,
  ) async {
    try {
      final user = await signInFunc();
      final authUser = user == null ? null : SproutifyHomeSupabaseUser(user);

      // Update currentUser here in case user info needs to be used immediately
      // after a user is signed in. This should be handled by the user stream,
      // but adding here too in case of a race condition where the user stream
      // doesn't assign the currentUser in time.
      if (authUser != null) {
        currentUser = authUser;
        AppStateNotifier.instance.update(authUser);
      }
      return authUser;
    } on AuthException catch (e) {
      String errorMsg;
      if (e.message.contains('User already registered')) {
        errorMsg = 'The email is already in use by a different account.';
      } else if (e.message.contains('Invalid login credentials')) {
        errorMsg = 'Invalid email or password. Please try again.';
      } else if (e.message.contains('Email not confirmed')) {
        errorMsg = 'Please confirm your email address before signing in.';
      } else {
        errorMsg = e.message;
      }
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return null;
    }
  }
}
