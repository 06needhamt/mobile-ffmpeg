---
layout: default
---
FFmpeg for Android and IOS

<img src="https://github.com/tanersener/mobile-ffmpeg/blob/dev-v3.x/docs/assets/mobile-ffmpeg-logo-v7.png" width="240">

### 1. Features
- Supports FFmpeg `v3.4.x`, `v4.0.x` and `v4.1-dev` (master) releases
- Use prebuilt binaries available under `Github`/`JCenter`/`CocoaPods` or build your own version with external libraries you need
- Includes 27 external libraries, 4 GPL libraries and 10 architectures in total
- Exposes both FFmpeg library and MobileFFmpeg wrapper library capabilities
- Includes cross-compile instructions for 43 open-source libraries

   `chromaprint`, `expat`, `ffmpeg`, `fontconfig`, `freetype`, `fribidi`, `giflib`, `gmp`, `gnutls`, `kvazaar`, `lame`, `leptonica`, `libaom`, `libass`, `libiconv`, `libilbc`, `libjpeg`, `libjpeg-turbo`, `libogg`, `libpng`, `libsndfile`, `libtheora`, `libuuid`, `libvorbis`, `libvpx`, `libwebp`, `libxml2`, `nettle`, `opencore-amr`, `opus`, `sdl`, `shine`, `snappy`, `soxr`, `speex`, `tesseract`, `tiff`, `twolame`, `vid.stab`, `wavpack`, `x264`, `x265`, `xvidcore`

- Builds `arm-v7a`, `arm-v7a-neon`, `arm64-v8a`, `x86` and `x86_64` Android architectures
- Supports `zlib` and `MediaCodec` Android system libraries
- Creates Android archive with .aar extension
- Builds `armv7`, `armv7s`, `arm64`, `i386` and `x86_64` IOS architectures
- Supports `bzip2`, `zlib` IOS system libraries and `AudioToolbox`, `CoreImage`, `VideoToolbox`, `AVFoundation` IOS system frameworks
- `ARC` enabled library
- Built with `-fembed-bitcode` flag
- Creates IOS dynamic universal (fat) library
- Creates IOS dynamic framework for IOS 8 or later
- Licensed under LGPL 3.0, can be customized to support GPL v3.0

