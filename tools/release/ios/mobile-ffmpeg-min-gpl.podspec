Pod::Spec.new do |s|  
    s.name              = 'mobile-ffmpeg-min-gpl'
    s.version           = 'VERSION'
    s.summary           = 'Mobile FFmpeg Min GPL Dynamic Framework'
    s.description       = 'Includes FFmpeg v4.0.2 with libvid.stab v1.1.0, x264 20180829-2245-stable, x265 v2.9 and xvidcore v1.3.5 libraries enabled.'
    s.homepage          = 'https://github.com/tanersener/mobile-ffmpeg'

    s.author            = { 'Taner Sener' => 'tanersener@gmail.com' }
    s.license           = { :type => 'GPL-3.0', :file => 'mobileffmpeg.framework/LICENSE' }

    s.platform          = :ios
    s.requires_arc      = true
    s.ios.deployment_target = '8.0'
    s.ios.frameworks    = 'Foundation'
      
    s.source            = { :http => 'https://github.com/tanersener/mobile-ffmpeg/releases/download/v2.1.1/mobile-ffmpeg-min-gpl-2.1.1-ios-framework.zip' }
    s.ios.vendored_frameworks = 'mobileffmpeg.framework', 'libavcodec.framework', 'libavdevice.framework', 'libavfilter.framework', 'libavformat.framework', 'libavutil.framework', 'libswresample.framework', 'libswscale.framework'

end  
