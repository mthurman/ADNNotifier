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

@implementation MTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // get the params to listen for
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs stringForKey:@"username"];
    NSString *channelID = [prefs stringForKey:@"channelID"];

    // Initalize the ANKClient with a user token. Always fetch 0 objects so we just subscribe immediately
    ANKClient *client = [ANKClient sharedClient];
    NSString *access_token = [self getAccessToken:username];
    [client setAccessToken: access_token];
    // TODO: This doesn't seem to work with 0 (0 is somehow falsey)
    [client setPagination: [ANKPaginationSettings settingsWithCount:1]];

    // Actually subscribe to stuff
    ANKJSONRequestOperation *operation = [client fetchMessagesInChannelWithID:channelID completion:^(id responseObject, ANKAPIResponseMeta *meta, NSError *error) {
        NSLog(@"hello world: %@", [responseObject debugDescription]);
    }];

    [client requestStreamingUpdatesForOperation: operation withDelegate:self];
}

 -(NSString *)getAccessToken:(NSString *)username
{
    NSString *service = @"ADNNotifier";
    return [SSKeychain passwordForService:service account:username];
}

-(void)client:(ANKClient *)client didReceiveObject:(id)responseObject withMeta:(ANKAPIResponseMeta *)meta
{
    ANKMessage* message = [responseObject objectAtIndex:0];
    NSLog(@"we got something: %@", [message debugDescription]);
    [self sendNotification:@"New Private Message" text:[message text]];
}

-(void)sendNotification:(NSString *)title text:(NSString *)message
{
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
