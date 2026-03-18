# Subscription Gating System — Implementation Overview

## What Changed

Sproutify now has a **free/paid tier system** with feature gating. After the 7-day free trial expires, users fall to a limited free tier. Write actions (adding plants, logging readings, AI chat, etc.) are locked behind subscription. Read-only browsing stays free.

### Prior State
- 7-day trial existed but had **no enforcement** — expired users kept full access forever
- Trial countdown banner had a bug (`'active'` instead of `'trial'`) so it never showed for trial users
- No subscription checks on any features

### Current State
- Trial banner bug fixed — shows countdown for trial users
- Expired trial shows a nag dialog on app launch
- 10+ write actions gated behind `checkSubscriptionAccess()` helper
- Status cached in `SharedPreferences` for offline resilience
- RevenueCat listener handles subscription lapses in real-time
- `WidgetsBindingObserver` re-checks on app resume
- Kill switch: `--dart-define=ENABLE_FEATURE_GATING=false` disables all gating

---

## Tier Breakdown

### Free (after trial expires)
- Browse plant catalog (200+ plants)
- Browse tower catalog and pest/disease guides
- View community feed (no posting or following)
- View own existing plants, towers, and harvests (created during trial)
- Add/remove favorites
- View harvest scorecard (read-only)

### Paid (active trial or subscription)
Everything above, plus:
- Add plants to towers
- Add/create new towers
- Log pH and EC readings
- Add cost entries
- Create community posts
- Follow users in community
- Mark harvests, pest issues, waste
- Sage AI chat (fully locked for free users)
- Plan with Sage

---

## Architecture

### Subscription Status Flow

```
App Launch
    |
    v
FFAppState.initializePersistedState()
    |  (loads cached subscriptionStatus from SharedPreferences)
    v
HomePage.initState()
    |
    v
check_and_update_trial_status RPC (Supabase)
    |  returns: 'trial', 'active', or 'expired'
    v
Cache in FFAppState.subscriptionStatus
    |  (RevenueCat entitlements override to 'active' if present)
    v
If 'expired' --> show ExpiredTrialNagWidget dialog
If 'trial'   --> show trial countdown banner
If 'active'  --> normal app experience
```

### Gate Check Flow (on every write action)

```
User taps gated action (e.g., "Add Plant")
    |
    v
checkSubscriptionAccess(context)
    |
    +--> Env.enableFeatureGating == false? --> return true (bypass)
    |
    +--> status == 'trial' || 'active'? --> return true (allow)
    |
    +--> else: show SubscribeBottomSheetWidget --> return false (block)
```

### Status Sync Points

| Trigger | What Happens |
|---------|-------------|
| App launch (HomePage) | Supabase RPC + RevenueCat check, cache result |
| App resume (backgrounded -> foreground) | Re-check RevenueCat entitlements |
| RevenueCat customer info update (main.dart) | Sync to 'active' or detect lapse -> 'expired' |
| Successful purchase (SubscriptionPage) | Set status to 'active' |
| Successful restore (SubscriptionPage) | Set status to 'active' |

---

## Files Modified / Created

### New Files
| File | Purpose |
|------|---------|
| `lib/components/subscribe_bottom_sheet/subscribe_bottom_sheet_widget.dart` | "Unlock Full Access" bottom sheet + `checkSubscriptionAccess()` helper |
| `lib/components/expired_trial_nag/expired_trial_nag_widget.dart` | "Your trial has ended" dialog on launch |

### Modified Files
| File | Change |
|------|--------|
| `lib/app_state.dart` | Added `subscriptionStatus` field with persistence |
| `lib/config/env.dart` | Added `enableFeatureGating` feature flag |
| `lib/main.dart` | RevenueCat listener for status sync + lapse detection |
| `lib/pages/home_page/home_page_widget.dart` | Trial banner fix (`'active'`->`'trial'`), status caching, nag screen, `WidgetsBindingObserver` for app resume |
| `lib/pages/subscription_page/subscription_page_widget.dart` | Set status to `'active'` after purchase/restore |

### Gated Entry Points
| Feature | File | What's Gated |
|---------|------|-------------|
| Add Plant | `lib/plant_detail3/plant_detail3_widget.dart` | "Add to My Plants" button |
| Add Tower | `lib/my_towers_expandable/my_towers_expandable_widget.dart` | FloatingActionButton |
| Log pH | `lib/my_towers_expandable/my_towers_expandable_widget.dart` | pH circle tap -> PhActionWidget |
| Log EC | `lib/my_towers_expandable/my_towers_expandable_widget.dart` | EC circle tap -> EcActionWidget |
| Plan with Sage | `lib/my_towers_expandable/my_towers_expandable_widget.dart` | Plan with Sage link |
| Add Cost | `lib/components/add_plant_cost/add_plant_cost_widget.dart` | Cost submit button |
| Create Post | `lib/components/create_post_widget.dart` | `_createPost()` method |
| Mark Harvest/Pest/Waste | `lib/components/bottom_plant_management/bottom_plant_management_widget.dart` | All three action buttons |
| Send Sage Message | `lib/chat_g_p_t_component/ai_chat_component/ai_chat_component_widget.dart` | Send button |
| Follow User | `lib/components/community_feed_widget.dart`, `lib/components/post_card_widget.dart` | `_toggleFollow()` methods |

### NOT Gated (Free)
- Favorites: `lib/plant_catalog/plant_catalog_widget.dart` (heart toggle)
- All catalog browsing, pest guides, community feed viewing

---

## Feature Flag

```bash
# Normal build (gating ON)
flutter run

# Disable all feature gating (for testing or emergency rollback)
flutter run --dart-define=ENABLE_FEATURE_GATING=false
```

The flag is in `lib/config/env.dart` as `Env.enableFeatureGating`. When `false`, `checkSubscriptionAccess()` always returns `true`.

---

## Testing Locally

### Web (Chrome)
```bash
flutter run -d chrome
```
RevenueCat and in-app purchases don't work on web. To simulate subscription states, temporarily set `_subscriptionStatus` in `app_state.dart`'s `initializePersistedState()`:
- `'trial'` — trial user (all features unlocked, banner shows)
- `'expired'` — expired user (nag dialog on launch, write actions gated)
- `'active'` — paid subscriber (all features unlocked)
- `''` — unknown/new user (treated as expired by gates)

### iOS Simulator / Android Emulator
Full testing including RevenueCat sandbox purchases.

---

## What's Still Needed

1. **MailerLite drip campaign** — Trial emails (days 1-6 tips + day 7 expiry nudge) are promised in the TrialTimelinePage UI but the email automation lives in MailerLite, not in-app code. Confirm the sequences are active.

2. **Push notifications** — No Firebase Cloud Messaging (FCM) is set up. If you want trial reminder push notifications, that's a separate implementation.

3. **Expired trial UX polish** — The nag dialog and bottom sheet are functional but may need design review. Consider adding illustrations or adjusting copy after user testing.

4. **Analytics/tracking** — No analytics events fire when users hit gates, dismiss the nag, or convert. Consider adding events for: `gate_shown`, `gate_subscribe_tapped`, `nag_dismissed`, `nag_subscribe_tapped`.

5. **Edge case: offline new user** — If the Supabase RPC fails on first launch, `subscriptionStatus` stays empty (`''`), which the gate treats as expired. Consider defaulting to `'trial'` on RPC failure for new users so they aren't blocked.
