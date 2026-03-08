#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=0.9.6 # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"

wget https://github.com/debba/tabularis/releases/download/v${VERSION}/tabularis_${VERSION}_amd64.deb -O /tmp/tmp.deb
ar xv /tmp/tmp.deb
tar xfv ./data.tar.gz
mv -v ./usr ./AppDir
cp -v ./AppDir/share/applications/tabularis.desktop ./AppDir
cp -v ./AppDir/share/icons/hicolor/512x512/apps/tabularis.png ./AppDir

# Deploy dependencies
quick-sharun ./AppDir/bin/*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
