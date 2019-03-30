package com.hramaroson.photokredy.core;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.view.View;

import io.fotoapparat.Fotoapparat;
import io.fotoapparat.view.CameraView;
import io.fotoapparat.selector.SelectorsKt;
import io.fotoapparat.selector.FocusModeSelectorsKt;
import io.fotoapparat.selector.FlashSelectorsKt;
import io.fotoapparat.selector.FlashSelectorsKt;
import io.fotoapparat.parameter.ScaleType;
import io.fotoapparat.configuration.UpdateConfiguration;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import android.graphics.Color;

import io.flutter.plugin.platform.PlatformView;

public class MyCameraView implements PlatformView, MethodCallHandler,
        Application.ActivityLifecycleCallbacks {

    private final Fotoapparat mFotoapparat;
    private final CameraView mCameraView;
    private final MethodChannel mMethodChanel;
    private final Context mContext;

    MyCameraView(Context context, BinaryMessenger messenger, int id, Activity activity) {
        mContext = context;
        mCameraView = new CameraView(context);
        mCameraView.setBackgroundColor(Color.BLACK);
        mMethodChanel = new MethodChannel(messenger, "plugins.hramaroson.github.io/cameraview_" + id);
        mMethodChanel.setMethodCallHandler(this);

        activity.getApplication().registerActivityLifecycleCallbacks(this);

        mFotoapparat = Fotoapparat
            .with(context)
            .previewScaleType(ScaleType.CenterCrop)
            .into(mCameraView)
            .focusMode(SelectorsKt.firstAvailable(
                FocusModeSelectorsKt.continuousFocusPicture(),
                FocusModeSelectorsKt.autoFocus(), 
                FocusModeSelectorsKt.fixed()
            ))
            .build();

        mFotoapparat.start();
    }

    @Override
    public View getView() {
        return mCameraView;
    }

    @Override
    public void dispose(){
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "setFlash":
                setFlash(methodCall, result);
                break;
            case "getFlash":
                getFlash(methodCall, result);
                break;
        }
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {}

    @Override
    public void onActivityStarted(Activity activity) {
    }

    @Override
    public void onActivityResumed (Activity activity) {
        mFotoapparat.start();
    }

    @Override
    public void onActivityPaused(Activity activity) {
        mFotoapparat.stop();
    }

    @Override
    public void onActivityStopped(Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {}

    @Override
    public void onActivityDestroyed(Activity activity) {
    }

    private final static int FLASH_OFF = 0;
    private final static int FLASH_TORCH = 1;
    private int mflashMode = FLASH_OFF;

    private void setFlash(MethodCall methodCall, MethodChannel.Result result){
        try {
            int _flashMode = (int) methodCall.arguments;
            mFotoapparat.updateConfiguration(UpdateConfiguration.builder().flash(
                (_flashMode == FLASH_TORCH )? FlashSelectorsKt.torch() : FlashSelectorsKt.off()
            ).build());
            mflashMode = _flashMode;
            result.success(true);
        } catch (IllegalStateException e) {
            result.success(false);
        }
    }

    private void getFlash(MethodCall methodCall, MethodChannel.Result result){
        result.success(mflashMode);
    }
}