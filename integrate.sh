#!/bin/bash
# 注入 BypassFace.dylib 到 IPA
# 用法: ./integrate.sh 你的应用.ipa

IPA="$1"
if [ -z "$IPA" ]; then
  echo "用法: ./integrate.sh 你的应用.ipa"
  exit 1
fi

# 解压
unzip "$IPA" -d ipa_work

# 找到 dylib
DYLIB="BypassFace.dylib"
if [ ! -f "$DYLIB" ]; then
  DYLIB=".theos/obj/debug/BypassFace.dylib"
fi
if [ ! -f "$DYLIB" ]; then
  echo "找不到 BypassFace.dylib"
  exit 1
fi

APP_DIR=$(ls -d ipa_work/Payload/*.app 2>/dev/null | head -1)
if [ -z "$APP_DIR" ]; then
  echo "找不到 .app 目录"
  exit 1
fi

# 复制 dylib
cp "$DYLIB" "$APP_DIR/"

# 注入
insert_dylib --inplace "@executable_path/BypassFace.dylib" \
  "$APP_DIR/$(basename $APP_DIR | sed 's/\.app$//')"

# 重打包
cd ipa_work
zip -qr "../patched_$(basename $IPA)" Payload/
cd ..

echo "完成: patched_$(basename $IPA)"