### 2. Using
Binaries are available at [Github](https://github.com/tanersener/mobile-ffmpeg/releases), [JCenter](https://bintray.com/bintray/jcenter) and [CocoaPods](https://cocoapods.org).

There are eight different prebuilt packages. Below you can see which external libraries are enabled in each of them.

<table>
<thead>
<tr>
<th align="center"></th>
<th align="center">min</th>
<th align="center">min-gpl</th>
<th align="center">https</th>
<th align="center">https-gpl</th>
<th align="center">audio</th>
<th align="center">video</th>
<th align="center">full</th>
<th align="center">full-gpl</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><sup>external libraries</sup></td>
<td align="center">-</td>
<td align="center"><sup>vid.stab</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
<td align="center"><sup>gmp</sup><br><sup>gnutls</sup></td>
<td align="center"><sup>gmp</sup><br><sup>gnutls</sup><br><sup>vid.stab</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
<td align="center"><sup>chromaprint</sup><br><sup>lame</sup><br><sup>libilbc</sup><br><sup>libvorbis</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>shine</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>twolame</sup><br><sup>wavpack</sup></td>
<td align="center"><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>kvazaar</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libtheora</sup><br><sup>libvpx</sup><br><sup>snappy</sup><br><sup>libwebp</sup></td>
<td align="center"><sup>chromaprint</sup><br><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>gmp</sup><br><sup>gnutls</sup><br><sup>kvazaar</sup><br><sup>lame</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libilbc</sup><br><sup>libtheora</sup><br><sup>libvorbis</sup><br><sup>libvpx</sup><br><sup>libwebp</sup><br><sup>libxml2</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>sdl</sup><br><sup>shine</sup><br><sup>snappy</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>tesseract</sup><br><sup>twolame</sup><br><sup>wavpack</sup></td>
<td align="center"><sup>chromaprint</sup><br><sup>fontconfig</sup><br><sup>freetype</sup><br><sup>fribidi</sup><br><sup>gmp</sup><br><sup>gnutls</sup><br><sup>kvazaar</sup><br><sup>lame</sup><br><sup>libaom</sup><br><sup>libass</sup><br><sup>libiconv</sup><br><sup>libilbc</sup><br><sup>libtheora</sup><br><sup>libvorbis</sup><br><sup>libvpx</sup><br><sup>libwebp</sup><br><sup>libxml2</sup><br><sup>opencore-amr</sup><br><sup>opus</sup><br><sup>sdl</sup><br><sup>shine</sup><br><sup>snappy</sup><br><sup>soxr</sup><br><sup>speex</sup><br><sup>tesseract</sup><br><sup>twolame</sup><br><sup>vid.stab</sup><br><sup>wavpack</sup><br><sup>x264</sup><br><sup>x265</sup><br><sup>xvidcore</sup></td>
</tr>
<tr>
<td align="center"><sup>android system libraries</sup></td>
<td align="center" colspan=8><sup>zlib</sup><br><sup>MediaCodec</sup></td>
</tr>
<tr>
<td align="center"><sup>ios system libraries</sup></td>
<td align="center" colspan=8><sup>zlib</sup><br><sup>AudioToolbox</sup><br><sup>AVFoundation</sup><br><sup>CoreImage</sup><br><sup>VideoToolbox</sup><br><sup>bzip2</sup></td>
</tr>
</tbody>
</table>

 - `libilbc`, `opus`, `snappy`, `x264` and `xvidcore` are supported since `v1.1`

 - `libaom` and `soxr` are supported since `v2.0`

 - `chromaprint`, `vid.stab` and `x265` are supported since `v2.1`

 - `sdl`, `tesseract`, `twolame` external libraries; `zlib`, `MediaCodec` Android system libraries; `bzip2`, `zlib` IOS system libraries and `AudioToolbox`, `CoreImage`, `VideoToolbox`, `AVFoundation` IOS system frameworks are supported since `v3.0`

#### 2.1 Android
1. Add MobileFFmpeg dependency from `jcenter()`
    ```
    dependencies {`
        implementation 'com.arthenica:mobile-ffmpeg-full:3.0'
    }
    ```

2. Execute commands.
    ```
    import com.arthenica.mobileffmpeg.FFmpeg;

    FFmpeg.execute("-i file1.mp4 -c:v mpeg4 file2.mp4");
    ```

3. Check execution output.
    ```
    int rc = FFmpeg.getLastReturnCode();
    String output = FFmpeg.getLastCommandOutput();
 
    if (rc == RETURN_CODE_SUCCESS) {
        Log.i(Config.TAG, "Command execution completed successfully.");
    } else if (rc == RETURN_CODE_CANCEL) {
        Log.i(Config.TAG, "Command execution cancelled by user.");
    } else {
        Log.i(Config.TAG, String.format("Command execution failed with rc=%d and output=%s.", rc, output));
    }
    ```

4. Stop an ongoing operation.
    ```
    FFmpeg.cancel();
    ```

5. Get media information for a file.
    ```
    MediaInformation info = FFmpeg.getMediaInformation('<file path or uri>');
    ```

6. List enabled external libraries.
    ```
    List<String> externalLibraries = Config.getExternalLibraries();
    ```

7. Enable log callback.
    ```
    Config.enableLogCallback(new LogCallback() {
        public void apply(LogMessage message) {
            Log.d(Config.TAG, message.getText());
        }
    });
    ```

8. Enable statistics callback.
    ```
    Config.enableStatisticsCallback(new StatisticsCallback() {
        public void apply(Statistics newStatistics) {
            Log.d(Config.TAG, String.format("frame: %d, time: %d", newStatistics.getVideoFrameNumber(), newStatistics.getTime()));
        }
    });
    ```

9. Set log level.
    ```
    Config.setLogLevel(Level.AV_LOG_FATAL);
    ```

10. Register custom fonts directory.
    ```
    Config.setFontDirectory(this, "<folder with fonts>", Collections.EMPTY_MAP);
    ```

#### 2.2 IOS
1. Add MobileFFmpeg pod to your `Podfile`
    ```
    pod 'mobile-ffmpeg-full', '~> 3.0'
    ```

2. Execute commands.
    ```
    #import <mobileffmpeg/MobileFFmpeg.h>

    [MobileFFmpeg execute: @"-i file1.mp4 -c:v mpeg4 file2.mp4"];
    ```
    
3. Check execution output.
    ```
    int rc = [MobileFFmpeg getLastReturnCode];
    NSString *output = [MobileFFmpeg getLastCommandOutput];

    if (rc == RETURN_CODE_SUCCESS) {
        NSLog(@"Command execution completed successfully.\n");
    } else if (rc == RETURN_CODE_CANCEL) {
        NSLog(@"Command execution cancelled by user.\n");
    } else {
        NSLog(@"Command execution failed with rc=%d and output=%@.\n", rc, output);
    }
    ```

4. Stop an ongoing operation.
    ```
    [MobileFFmpeg cancel];
    ```

5. Get media information for a file.
    ```
    MediaInformation *mediaInformation = [MobileFFmpeg getMediaInformation:@"<file path or uri>"];
    ```

6. List enabled external libraries.
    ```
    NASArray *externalLibraries = [MobileFFmpegConfig getExternalLibraries];
    ```

7. Enable log callback.
    ```
    - (void)logCallback: (int)level :(NSString*)message {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", message);
        });
    }
    ...
    [MobileFFmpegConfig setLogDelegate:self];
    ```

8. Enable statistics callback.
    ```
    - (void)statisticsCallback:(Statistics *)newStatistics {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"frame: %d, time: %d\n", newStatistics.getVideoFrameNumber, newStatistics.getTime);
        });
    }
    ...
    [MobileFFmpegConfig setStatisticsDelegate:self];
    ```

9. Set log level.
    ```
    [MobileFFmpegConfig setLogLevel:AV_LOG_FATAL];
    ```

10. Register custom fonts directory.
    ```
    [MobileFFmpegConfig setFontDirectory:@"<folder with fonts>" with:nil];
    ```

### 3. Versions

- `MobileFFmpeg v1.x` is the previous stable, includes `FFmpeg v3.4.4`

- `MobileFFmpeg v2.x` is the current stable, includes `FFmpeg v4.0.2`

- `MobileFFmpeg v3.x` is the next stable, includes `FFmpeg v4.1-dev-1517`
    
### 4. Building
#### 4.1 Prerequisites
1. Use your package manager (apt, yum, dnf, brew, etc.) to install the following packages.

    ```
    autoconf automake libtool pkg-config curl cmake gcc gperf texinfo yasm nasm bison
    ```
2. Android builds require these additional packages.
    - **Android SDK 5.0 Lollipop (API Level 21)** or later
    - **Android NDK r17c** or later with LLDB and CMake
    - **gradle 4.4** or later

3. IOS builds need these extra packages and tools.
    - **IOS SDK 8.0.x** or later
    - **Xcode 7.3.1** or later
    - **Command Line Tools**

#### 4.2 Build Scripts
Use `android.sh` and `ios.sh` to build MobileFFmpeg for each platform.
After a successful build, compiled FFmpeg and MobileFFmpeg libraries can be found under `prebuilt` directory.

##### 4.2.1 Android
```
export ANDROID_NDK_ROOT=<Android NDK Path>
./android.sh
```

<img src="https://github.com/tanersener/mobile-ffmpeg/raw/master/docs/assets/android_custom.gif" width="600">

##### 4.2.2 IOS
```
./ios.sh
```

<img src="https://github.com/tanersener/mobile-ffmpeg/raw/master/docs/assets/ios_custom.gif" width="600">

#### 4.3 GPL Support
It is possible to enable GPL licensed libraries `x264`, `xvidcore` since `v1.1` and `vid.stab`, `x265` since `v2.1` 
from the top level build scripts.
Their source code is not included in the repository and downloaded when enabled.

#### 4.4 External Libraries
`build` directory includes build scripts for external libraries. There are two scripts for each library, one for Android
and one for IOS. They include all options/flags used to cross-compile the libraries.

### 5. Documentation

A more detailed documentation is available at [Wiki](https://github.com/tanersener/mobile-ffmpeg/wiki).

### 6. License

This project is licensed under the LGPL v3.0. However, if source code is built using optional `--enable-gpl` flag or 
prebuilt binaries with `-gpl` postfix are used then MobileFFmpeg is subject to the GPL v3.0 license.

Source code of FFmpeg and external libraries is included in compliance with their individual licenses.

`strip-frameworks.sh` script included and distributed is published under the [Apache License version 2.0](https://www.apache.org/licenses/LICENSE-2.0).

In test applications, fonts embedded are licensed under the [SIL Open Font License](https://opensource.org/licenses/OFL-1.1); other digital assets are published in the public domain.

Please visit [License](https://github.com/tanersener/mobile-ffmpeg/wiki/License) page for the details.

### 7. See Also

- [libav gas-preprocessor](https://github.com/libav/gas-preprocessor/raw/master/gas-preprocessor.pl)
- [FFmpeg API Documentation](https://ffmpeg.org/doxygen/4.0/index.html)
- [FFmpeg Wiki](https://trac.ffmpeg.org/wiki/WikiStart)
- [FFmpeg License and Legal Considerations](https://ffmpeg.org/legal.html)
- [FFmpeg External Library Licenses](https://www.ffmpeg.org/doxygen/4.0/md_LICENSE.html)