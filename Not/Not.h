//
//  Not.h
//  Not
//
//  Created by Geoffroy Lorieux on 1/8/13.
//  Copyright (c) 2013 TechMantra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Not : NSObject

- (void)exec:(const char **)command withSize:(int)size;

@end
