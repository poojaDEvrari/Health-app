Place your assets in this folder with the following exact filenames so the app and native splash can pick them up:

- splash_logo.png              -> app icon/mark for native splash (square or centered with padding)
- branding.png                 -> optional small wordmark for native splash bottom
- logo_big.png                 -> big logo used on in-app splash screen
- welcome_illustration.png     -> illustration used on login screen header

Recommended sizes:
- splash_logo.png: 1024x1024 with safe padding (transparent PNG)
- branding.png: width ~512-1024, height <= 256
- logo_big.png: ~512x512
- welcome_illustration.png: width ~800, height ~400

After placing these files, run:
  flutter pub get
  dart run flutter_native_splash:create
