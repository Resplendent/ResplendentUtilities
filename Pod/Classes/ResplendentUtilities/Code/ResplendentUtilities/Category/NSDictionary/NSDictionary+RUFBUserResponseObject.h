//
//  NSDictionary+RUFBUserResponseObject.h
//  Resplendent
//
//  Created by Benjamin Maer on 6/24/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RUFBUserResponseObject)

@property (nonatomic, readonly) NSString* fbUserFirstName;
@property (nonatomic, readonly) NSString* fbUserLastName;
@property (nonatomic, readonly) NSString* fbUserName;
@property (nonatomic, readonly) NSString* fbUserUsername;
@property (nonatomic, readonly) NSString* fbUserId;

@end
