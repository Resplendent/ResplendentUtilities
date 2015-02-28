//
//  RUCompatability.h
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/21/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUCompatability : NSObject

+(BOOL)screenSizeIs4inch;
+(BOOL)screenSizeIs3Point5inch;

+(BOOL)isIOS7;
+(BOOL)isPreIOS7;

@end
