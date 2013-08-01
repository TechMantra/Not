//
//  main.m
//  Not
//
//  Created by Geoffroy Lorieux on 1/8/13.
//  Copyright (c) 2013 TechMantra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "Not.h"

#pragma mark - Swizzle NSBundle

NSString *fakeBundleIdentifier = nil;

@implementation NSBundle(not)

- (NSString *)__bundleIdentifier
{
    if (self == [NSBundle mainBundle]) {
        return fakeBundleIdentifier ? fakeBundleIdentifier : @"com.apple.terminal";
    } else {
        return [self __bundleIdentifier];
    }
}

@end

BOOL installNSBundleHook()
{
    Class class = objc_getClass("NSBundle");
    if (class) {
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(bundleIdentifier)),
                                       class_getInstanceMethod(class, @selector(__bundleIdentifier)));
        return YES;
    }
	return NO;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
        if (installNSBundleHook()) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            fakeBundleIdentifier = [defaults stringForKey:@"Not"];
        }
        
        Not* notifier = [Not alloc];
        [notifier exec:argv withSize:argc];
    }
    return 0;
}

