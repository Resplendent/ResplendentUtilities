//
//  RUFacebookControllerProtocols.h
//  Pineapple
//
//  Created by Benjamin Maer on 2/23/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUFacebookController;
@class FBAccessTokenData;

@protocol RUFacebookControllerDelegate <NSObject>

- (void)facebookController:(RUFacebookController*)facebookController didLogInWithToken:(FBAccessTokenData*)token;
- (void)facebookController:(RUFacebookController*)facebookController didFailWithError:(NSError*)error;
- (void)facebookControllerClearedToken:(RUFacebookController*)facebookController;

@end
