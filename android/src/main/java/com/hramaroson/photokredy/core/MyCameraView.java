package com.hramaroson.photokredy.core;

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
import io.fotoapparat.exception.camera.CameraException;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import android.graphics.Color;

import io.flutter.plugin.platform.PlatformView;

public class MyCameraView implements PlatformView, MethodCallHandler {
    private final Fotoapparat mFotoapparat;
    private final CameraView mCameraView;
    private final MethodChannel mMethodChanel;
    private final Context mContext;

    MyCameraView(Context context, BinaryMessenger messenger, int id) {
        mContext = context;
        mCameraView = new CameraView(context);
        mCameraView.setBackgroundColor(Color.BLACK);
        mMethodChanel = new MethodChannel(messenger, 
            "plugins.hramaroson.github.io/photokredy_core/cameraview_" + id);
        mMethodChanel.setMethodCallHandler(this);

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
        mFotoapparat.stop();
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "open":
                open(result);
                break;
            case "setFlash":
                setFlash(methodCall, result);
                break;
            case "getFlash":
                getFlash(methodCall, result);
                break;
        }
    }

    private void open(MethodChannel.Result result){
        try{
            mFotoapparat.start();
            result.success(true);
            mMethodChanel.invokeMethod("opened", null);
        } catch (CameraException e){
            result.success(false); 
        }
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