Pod::Spec.new do |s|  
    s.name              = 'mobile-ffmpeg-min'
    s.version           = 'VERSION'
    s.summary           = 'Mobile FFmpeg Min Static Framework'
    s.description       = 'Includes FFmpeg v4.2-dev-480 without any external libraries enabled.'
    s.homepage          = 'https://github.com/tanersener/mobile-ffmpeg'

    s.author            = { 'Taner Sener' => 'tanersener@gmail.com' }
    s.license           = { :type => 'LGPL-3.0', :file => 'mobileffmpeg.framework/LICENSE' }

    s.platform          = :ios
    s.requires_arc      = true
    s.ios.deployment_target = '9.3'
    s.ios.frameworks    = 'Foundation', 'AudioToolbox', 'CoreImage', 'CoreMotion', 'CoreVideo', 'GameController', 'VideoToolbox'
    s.libraries         = 'z', 'bz2', 'c++'
      
    s.source            = { :http => 'https://github.com/tanersener/mobile-ffmpeg/releases/download/vVERSION/mobile-ffmpeg-min-VERSION-ios-framework.zip' }
    s.ios.vendored_frameworks = 'mobileffmpeg.framework', 'libavcodec.framework', 'libavdevice.framework', 'libavfilter.framework', 'libavformat.framework', 'libavutil.framework', 'libswresample.framework', 'libswscale.framework'

end  
