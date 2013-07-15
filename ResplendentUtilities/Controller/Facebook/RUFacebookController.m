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
                [_delegate facebookController:self didLogInWithToken:session.accessTokenData];
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
    return nil;
}

-(NSArray *)publishPermissions
{
    return nil;
}

-(FBAccessTokenData *)accessTokenData
{
    return FBSession.activeSession.accessTokenData;
}

#pragma mark - Static Share Actions
+(void)showInviteOnFriendsWallWithFacebookId:(NSInteger)facebookId
{
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString* facebookAppId = [dict objectForKey:@"FacebookAppID"];

    if (facebookAppId.length)
    {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{@"app_id": facebookAppId,@"to":RUStringWithFormat(@"%i",facebookId)}];
        
        NSString* link = [self shareLink];
        if (link.length)
        {
            [params setObject:link forKey:@"link"];
        }
        
        NSString* name = [self shareName];
        if (name.length)
        {
            [params setObject:name forKey:@"name"];
        }
        
        NSString* caption = [self shareCaption];
        if (caption.length)
        {
            [params setObject:name forKey:@"caption"];
        }
        
        NSString* description = [self shareDescription];
        if (description.length)
        {
            [params setObject:name forKey:@"description"];
        }
        
        [FBWebDialogs presentDialogModallyWithSession:[FBSession activeSession] dialog:@"feed" parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
            [self didFinishPostingToWallOfUserWithFacebookId:facebookId result:result resultURL:resultURL error:error];
        }];
    }
    else
    {
        RUDLog(@"can't find facebook app id");
    }
}

#pragma mark - Post Action methods
+(void)didFinishPostingToWallOfUserWithFacebookId:(NSInteger)facebookId result:(FBWebDialogResult)result resultURL:(NSURL*)resultURL error:(NSError*)error
{
    if (error)
    {
        RUDLog(@"error: %@",error);
    }
    
    RUDLog(@"resultURL: %@",resultURL);
}

#pragma mark - Parsing
+(NSDictionary*)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    
    return params;
}

#pragma mark - Static Getters
+(NSString*)shareLink{return nil;}
+(NSString*)shareName{return nil;}
+(NSString*)shareCaption{return nil;}
+(NSString*)shareDescription{return nil;}

@end
