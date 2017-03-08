//
//  H5WebKitBugsManager.m
//  SidebarDemo
//
//  Created by Solafort Yong on 9/20/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import "H5WebKitBugsManager.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

void H5Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@implementation H5WebKitBugsManager
+ (void)fixAllBugs
{
    [self fixBug_MediaPlayerVolumeView];
}

+ (void)fixBug_MediaPlayerVolumeView
{
    
    CGFloat systemVersion = [UIDevice currentDevice].systemVersion.floatValue;
    
    if (systemVersion < 8.0f || systemVersion > 9.0) {
        // 8.0以下没有VolumeView，9.0尚未测试是否由此问题，条件待修改
        return;
    }
    Class cls = NSClassFromString(@"WebMediaSessionHelper");
    NSString *allocateVolumeView = @"allocateVolumeView";
    SEL orig = NSSelectorFromString(allocateVolumeView);
    SEL new = @selector(H5WKBMAllocateVolumeView);
    Method newMethod = class_getInstanceMethod(self, new);
    
    if(class_addMethod(cls, new, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        H5Swizzle(cls, orig, new);
    }
    
}

- (void)H5WKBMAllocateVolumeView
{
    
    // WebKit's MediaSessionManageriOS is a singleton，in MediaSessionManageriOS.m. svn version181,859.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // must be dispatch in background thread
            [self H5WKBMAllocateVolumeView];
        });
    });
    
}

@end
