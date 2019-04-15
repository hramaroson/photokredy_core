package com.hramaroson.photokredy.core;

import android.app.Activity;
import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class CameraViewFactory extends PlatformViewFactory {
    private final BinaryMessenger mMessenger;

    public CameraViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.mMessenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        return new MyCameraView(context, mMessenger, id);
    }
}