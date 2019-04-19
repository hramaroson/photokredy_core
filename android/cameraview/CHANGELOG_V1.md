For v2 changelogs, please take a look at the [website](https://natario1.github.io/CameraView/about/changelog.html).

## v1.6.1

This is the last release before v2.

- Fixed: crash when using TextureView in API 28, thanks to [@Keyrillanskiy][Keyrillanskiy] ([#297][297])
- Fixed: restore Frame Processor callbacks after taking videos, thanks to [@stefanJi][stefanJi] ([#344][344])
- Enhancement: when horizontal, camera now uses the last available orientation, thanks to [@aartikov][aartikov] ([#290][290])
- Changed: we now swallow exceptions during autoFocus that were happening unpredictably on some devices, thanks to [@mahdi-ninja][mahdi-ninja] ([#332][332])
https://github.com/natario1/CameraView/compare/v1.6.0...v1.6.1

## v1.6.0

- Lifecycle support. Use `setLifecycleOwner` instead of calling start, stop and destroy ([#265][265])
- Enhancement: provide synchronous version of CameraUtils.decodeBitmap thanks to [@athornz][athornz] ([#224][224])
- Enhancement: prevent possible context leak thanks to [@MatFl][MatFl] ([#245][245])
- Bug: fix crash when using default VideoCodec thanks to [@Namazed][Namazed] ([#264][264])
- Enhancement: CameraException.getReason() gives some insight about the error ([#265][265])
- Enhancement: Common crashes are now being posted to the error callback instead of crashing the app ([#265][265])

https://github.com/natario1/CameraView/compare/v1.5.1...v1.6.0

### v1.5.1

- Bug: byte array length for Frames was incorrect thanks to [@ssakhavi][ssakhavi] ([#205][205])
- Bug: gestures were crashing in some conditions ([#222][222])
- Bug: import correctly the ExifInterface library ([#222][222])
- Updated dependencies thanks to [@caleb-allen][caleb-allen] ([#190][190])

https://github.com/natario1/CameraView/compare/v1.5.0...v1.5.1

## v1.5.0

- New: set encoder for video recordings with `cameraVideoCodec` ([#174][174])
- New: set max duration for videos with `cameraVideoMaxDuration` ([#172][172])
- Enhancement: reduced lag with continuous gestures (ev, zoom) ([#170][170])
- Bug: tap to focus was crashing on some devices ([#167][167])
- Bug: capturePicture was breaking if followed by another event soon after ([#173][173])

https://github.com/natario1/CameraView/compare/v1.4.2...v1.5.0

### v1.4.2

- Add prefix to XML resources so they don't collide, thanks to [@RocketRider][RocketRider] ([#162][162])
- Add `videoMaxSize` API and XML attribute, to set max size video in bytes, thanks to [@chaitanyaraghav][chaitanyaraghav] ([#104][104])
- Improved the preview size selection, thanks to [@YeungKC][YeungKC] ([#133][133])
- Improved the playSounds attribute, was playing incorrectly, thanks to [@xp-vit][xp-vit] ([#143][143])

https://github.com/natario1/CameraView/compare/v1.4.1...v1.4.2

### v1.4.1

- Fixed a bug that would flip the front camera preview on some devices ([#112][112])
- Two new `CameraOptions` APIs: `o.getSupportedPictureSizes()` and `o.getSupportedPictureAspectRatios()` ([#101][101])
- Most controls (video quality, hdr, grid, session type, audio, white balance, flash, facing) now inherit
  from a base `Control` class ([#105][105]). This let us add new APIs:

  - `CameraView.set(Control)`: sets the control to the given value, e.g. `set(Flash.AUTO)`
  - `CameraOptions.supports(Control)`: returns true if the control is supported
  - `CameraOptions.getSupportedControls(Class<? extends Control>)`: returns list of supported controls of a given kind

https://github.com/natario1/CameraView/compare/v1.4.0...v1.4.1

## v1.4.0

- CameraView is now completely thread-safe. All actions are asynchronous. ([#97][97])
  This has some breaking drawbacks. Specifically, the `get` methods (e.g., `getWhiteBalance`) might
  not return the correct value while it is being changed. So don't trust them right after you have changed the value.
  Instead, always check the `CameraOptions` to see if the value you want is supported.
- Added error handling ([#97][97]) in `CameraListener.onCameraError(CameraException)`.
  At the moment, all exceptions there are unrecoverable. When the method is called, the camera is showing
  a black preview. This is a good moment to show an error dialog to the user.
  You can also try to `start()` again but that is not guaranteed to work.
- Long requested ability to set the picture output size ([#99][99]). Can be done through
  `CameraView.setPictureSize()` or through new XML attributes starting with `cameraPictureSize`.
  Please refer to docs about it.
- Deprecated `toggleFacing`. It was unreliable and will be removed.
- Deprecated `getCaptureSize`. Use `getPictureSize` instead.
- Fixed bugs.

https://github.com/natario1/CameraView/compare/v1.3.2...v1.4.0

### v1.3.2

- Fixed a memory leak thanks to [@andrewmunn][andrewmunn] ([#92][92])
- Reduced memory usage when using cropOutput thanks to [@RobertoMorelos][RobertoMorelos] ([#93][93])
- Improved efficiency for Frame processors, recycle buffers and Frames ([#94][94])

https://github.com/natario1/CameraView/compare/v1.3.1...v1.3.2

### v1.3.1

- Fixed a bug that would make setFacing and other APIs freeze the camera ([#86][86])
- Fixed ConcurrentModificationExceptions during CameraListener callbacks ([#88][88])

https://github.com/natario1/CameraView/compare/v1.3.0...v1.3.1

## v1.3.0

- Ability to inject frame processors to do your own visual tasks (barcodes, facial recognition etc.) ([#82][82])
- Ability to inject external loggers (e.g. Crashlytics) to listen for internal logging events ([#80][80])
- Improved CameraUtils.decodeBitmap, you can now pass maxWidth and maxHeight to avoid OOM ([#83][83])
- Updated dependencies thanks to [@v-gar][v-gar] ([#73][73])

https://github.com/natario1/CameraView/compare/v1.2.3...v1.3.0

[aartikov]: https://github.com/aartikov
[athornz]: https://github.com/athornz
[v-gar]: https://github.com/v-gar
[andrewmunn]: https://github.com/andrewmunn
[chaitanyaraghav]: https://github.com/chaitanyaraghav
[YeungKC]: https://github.com/YeungKC
[RobertoMorelos]: https://github.com/RobertoMorelos
[RocketRider]: https://github.com/RocketRider
[xp-vit]: https://github.com/xp-vit
[caleb-allen]: https://github.com/caleb-allen
[ssakhavi]: https://github.com/ssakhavi
[MatFl]: https://github.com/MatFl
[Namazed]: https://github.com/Namazed
[Keyrillanskiy]: https://github.com/Keyrillanskiy
[mahdi-ninja]: https://github.com/mahdi-ninja
[stefanJi]: https://github.com/stefanJi

[73]: https://github.com/natario1/CameraView/pull/73
[80]: https://github.com/natario1/CameraView/pull/80
[82]: https://github.com/natario1/CameraView/pull/82
[83]: https://github.com/natario1/CameraView/pull/83
[86]: https://github.com/natario1/CameraView/pull/86
[88]: https://github.com/natario1/CameraView/pull/88
[92]: https://github.com/natario1/CameraView/pull/92
[93]: https://github.com/natario1/CameraView/pull/93
[94]: https://github.com/natario1/CameraView/pull/94
[97]: https://github.com/natario1/CameraView/pull/97
[99]: https://github.com/natario1/CameraView/pull/99
[101]: https://github.com/natario1/CameraView/pull/101
[104]: https://github.com/natario1/CameraView/pull/104
[105]: https://github.com/natario1/CameraView/pull/105
[112]: https://github.com/natario1/CameraView/pull/112
[133]: https://github.com/natario1/CameraView/pull/133
[143]: https://github.com/natario1/CameraView/pull/143
[162]: https://github.com/natario1/CameraView/pull/162
[167]: https://github.com/natario1/CameraView/pull/167
[170]: https://github.com/natario1/CameraView/pull/170
[172]: https://github.com/natario1/CameraView/pull/172
[173]: https://github.com/natario1/CameraView/pull/173
[174]: https://github.com/natario1/CameraView/pull/174
[190]: https://github.com/natario1/CameraView/pull/190
[205]: https://github.com/natario1/CameraView/pull/205
[222]: https://github.com/natario1/CameraView/pull/222
[224]: https://github.com/natario1/CameraView/pull/224
[245]: https://github.com/natario1/CameraView/pull/245
[264]: https://github.com/natario1/CameraView/pull/264
[265]: https://github.com/natario1/CameraView/pull/265
[290]: https://github.com/natario1/CameraView/pull/290
[297]: https://github.com/natario1/CameraView/pull/297
[332]: https://github.com/natario1/CameraView/pull/332
[334]: https://github.com/natario1/CameraView/pull/334
