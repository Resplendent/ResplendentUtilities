//
//  NSDictionary+RUFourSquareVenueCategory.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kRUFourSquareVenueCategoryNSDictionaryCategoriesKey;

@interface NSDictionary (RUFourSquareVenueCategory)

@property (nonatomic, readonly) NSString* ruFourSquareVenueCategoryName;
@property (nonatomic, readonly) NSString* ruFourSquareVenueCategoryUid;
@property (nonatomic, readonly) NSString* ruFourSquareVenueCategoryPluralName;
@property (nonatomic, readonly) NSString* ruFourSquareVenueCategoryShortName;

@property (nonatomic, readonly) NSArray* ruFourSquareVenueCategoryCategories;
@property (nonatomic, readonly) NSDictionary* ruFourSquareVenueCategoryIcon;

@end
