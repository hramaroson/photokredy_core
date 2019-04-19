package com.hramaroson.photokredy.core;

import android.content.Context;
import android.os.Bundle;
import android.view.View;

import com.otaliastudios.cameraview.CameraView;
import com.otaliastudios.cameraview.CameraListener;
import com.otaliastudios.cameraview.CameraOptions;
import com.otaliastudios.cameraview.Audio;
import com.otaliastudios.cameraview.Mode;
import com.otaliastudios.cameraview.Flash;
import com.otaliastudios.cameraview.Flash;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import android.graphics.Color;

import io.flutter.plugin.platform.PlatformView;

public class MyCameraView implements PlatformView, MethodCallHandler {
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
        
        mCameraView.setAudio(Audio.OFF);
        mCameraView.setMode(Mode.PICTURE);

        mCameraView.addCameraListener(new CameraListener() {
            @Override
            public void onCameraOpened(CameraOptions options) {
                mMethodChanel.invokeMethod("opened", null);
            }
            
            @Override
            public void onCameraClosed() {
                mMethodChanel.invokeMethod("closed", null);
            }
        });
        mCameraView.open();
    }

    @Override
    public View getView() {
        return mCameraView;
    }

    @Override
    public void dispose(){
        mCameraView.destroy();
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "open":
                open(result);
                break;
            case "close":
                close(result);
                break;
            case "setFlash":
                setFlash(methodCall, result);
                break;
            case "getFlash":
                getFlash(methodCall, result);
                break;
        }
    }

    private void open(MethodChannel. Result result){
        mCameraView.open();
    }

    private void close(MethodChannel. Result result){
        mCameraView.close();
    }

    private final static int FLASH_OFF = 0;
    private final static int FLASH_TORCH = 1;

    private void setFlash(MethodCall methodCall, MethodChannel.Result result){
        mCameraView.setFlash(((int) methodCall.arguments == FLASH_OFF)? Flash.OFF : Flash.TORCH );
    }

    private void getFlash(MethodCall methodCall, MethodChannel.Result result){
        result.success((mCameraView.getFlash() == Flash.OFF)? FLASH_OFF : FLASH_TORCH);
    }
}