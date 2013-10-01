//
//  NSDictionary+RUYelpBusinessReview.h
//  Pineapple
//
//  Created by Benjamin Maer on 9/27/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RUYelpBusinessReview)

@property (nonatomic, readonly) NSNumber* ruYelpBusinessReviewRating;
@property (nonatomic, readonly) NSString* ruYelpBusinessReviewExcerpt;
@property (nonatomic, readonly) NSDictionary* ruYelpBusinessReviewUser;
@property (nonatomic, readonly) NSString* ruYelpBusinessReviewTimeStamp;

@end
