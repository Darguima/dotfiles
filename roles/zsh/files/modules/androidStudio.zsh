# Android Studio Configurations

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk/
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH=$PATH:~/Android/android-studio/bin

alias tele="emulator -avd tele"
alias tablet="emulator -avd tablet"