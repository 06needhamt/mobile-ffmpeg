cd ~/
sudo apt-get update -qq && sudo apt-get upgrade -y
sudo apt-get install -y wget git build-essential unzip automake openjdk-11-jre-headless texinfo autoconf libtool pkg-config curl cmake gcc gperf yasm nasm bison autogen patch python linux-headers-generic libgnutls28-dev
mkdir android-sdk
cd android-sdk/
wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip
unzip commandlinetools-linux-6609375_latest.zip
echo 'export ANDROID_HOME=~/android-sdk' >> ~/.bashrc
source ~/.bashrc
export PATH=$PATH$ANDROID_HOME/cmdline-tools/tools/bin
echo y | sudo tools/bin/sdkmanager --list all --sdk_root=.
echo y | sudo tools/bin/sdkmanager "platforms;android-30" --sdk_root=${ANDROID_HOME} 
echo y | sudo tools/bin/sdkmanager "build-tools;30.0.1" --sdk_root=${ANDROID_HOME} 
echo y | sudo tools/bin/sdkmanager "ndk;19.2.5345600" --sdk_root=${ANDROID_HOME}
echo 'export ANDROID_NDK_ROOT=${ANDROID_HOME}/ndk/19.2.5345600' >> ~/.bashrc
source ~/.bashrc 
cd ~/mobile-ffmpeg
sudo -E ./android.sh --full --enable-gpl --enable-libvidstab --enable-rubberband --enable-x264 --enable-x265 --enable-xvidcore