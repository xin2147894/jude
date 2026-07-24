/*
 * 至尊好的出租联盟 - 免刷脸登录 iOS Tweak
 * 
 * 功能: 绕过所有面部识别验证
 * 适用: 至尊好的出租联盟 (YYCXDriver) v6.30.5.x
 * 编译: 使用 Theos
 *   export THEOS=/opt/theos
 *   make
 * 
 * 注入: 在 GitHub Actions 上编译后注入 IPA
 */

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// ============================================================
// 白马人脸 - 3个服务类都说不支持
// ============================================================
%hook BLMFaceBLMVAppService
- (BOOL)isSupportBLMFaceScan { return NO; }
%end

%hook BLMFaceMegviiVAppService
- (BOOL)isSupportKuangShiFaceScan { return NO; }
%end

%hook BLMFaceTencentVAppService
- (BOOL)isSupportTencentFaceScan { return NO; }
%end

// ============================================================
// AJX 人脸扫描模块 - 拦截扫描/注册方法
// ============================================================
%hook AJXFaceScanModule

// 人脸检测注册 - 直接回调成功
- (void)faceDetectRegister:(id)arg callback:(id)callback {
    HBLogDebug(@"[BypassFace] faceDetectRegister bypassed");
    if (callback) {
        NSDictionary *result = @{
            @"code": @200,
            @"message": @"success",
            @"data": @{
                @"faceToken": [@"bypass_" stringByAppendingString:@([[NSDate date] timeIntervalSince1970] * 1000).stringValue]
            }
        };
        if ([callback respondsToSelector:@selector(onResult:)]) {
            [callback onResult:result];
        }
    }
}

// 人脸检测扫描 - 直接回调成功
- (void)faceDetectScan:(id)arg callback:(id)callback {
    HBLogDebug(@"[BypassFace] faceDetectScan bypassed");
    if (callback) {
        NSDictionary *result = @{
            @"code": @200,
            @"message": @"success",
            @"data": @{
                @"faceId": [@"bypass_" stringByAppendingString:@([[NSDate date] timeIntervalSince1970] * 1000).stringValue],
                @"livenessScore": @1.0,
                @"isLive": @YES
            }
        };
        if ([callback respondsToSelector:@selector(onResult:)]) {
            [callback onResult:result];
        }
    }
}

// 腾讯优图人脸扫描 - 直接回调成功
- (void)tencentFaceScan:(id)arg callback:(id)callback {
    HBLogDebug(@"[BypassFace] tencentFaceScan bypassed");
    if (callback) {
        NSDictionary *result = @{
            @"code": @200,
            @"message": @"success",
            @"result": @"success"
        };
        if ([callback respondsToSelector:@selector(onResult:)]) {
            [callback onResult:result];
        }
    }
}

// 旷世人脸扫描 - 直接回调成功
- (void)kuangShiFaceScan:(id)arg callback:(id)callback {
    HBLogDebug(@"[BypassFace] kuangShiFaceScan bypassed");
    if (callback) {
        NSDictionary *result = @{
            @"code": @200,
            @"message": @"success",
            @"result": @"success"
        };
        if ([callback respondsToSelector:@selector(onResult:)]) {
            [callback onResult:result];
        }
    }
}

// 白马人脸扫描 - 直接回调成功
- (void)startBLMFaceScan:(id)arg callback:(id)callback {
    HBLogDebug(@"[BypassFace] startBLMFaceScan bypassed");
    if (callback) {
        NSDictionary *result = @{
            @"code": @200,
            @"message": @"success",
            @"result": @"success"
        };
        if ([callback respondsToSelector:@selector(onResult:)]) {
            [callback onResult:result];
        }
    }
}

%end

// ============================================================
// AJX 账号模块 - 登录时注入人脸验证状态
// ============================================================
%hook LTMAJXJSAccount

- (void)onLogin:(id)arg {
    HBLogDebug(@"[BypassFace] LTMAJXJSAccount onLogin intercepted");
    if (arg && [arg isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *modifiedArg = [arg mutableCopy];
        modifiedArg[@"faceVerified"] = @YES;
        modifiedArg[@"faceToken"] = [@"bypass_" stringByAppendingString:@([[NSDate date] timeIntervalSince1970] * 1000).stringValue];
        modifiedArg[@"faceStatus"] = @"verified";
        arg = modifiedArg;
    }
    %orig(arg);
}

%end

// ============================================================
// 构造函数
// ============================================================
%ctor {
    HBLogDebug(@"[BypassFace] 好的出租联盟 - 免刷脸登录 Tweak 已加载");
    HBLogDebug(@"[BypassFace] 所有面部识别验证已绕过");
}