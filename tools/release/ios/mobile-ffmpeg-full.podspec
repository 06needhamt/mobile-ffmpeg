Pod::Spec.new do |s|  
    s.name              = 'mobile-ffmpeg-full'
    s.version           = 'VERSION'
    s.summary           = 'Mobile FFmpeg Full Dynamic Framework'
    s.description       = 'Includes FFmpeg v4.0.1 with fontconfig v2.13.0, freetype v2.9, fribidi v1.0.4, gmp v6.1.2, gnutls v3.5.18, kvazaar v1.2.0, libiconv v1.15, lame v3.100, libaom v2018.06.27-snashot, libass v0.14.0, libilbc v2.0.2, libtheora v1.1.1, libvorbis v1.3.6, libvpx v1.7.0, libwebp v1.0.0, libxml2 v2.9.8, opencore-amr v0.1.5, opus v1.2.1, shine v3.1.1, snappy v1.1.7, soxr v0.1.3, speex v1.2.0 and wavpack v5.1.0 libraries enabled.'
    s.homepage          = 'https://github.com/tanersener/mobile-ffmpeg'

    s.author            = { 'Taner Sener' => 'tanersener@gmail.com' }
    s.license           = { :type => 'LGPL-3.0', :file => 'mobileffmpeg.framework/LICENSE' }

    s.platform          = :ios
    s.requires_arc      = true
    s.ios.deployment_target = '8.0'
    s.ios.frameworks    = 'Foundation', 'AudioToolbox', 'CoreImage'
    s.ios.library       = 'z', 'bz2'
      
    s.source            = { :http => 'https://github.com/tanersener/mobile-ffmpeg/releases/download/v1.1/mobile-ffmpeg-full-1.1-ios-framework.zip' }
    s.ios.vendored_frameworks = 'mobileffmpeg.framework', 'libavcodec.framework', 'libavdevice.framework', 'libavfilter.framework', 'libavformat.framework', 'libavutil.framework', 'libswresample.framework', 'libswscale.framework'

end  
