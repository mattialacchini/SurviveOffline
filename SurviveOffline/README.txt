# SurviveOffline — progetto mobile (Android+iOS)

Questo pacchetto contiene il codice Flutter per l'app **SurviveOffline**.
Funziona *offline* e mostra banner pubblicitari **non invasivi** (AdMob test).

## Come costruire l'APK (Android)

1) Installa **Flutter** (https://docs.flutter.dev/get-started/install) e Android Studio (SDK + emulator/USB driver).
2) Apri un terminale dentro la cartella del progetto e lancia:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   flutter run -d android      # per provare su telefono/emulatore
   flutter build apk           # genera l'APK di rilascio in build/app/outputs/apk/release/app-release.apk
   ```

> L'icona dell'app viene generata con `flutter_launcher_icons` usando `assets/srv.off.png`.

## Annunci (AdMob)
Nel codice sono inseriti **Ad Unit ID di test**. Quando avrai un account AdMob, sostituiscili in `lib/ads.dart` con i tuoi ID reali.

## iOS (opzionale)
Richiede un Mac con Xcode e un account Apple Developer. Dopo `flutter pub get` apri `ios/` con Xcode per impostare il Bundle ID.
