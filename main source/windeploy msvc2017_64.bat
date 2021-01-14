echo off
cd "build-subtitleFixer-Desktop_Qt_5_14_2_MSVC2017_64bit-Release/release"
C:/Qt/5.14.2/msvc2017_64/bin/windeployqt.exe  --release --qmldir  C:/Qt/5.14.2/msvc2017_64/qml subtitleFixer.exe
pause