//
//  MTAppDelegate.m
//  ADNNotifier
//
//  Created by Mark Thurman on 1/25/14.
//  Copyright (c) 2014 Mark Thurman. All rights reserved.
//

#import "MTAppDelegate.h"
#import <ADNKit/ADNKit.h>
#import <ADNKit/ANKUser.h>
#import <SSKeychain.h>
#import "MTSubscriptionHandler.h"

@implementation MTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // initalize this app
    self.handlers = [NSMutableSet set];

    // get the params to listen for
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs stringForKey:@"username"];

    // Initalize the ANKClient with a user token. Always fetch 0 objects so we just subscribe immediately
    ANKClient *client = [ANKClient sharedClient];
    NSString *access_token = [self getAccessToken:username];
    [client logInWithAccessToken:access_token completion:^(BOOL succeeded, ANKAPIResponseMeta *meta, NSError *error) {
        // error handling
    }];
    [client setPagination:[ANKPaginationSettings settingsWithCount:0]];

    // Actually subscribe to stuff

    // Private messages
    ANKJSONRequestOperation *pm_operation = [client fetchCurrentUserSubscribedChannelsWithTypes:@[@"net.app.core.pm"] completion:^(id responseObject, ANKAPIResponseMeta *meta, NSError *error) {
        // This really should only be an error check to make sure we got subscribed like we expected
    }];

    MTSubscriptionHandler *pm_handler = [MTSubscriptionHandler handlerWithType:PrivateMessage];
    [self.handlers addObject:pm_handler];
    [client requestStreamingUpdatesForOperation:pm_operation withDelegate:pm_handler];

    // New Mention
    ANKJSONRequestOperation *mention_operation = [client fetchPostsMentioningUserWithID:@"me" completion:^(id responseObject, ANKAPIResponseMeta *meta, NSError *error) {
    }];

    MTSubscriptionHandler *mention_handler = [MTSubscriptionHandler handlerWithType:Mention];
    [self.handlers addObject:mention_handler];
    [client requestStreamingUpdatesForOperation:mention_operation withDelegate:mention_handler];

    // New Follower
    ANKJSONRequestOperation *follower_operation = [client fetchUsersFollowingUserWithID:@"me" completion:^(id responseObject, ANKAPIResponseMeta *meta, NSError *error) {
    }];

    MTSubscriptionHandler *follower_handler = [MTSubscriptionHandler handlerWithType:Follower];
    [self.handlers addObject:follower_handler];
    [client requestStreamingUpdatesForOperation:follower_operation withDelegate:follower_handler];
}

 -(NSString *)getAccessToken:(NSString *)username
{
    NSString *service = @"ADNNotifier";
    return [SSKeychain passwordForService:service account:username];
}
@end
