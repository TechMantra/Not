//
//  Not.m
//  Not
//
//  Created by Geoffroy Lorieux on 1/8/13.
//  Copyright (c) 2013 TechMantra. All rights reserved.
//

#import "Not.h"

@implementation Not

- (void)exec:(const char **)command withSize:(int)size {
    
    NSString* startExecution = [NSString stringWithFormat:@"Starting to execute: %s", command[1]];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Start";
    notification.informativeText = [NSString stringWithFormat:@"%@", startExecution];
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    NSString* shell = [[[NSProcessInfo processInfo] environment] objectForKey:@"SHELL"];
    
    NSMutableArray* arguments = [[NSMutableArray alloc] init];
    
    for (int x = 1; x < size; x++) {
        [arguments addObject:[NSString stringWithFormat:@"%s", command[x]]];
    }
    
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];

    NSTask *task = [NSTask alloc];
    [task setLaunchPath:shell];
    
    NSString* args = [arguments componentsJoinedByString:@" "];
    
    [task setArguments:@[@"-c", args]];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    NSString *response =  [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    printf("%s", [response UTF8String]);
    
    NSUserNotification *not = [[NSUserNotification alloc] init];
    not.title = @"Done";
    not.informativeText = [NSString stringWithFormat:@"Done executing: %s", command[1]];
    not.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:not];
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

@end
