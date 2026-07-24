/*
 * 至尊好的出租联盟 - 免刷脸登录 iOS Tweak
 */

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

%hook BLMFaceBLMVAppService
- (BOOL)isSupportBLMFaceScan { return NO; }
%end

%hook BLMFaceMegviiVAppService
- (BOOL)isSupportKuangShiFaceScan { return NO; }
%end

%hook BLMFaceTencentVAppService
- (BOOL)isSupportTencentFaceScan { return NO; }
%end

%hook AJXFaceScanModule

- (void)faceDetectRegister:(id)arg callback:(id)callback {
    NSLog(@"[BypassFace] faceDetectRegister bypassed");
    if (callback) {
        NSDictionary *result = @{
            @"code": @200, @"message": @"success",
            @"data": @{ @"faceToken": [@"bypass_" stringByAppendingString:@([[NSDate date] timeIntervalSince1970] * 1000).stringValue] }
        };
        SEL sel = NSSelectorFromString(@"onResult:");
        if ([callback respondsToSelector:sel]) {
            ((void (*)(id, SEL, id))[callback methodForSelector:sel])(callback, sel, result);
        }
    }
}

- (void)faceDetectScan:(id)arg callback:(id)callback {
    NSLog(@"[BypassFace] faceDetectScan bypassed");
    if (callback) {
        NSDictionary *result = @{
            @"code": @200, @"message": @"success",
            @"data": @{ @"faceId": [@"bypass_" stringByAppendingString:@([[NSDate date] timeIntervalSince1970] * 1000).stringValue], @"livenessScore": @1.0, @"isLive": @YES }
        };
        SEL sel = NSSelectorFromString(@"onResult:");
        if ([callback respondsToSelector:sel]) {
            ((void (*)(id, SEL, id))[callback methodForSelector:sel])(callback, sel, result);
        }
    }
}

- (void)tencentFaceScan:(id)arg callback:(id)callback {
    NSLog(@"[BypassFace] tencentFaceScan bypassed");
    if (callback) {
        NSDictionary *result = @{@"code": @200, @"message": @"success", @"result": @"success"};
        SEL sel = NSSelectorFromString(@"onResult:");
        if ([callback respondsToSelector:sel]) {
            ((void (*)(id, SEL, id))[callback methodForSelector:sel])(callback, sel, result);
        }
    }
}

- (void)kuangShiFaceScan:(id)arg callback:(id)callback {
    NSLog(@"[BypassFace] kuangShiFaceScan bypassed");
    if (callback) {
        NSDictionary *result = @{@"code": @200, @"message": @"success", @"result": @"success"};
        SEL sel = NSSelectorFromString(@"onResult:");
        if ([callback respondsToSelector:sel]) {
            ((void (*)(id, SEL, id))[callback methodForSelector:sel])(callback, sel, result);
        }
    }
}

- (void)startBLMFaceScan:(id)arg callback:(id)callback {
    NSLog(@"[BypassFace] startBLMFaceScan bypassed");
    if (callback) {
        NSDictionary *result = @{@"code": @200, @"message": @"success", @"result": @"success"};
        SEL sel = NSSelectorFromString(@"onResult:");
        if ([callback respondsToSelector:sel]) {
            ((void (*)(id, SEL, id))[callback methodForSelector:sel])(callback, sel, result);
        }
    }
}

%end

%hook LTMAJXJSAccount
- (void)onLogin:(id)arg {
    NSLog(@"[BypassFace] LTMAJXJSAccount onLogin intercepted");
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

%ctor {
    NSLog(@"[BypassFace] 好的出租联盟 - 免刷脸登录 Tweak 已加载");
}
