# 免刷脸登录 - 好的出租联盟 iOS Tweak

绕过 "至尊好的出租联盟" 的所有面部识别验证（白马、旷视、腾讯、阿里）

## 编译方法（无需 Mac）

### 方式一：GitHub Actions（推荐）

1. 把这个文件夹推送到你的 GitHub 仓库
2. 去 GitHub → Actions → Build iOS Dylib → Run workflow
3. 等几分钟，下载 `BypassFace.dylib` 成品

### 方式二：Mac + Theos

```bash
export THEOS=/opt/theos
make clean
make package
```

## 注入 IPA

```bash
# 解压 IPA
unzip 至尊好的出租联盟.ipa -d ipa_work

# 复制 dylib
cp BypassFace.dylib ipa_work/Payload/*.app/

# 注入
insert_dylib --inplace @executable_path/BypassFace.dylib \
  ipa_work/Payload/*.app/YYCXDriver

# 重打包
cd ipa_work && zip -qr ../至尊好的出租联盟_免刷脸.ipa Payload/
```

## 已 Hook 的类和方法

| 类 | 方法 | 效果 |
|-----|------|------|
| `BLMFaceBLMVAppService` | `isSupportBLMFaceScan` | 返回 NO |
| `BLMFaceMegviiVAppService` | `isSupportKuangShiFaceScan` | 返回 NO |
| `BLMFaceTencentVAppService` | `isSupportTencentFaceScan` | 返回 NO |
| `AJXFaceScanModule` | `faceDetectRegister:callback:` | 直接回调成功 |
| `AJXFaceScanModule` | `faceDetectScan:callback:` | 直接回调成功 |
| `AJXFaceScanModule` | `tencentFaceScan:callback:` | 直接回调成功 |
| `AJXFaceScanModule` | `kuangShiFaceScan:callback:` | 直接回调成功 |
| `AJXFaceScanModule` | `startBLMFaceScan:callback:` | 直接回调成功 |
| `LTMAJXJSAccount` | `onLogin:` | 注入 faceVerified=YES |