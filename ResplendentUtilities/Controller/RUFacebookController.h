//
//  RUFacebookController.h
//  Pineapple
//
//  Created by Benjamin Maer on 2/23/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 To compile, the following is required:
 1) In Target's Build settings, add "-lsqlite3.0" to Linking->Other Linking Flags
 2) Add Social, AdSupport, and Accounts, making them all optional if supporting pre 6.0

 For proper implementation, the following must be done:
 1) Add to AppDelegate's applicationDidBecomeActive:
 [FBSession.activeSession handleDidBecomeActive];
 */

@class RUFacebookController;

@protocol RUFacebookControllerDelegate <NSObject>

- (void)facebookController:(RUFacebookController*)facebookController didLogInWithToken:(NSString*)token;
- (void)facebookController:(RUFacebookController*)facebookController didFailWithError:(NSError*)error;
- (void)facebookControllerClearedToken:(RUFacebookController*)facebookController;

@end


@interface RUFacebookController : NSObject

@property (nonatomic, assign) id<RUFacebookControllerDelegate> delegate;
@property (nonatomic, readonly) NSString* accessToken;

//Performs clear and calls delegate
- (void)logout;

-(void)closeFacebookSession;

//Method used to login.
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

//Methods that should be called by application delegate
- (BOOL)applicationOpenedURL:(NSURL *)url;
- (void)applicationWillTerminate;
- (void)applicationDidBecomeActive;

@end

