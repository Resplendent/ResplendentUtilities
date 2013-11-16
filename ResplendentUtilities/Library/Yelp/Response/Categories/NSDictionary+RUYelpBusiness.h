//
//  NSDictionary+RUYelpBusiness.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RUYelpBusiness)

@property (nonatomic, readonly) NSString* ruYelpBusinessUid;
@property (nonatomic, readonly) NSString* ruYelpBusinessName;
@property (nonatomic, readonly) NSString* ruYelpBusinessUrl;
@property (nonatomic, readonly) NSString* ruYelpBusinessImageUrl;
@property (nonatomic, readonly) NSNumber* ruYelpBusinessReviewCount;

//Only on full
@property (nonatomic, readonly) NSArray* ruYelpBusinessReviews;

@end
