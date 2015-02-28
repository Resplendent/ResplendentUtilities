//
//  RUCollectionViewFlowLayout_ContentSizeAdjustForMinimumLineSpacing.m
//  Nifti
//
//  Created by Benjamin Maer on 11/29/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "RUCollectionViewFlowLayout_ContentSizeAdjustForMinimumLineSpacing.h"





@implementation RUCollectionViewFlowLayout_ContentSizeAdjustForMinimumLineSpacing

-(CGSize)collectionViewContentSize
{
	CGSize collectionViewContentSize = [super collectionViewContentSize];
	
	switch (self.scrollDirection)
	{
		case UICollectionViewScrollDirectionHorizontal:
			collectionViewContentSize.width += self.minimumLineSpacing;
			break;
			
		case UICollectionViewScrollDirectionVertical:
			collectionViewContentSize.height += self.minimumLineSpacing;
			
		default:
			NSAssert(false, @"unhandled");
			break;
	}
	
	return collectionViewContentSize;
}

@end
