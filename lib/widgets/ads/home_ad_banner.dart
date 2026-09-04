import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cropdoc/core/api/api_config.dart';

/// Initializes AdMob once at app startup.
Future<void> initializeMobileAds() async {
  if (!kIsWeb) {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      // Silently fail if AdMob initialization fails
      // This prevents app crashes when AdMob is not properly configured
      if (kDebugMode) {
        debugPrint('AdMob initialization failed: $e');
      }
    }
  }
}

/// Home-screen banner ad with fallback when ads fail to load.
class HomeAdBanner extends StatefulWidget {
  const HomeAdBanner({super.key, this.onFallbackTap});

  final VoidCallback? onFallbackTap;

  @override
  State<HomeAdBanner> createState() => _HomeAdBannerState();
}

class _HomeAdBannerState extends State<HomeAdBanner> {
  BannerAd? _bannerAd;
  var _loaded = false;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _loadAd();
    } else {
      // On web, show fallback immediately
      setState(() => _failed = true);
    }
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: ApiConfig.admobBannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (_, __) => setState(() => _failed = true),
      ),
    )..load();
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _bannerAd?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // On web, always show fallback
      return _FallbackBanner(onTap: widget.onFallbackTap);
    }

    if (_loaded && _bannerAd != null) {
      return SizedBox(
        height: _bannerAd!.size.height.toDouble(),
        width: _bannerAd!.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    if (_failed) {
      return _FallbackBanner(onTap: widget.onFallbackTap);
    }

    return const SizedBox(
      height: 50,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _FallbackBanner extends StatelessWidget {
  const _FallbackBanner({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE76F51), Color(0xFFF4A261)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            children: [
              Icon(Icons.campaign_outlined, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sponsored',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Farm tools, seeds & services',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
