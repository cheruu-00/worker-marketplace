# Worker Marketplace – Flutter screens

Six screens matching the Figma file (FRkZfgqd2kqcl31HmKLsVu):

1. Customer home
2. Post a job
3. Worker job feed
4. Worker profile
5. Escrow payment (M-Pesa)
6. Chat

## Run it

This folder holds only `lib/` and `pubspec.yaml`. Create the platform folders first:

```
flutter create worker_marketplace --org com.example
```

Then copy this folder's `lib/` and `pubspec.yaml` over the new project, and run:

```
flutter pub get
flutter run
```

The app opens on a gallery list so you can jump to any screen.

## Notes

- Font is Inter via `google_fonts`, which downloads the font at runtime. Release builds on Android need
  `<uses-permission android:name="android.permission.INTERNET"/>` in `android/app/src/main/AndroidManifest.xml`.
  To avoid the download, bundle the Inter files under `assets/fonts/` and declare them in `pubspec.yaml`.
- Icons are Material icons, which are close to but not identical to the Lucide icons in the Figma file.
  For an exact match, use the `lucide_icons` package.
- The Figma status bar is not drawn. Flutter shows the real device status bar.
