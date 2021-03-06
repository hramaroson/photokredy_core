package com.hramaroson.photokredy.core;

import io.flutter.plugin.common.PluginRegistry;

/** PhotokredyCorePlugin */
public class PhotokredyCorePlugin  {
  /** Plugin registration. */
  public static void registerWith(PluginRegistry.Registrar registrar) {
    registrar.platformViewRegistry()
             .registerViewFactory(
                  "plugins.hramaroson.github.io/photokredy_core/cameraview",
                     new CameraViewFactory(registrar.messenger()));
  }
}
