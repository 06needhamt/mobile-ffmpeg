/*
 * Simple DirectMedia Layer
 * Copyright (C) 1997-2018 Sam Lantinga <slouken@libsdl.org>
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

package com.arthenica.mobileffmpeg.player.sdl;

import android.view.InputDevice;
import android.view.MotionEvent;

import com.arthenica.mobileffmpeg.player.ControllerManager;

public class SDLControllerManager implements ControllerManager {

    protected static SDLJoystickHandler mJoystickHandler;
    protected static SDLHapticHandler mHapticHandler;

    public static void initialize() {
        mJoystickHandler = null;
        mHapticHandler = null;

        SDLControllerManager.setup();
    }

    public static void setup() {
        mJoystickHandler = new SDLJoystickHandler();
        mHapticHandler = new SDLHapticHandler();
    }

    /**
     * Joystick glue code, just a series of stubs that redirect to the SDLJoystickHandler instance.
     */
    public static boolean handleJoystickMotionEvent(final MotionEvent event) {
        return mJoystickHandler.handleMotionEvent(event);
    }

    public void pollInputDevices() {
        mJoystickHandler.pollInputDevices();
    }

    public void pollHapticDevices() {
        mHapticHandler.pollHapticDevices();
    }

    public void hapticRun(final int deviceId, final int length) {
        mHapticHandler.run(deviceId, length);
    }

    /**
     * Check if a given device is considered a possible SDL joystick.
     *
     * @param deviceId device identifier
     * @return true if device is a joystick, false otherwise
     */
    public static boolean isDeviceSDLJoystick(final int deviceId) {
        InputDevice device = InputDevice.getDevice(deviceId);
        // We cannot use InputDevice.isVirtual before API 16, so let's accept
        // only nonnegative device ids (VIRTUAL_KEYBOARD equals -1)
        if ((device == null) || (deviceId < 0)) {
            return false;
        }
        int sources = device.getSources();

        /* This is called for every button press, so let's not spam the logs */
        /**
         if ((sources & InputDevice.SOURCE_CLASS_JOYSTICK) == InputDevice.SOURCE_CLASS_JOYSTICK) {
         Log.v(TAG, "Input device " + device.getName() + " is a joystick.");
         }
         if ((sources & InputDevice.SOURCE_DPAD) == InputDevice.SOURCE_DPAD) {
         Log.v(TAG, "Input device " + device.getName() + " is a dpad.");
         }
         if ((sources & InputDevice.SOURCE_GAMEPAD) == InputDevice.SOURCE_GAMEPAD) {
         Log.v(TAG, "Input device " + device.getName() + " is a gamepad.");
         }
         **/

        return (((sources & InputDevice.SOURCE_CLASS_JOYSTICK) == InputDevice.SOURCE_CLASS_JOYSTICK) ||
                ((sources & InputDevice.SOURCE_DPAD) == InputDevice.SOURCE_DPAD) ||
                ((sources & InputDevice.SOURCE_GAMEPAD) == InputDevice.SOURCE_GAMEPAD)
        );
    }

}

