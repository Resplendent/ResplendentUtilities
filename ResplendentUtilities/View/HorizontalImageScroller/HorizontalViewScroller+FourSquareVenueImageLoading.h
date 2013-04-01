//
//  HorizontalViewScroller+FourSquareVenueImageLoading.h
//  Pineapple
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "HorizontalViewScroller.h"

@class PAFourSquareVenuePhoto;

@interface HorizontalViewScroller (FourSquareVenueImageLoading)

-(void)addFourSquareVenuePhoto:(PAFourSquareVenuePhoto*)fourSquareVenuePhoto size:(CGSize)size;


@end
