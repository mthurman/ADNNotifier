//
//  MTSubscriptionHandler.m
//  ADNNotifier
//
//  Created by Mark Thurman on 1/25/14.
//  Copyright (c) 2014 Mark Thurman. All rights reserved.
//

#import "MTSubscriptionHandler.h"
#import <ADNKit/ADNKit.h>

@implementation MTSubscriptionHandler

+(instancetype)handlerWithType:(SubscriptionType)subType {
    MTSubscriptionHandler *handler = [[[self class] alloc] init];
	handler.subType = subType;
	return handler;
}

-(void)client:(ANKClient *)client didReceiveObject:(id)responseObject withMeta:(ANKAPIResponseMeta *)meta {
    if (meta.isDeleted) {
        return;
    }
    switch (self.subType) {
        case PrivateMessage:{
            ANKMessage* message = [responseObject objectAtIndex:0];
            if (message.user.userID != client.authenticatedUser.userID) {
                [self sendNotification:@"New Private Message" text:[message text]];
            }
            break;
        }
        case Mention:{
            ANKPost* post = [responseObject objectAtIndex:0];
            [self sendNotification:@"New Mention" text:[post text]];
            break;
        }
        case Follower:{
            ANKUser* user = [responseObject objectAtIndex:0];
            [self sendNotification:@"New Follower" text:[user username]];
            break;
        }
        default:
            break;
    }
}

-(void)sendNotification:(NSString *)title text:(NSString *)message {
    //Initalize new notification
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    //Set the title of the notification
    [notification setTitle:title];
    //Set the text of the notification
    [notification setInformativeText:message];

    //Get the default notification center
    NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
    //Scheldule our NSUserNotification
    [center scheduleNotification:notification];
}

@end
