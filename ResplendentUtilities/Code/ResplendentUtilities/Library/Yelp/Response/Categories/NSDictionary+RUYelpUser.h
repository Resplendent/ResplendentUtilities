//
//  NSDictionary+RUYelpUser.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/28/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RUYelpUser)

@property (nonatomic, readonly) NSString* ruYelpUserId;
@property (nonatomic, readonly) NSString* ruYelpUserImageUrl;
@property (nonatomic, readonly) NSString* ruYelpUserName;

@end
