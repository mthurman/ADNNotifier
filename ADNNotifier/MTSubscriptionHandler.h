//
//  MTSubscriptionHandler.h
//  ADNNotifier
//
//  Created by Mark Thurman on 1/25/14.
//  Copyright (c) 2014 Mark Thurman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ADNKit/ADNKit.h>

typedef enum {
    PrivateMessage,
    Mention,
    Follower,
} SubscriptionType;

@interface MTSubscriptionHandler : NSObject <ANKStreamingDelegate>

@property SubscriptionType subType;

+ (instancetype)handlerWithType:(SubscriptionType)subType;

@end
