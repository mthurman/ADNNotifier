//
//  MTAppDelegate.h
//  ADNNotifier
//
//  Created by Mark Thurman on 1/25/14.
//  Copyright (c) 2014 Mark Thurman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ADNKit/ADNKit.h>

@interface MTAppDelegate : NSObject <NSApplicationDelegate, ANKStreamingDelegate>

@property (assign) IBOutlet NSWindow *window;

-(NSString *)getAccessToken;

@end
