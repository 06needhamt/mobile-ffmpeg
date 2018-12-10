Pod::Spec.new do |s|  
    s.name              = 'mobile-ffmpeg-video'
    s.version           = 'VERSION'
    s.summary           = 'Mobile FFmpeg Video Dynamic Framework'
    s.description       = 'Includes FFmpeg v4.1-10 with fontconfig v2.13.1, freetype v2.9.1, fribidi v1.0.5, kvazaar v1.2.0, libaom v1.0.0-1014, libass v0.14.0, libiconv v1.15, libtheora v1.1.1, libvpx v1.7.0, snappy v1.1.7 and libwebp v1.0.1 libraries enabled.'
    s.homepage          = 'https://github.com/tanersener/mobile-ffmpeg'

    s.author            = { 'Taner Sener' => 'tanersener@gmail.com' }
    s.license           = { :type => 'LGPL-3.0', :file => 'mobileffmpeg.framework/LICENSE' }

    s.platform          = :ios
    s.requires_arc      = true
    s.ios.deployment_target = '8.0'
    s.ios.frameworks    = 'Foundation', 'AudioToolbox', 'CoreImage', 'CoreMotion', 'CoreVideo', 'GameController', 'VideoToolbox'
    s.ios.library       = 'z', 'bz2', 'c++'
      
    s.source            = { :http => 'https://github.com/tanersener/mobile-ffmpeg/releases/download/v3.0/mobile-ffmpeg-video-3.0-ios-framework.zip' }
    s.ios.vendored_frameworks = 'mobileffmpeg.framework', 'libavcodec.framework', 'libavdevice.framework', 'libavfilter.framework', 'libavformat.framework', 'libavutil.framework', 'libswresample.framework', 'libswscale.framework'

end  
