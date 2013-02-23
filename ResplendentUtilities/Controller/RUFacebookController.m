//
//  RUFacebookController.m
//  Pineapple
//
//  Created by Benjamin Maer on 2/23/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFacebookController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "RUConstants.h"

@interface RUFacebookController ()

@property (nonatomic, readonly) NSArray* readPermissions;
@property (nonatomic, readonly) NSArray* publishPermissions;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

- (void)clearFacebookSession;

@end

@implementation RUFacebookController

#pragma mark - Public instance methods

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    return [FBSession openActiveSessionWithReadPermissions:self.readPermissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)applicationOpenedURL:(NSURL *)url
{
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillTerminate
{
    [FBSession.activeSession close];
}

- (void)applicationDidBecomeActive
{
    [FBSession.activeSession handleDidBecomeActive];
}

-(void)closeFacebookSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)logout
{
    FBSessionState state = FBSession.activeSession.state;
    [self clearFacebookSession];
    if (state != FBSession.activeSession.state)
        [self sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:nil];
}

#pragma mark - Private instance methods
-(void)clearFacebookSession
{
    [self closeFacebookSession];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
            if (error)
            {
                RUDLog(@"FBSessionStateOpen had error %@",error.localizedDescription);
                [_delegate facebookController:self didFailWithError:error];
            }
            else
            {
                // We have a valid session
                [_delegate facebookController:self didLogInWithToken:session.accessToken];
            }
            break;
            
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [self clearFacebookSession];
            [_delegate facebookControllerClearedToken:self];
            break;
            
        default:
            RUDLog(@"unhandled facebook state %i",state);
            break;
    }
}

#pragma mark - Getter methods
-(NSArray *)readPermissions
{
    @throw RU_MUST_OVERRIDE;
}

-(NSArray *)publishPermissions
{
    @throw RU_MUST_OVERRIDE;
//    return @[@"publish_stream", @"publish_actions"];
}

-(NSString *)accessToken
{
    return FBSession.activeSession.accessToken;
}

@end
