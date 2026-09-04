# AdMob Setup Guide

## Test vs Production Ad Units

The app currently uses Google's test AdMob unit IDs. These must be replaced with production IDs before publishing to the Play Store.

## Current Configuration

**Location:** `lib/core/api/api_config.dart`

```dart
static const String admobBannerUnitId = String.fromEnvironment(
  'ADMOB_BANNER_ID',
  defaultValue: 'ca-app-pub-3940256099942544/6300978111', // Test ID
);
```

## How to Update to Production IDs

### Option 1: Using Build Arguments (Recommended)

```bash
flutter build apk --dart-define=ADMOB_BANNER_ID=ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX
```

### Option 2: Update Default Value

Replace the test ID in `lib/core/api/api_config.dart` with your production banner unit ID.

## Getting Production Ad Unit IDs

1. Go to [AdMob Console](https://apps.admob.com/)
2. Create an app for your package: `com.tejas.cropdoc`
3. Create ad units (Banner, Interstitial, Rewarded)
4. Copy the ad unit IDs

## Android Configuration

Update `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
</application>
```

## Test Device IDs

To test ads on your device during development, add your device ID:

```dart
// In your widget initialization
RequestConfiguration requestConfiguration = RequestConfiguration(
  testDeviceIds: ['C0B0070707DFA92EB224C35C36D1371F'], // Your device ID
);
MobileAds.instance.updateRequestConfiguration(requestConfiguration);
```

You can find your device ID in the Logcat output when running the app.

## Important Notes

- **Never use test IDs in production** - you won't earn revenue
- Test IDs return only test ads and are not monetized
- Always test with real ad units in test mode before production
- Follow AdMob policies to avoid account suspension

## Compliance

- Ensure your app follows [AdMob policies](https://support.google.com/admob/answer/9061399)
- Include proper privacy policy in your app
- Disclose ad personalization to users
