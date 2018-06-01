# MobileFFmpeg
Source code and scripts to build FFmpeg for Android and IOS platform

### 1. Features
- Builds both Android and IOS
- Supports 18 external libraries and 10 architectures in total
- Exposes FFmpeg capabilities both directly from FFmpeg libraries and through MobileFFmpeg wrapper library
- Creates shared libraries (.so for Android, .dylib for IOS)
- Licensed under LGPL 3.0
#### 1.1 Android
- Creates Android archive with .aar extension
#### 1.2 IOS
- Creates IOS dynamic universal (fat) library
- Creates IOS dynamic framework for IOS 8 or later
### 2. Architectures
#### 2.1 Android
- arm-v7a
- arm-v7a-neon
- arm64-v8a
- x86
- x86_64
#### 2.2 IOS
- armv7
- armv7s
- arm64
- i386
- x86_64
### 3. Support
#### 3.1 FFmpeg
This repository branch contains FFmpeg version 3.4.2 with support for the following external libraries.
- fontconfig
- freetype
- fribidi
- gmp
- gnutls
- kvazaar
- libiconv
- lame
- libass
- libtheora
- libvorbis
- libvpx
- libwebp
- libxml2
- opencore-amr
- shine
- speex
- wavpack

External libraries and their dependencies are explained in the [External Libraries](https://github.com/tanersener/mobile-ffmpeg/wiki/External-Libraries) page.
#### 3.2 Android
- Android SDK 5.0 Lollipop (API Level 21) or later
- Android NDK r16b or later
#### 3.3 IOS
- IOS SDK 7.0 or later
### 4. Using
\* TODO

### 5. Building
#### 5.1 Prerequisites
1. Use your package manager (apt, yum, dnf, brew, etc.) to install the following packages.
Some of them are not mandatory for the default settings.
Please refer to [Android Requirements](https://github.com/tanersener/mobile-ffmpeg/wiki/Android-Requirements) or
[IOS Requirements](https://github.com/tanersener/mobile-ffmpeg/wiki/IOS-Requirements) for the details.

>autoconf automake libtool pkg-config gcc cmake gperf yasm texinfo

2. Android builds require these additional packages.
- **Android SDK 5.0 Lollipop (API Level 21)** or later
- **Android NDK r16b** or later with LLDB and CMake
- **gradle 4.4** or later

3. IOS builds need these extra packages and tools.
- **IOS SDK 7.0.x** or later
- **Xcode 8.x** or later
- **Command Line Tools**
- **curl** and **lipo** utilities

#### 5.2 Build Scripts
Use `android.sh` and `ios.sh` to build MobileFFmpeg for each platform.
After a successful build, compiled FFmpeg and MobileFFmpeg libraries can be found under `prebuilt` directory.

Both `android.sh` and `ios.sh` can be customized to override default settings. Wiki pages for
[android.sh](https://github.com/tanersener/mobile-ffmpeg/wiki/android.sh) and
[ios.sh](https://github.com/tanersener/mobile-ffmpeg/wiki/ios.sh) include all available build options.

##### 5.2.1 Android
>export ANDROID_NDK_ROOT=\<Android NDK Path\><br>
>./android.sh

##### 5.2.2 IOS
>./ios.sh

### 6. API

\* TODO

### 7. License

This project is licensed under the LGPL v3.0.

Source code of FFmpeg and external libraries is included in compliance with their individual licenses.

Digital assets used in test applications are published in the public domain.

Please visit [License](https://github.com/tanersener/mobile-ffmpeg/wiki/License) page for the details.

### 8. Contributing

This project is stable but far from complete. If you have any recommendations or ideas to improve it, please feel free to submit issues or pull requests. Any help is appreciated.

### 9 See Also

- [FFmpeg License and Legal Considerations](https://ffmpeg.org/legal.html)
