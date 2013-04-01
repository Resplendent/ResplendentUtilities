//
//  HorizontalViewScroller+FourSquareVenueImageLoading.m
//  Pineapple
//
//  Created by Benjamin Maer on 3/31/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "HorizontalViewScroller+FourSquareVenueImageLoading.h"
#import "AsynchronousImageView.h"
#import "HorizontalViewScroller+ImageFromUrl.h"
#import "PAFourSquareVenuePhoto.h"
#import "RUConstants.h"
#import "PAFourSquareVenuePhotoSizeItem.h"

@implementation HorizontalViewScroller (FourSquareVenueImageLoading)

-(void)addFourSquareVenuePhoto:(PAFourSquareVenuePhoto*)fourSquareVenuePhoto size:(CGSize)size
{
    CGSize adjustSize = RUSizeAdjustedToDeviceScreenSize(size);
    PAFourSquareVenuePhotoSizeItem* closestSizeItem = [fourSquareVenuePhoto sizeItemClosestToSize:adjustSize];

    if (closestSizeItem)
    {
        [self addImageFromUrlString:closestSizeItem.url size:size];
    }
    else
    {
        RUDLog(@"fourSquareVenuePhoto %@ had no closest size item to size %@",fourSquareVenuePhoto,NSStringFromCGSize(size));
    }
}

@end
