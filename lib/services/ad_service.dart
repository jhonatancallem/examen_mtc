import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class AdService {
  InterstitialAd? _preExamInterstitialAd;
  InterstitialAd? _postExamInterstitialAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  // --- IDs de tus Unidades de Anuncios Reales ---

  static String get preExamInterstitialId { // Para ANTES del examen
    if (Platform.isAndroid) {
      return "ca-app-pub-9420207174144074/9334958138";
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get postExamInterstitialId { // Para DESPUÉS del examen
    if (Platform.isAndroid) {
      return "ca-app-pub-9420207174144074/8798103218";
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get rewardedInterstitialAdUnitId { // Para la RECOMPENSA
    if (Platform.isAndroid) {
      return "ca-app-pub-9420207174144074/6291391197";
    }
    throw UnsupportedError("Unsupported platform");
  }

  // --- Lógica para el anuncio ANTES del examen ---

  void loadPreExamInterstitialAd() {
    InterstitialAd.load(
      adUnitId: preExamInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _preExamInterstitialAd = ad,
        onAdFailedToLoad: (error) => print('PreExam Ad failed to load: $error'),
      ),
    );
  }

  void showPreExamInterstitialAd({required Function onAdDismissed}) {
    if (_preExamInterstitialAd == null) {
      onAdDismissed();
      return;
    }
    _preExamInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _preExamInterstitialAd = null;
        onAdDismissed();
        loadPreExamInterstitialAd(); // Precarga el siguiente
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _preExamInterstitialAd = null;
        onAdDismissed();
        loadPreExamInterstitialAd();
      },
    );
    _preExamInterstitialAd!.show();
  }

  // --- Lógica para el anuncio DESPUÉS del examen ---

  void loadPostExamInterstitialAd() {
    InterstitialAd.load(
      adUnitId: postExamInterstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _postExamInterstitialAd = ad,
        onAdFailedToLoad: (error) => print('PostExam Ad failed to load: $error'),
      ),
    );
  }

  void showPostExamInterstitialAd({required Function onAdDismissed}) {
    if (_postExamInterstitialAd == null) {
      onAdDismissed();
      return;
    }
    _postExamInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _postExamInterstitialAd = null;
        onAdDismissed();
        loadPostExamInterstitialAd(); // Precarga el siguiente
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _postExamInterstitialAd = null;
        onAdDismissed();
        loadPostExamInterstitialAd();
      },
    );
    _postExamInterstitialAd!.show();
  }

  // --- Lógica para el anuncio RECOMPENSADO ---

  void loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: rewardedInterstitialAdUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) => _rewardedInterstitialAd = ad,
          onAdFailedToLoad: (error) => print('Rewarded Ad failed to load: $error'),
        ));
  }

  void showRewardedInterstitialAd({required Function onAdDismissed, required Function onUserEarnedReward}) {
    if (_rewardedInterstitialAd == null) {
      onAdDismissed();
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        onAdDismissed();
        loadRewardedInterstitialAd(); // Precarga el siguiente
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        onAdDismissed();
        loadRewardedInterstitialAd();
      },
    );
    _rewardedInterstitialAd!.show(onUserEarnedReward: (ad, reward) {
      onUserEarnedReward();
    });
  }
}
