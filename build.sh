#!/bin/bash
# Cloudflare Pages 빌드 스크립트

# Flutter 설치
git clone https://github.com/flutter/flutter.git --depth 1 --branch stable
export PATH="$PATH:$PWD/flutter/bin"

# Flutter 설정
flutter config --enable-web
flutter pub get

# 웹 빌드
flutter build web --release --web-renderer canvaskit

echo "Build complete!"
