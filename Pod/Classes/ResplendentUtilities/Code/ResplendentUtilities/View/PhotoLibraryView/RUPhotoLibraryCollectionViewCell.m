//
//  RUPhotoLibraryCollectionViewCell.m
//  Shimmur
//
//  Created by Benjamin Maer on 3/11/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import "RUPhotoLibraryCollectionViewCell.h"





@interface RUPhotoLibraryCollectionViewCell ()

@property (nonatomic, readonly) UIImageView* imageView;
@property (nonatomic, readonly) CGRect imageViewFrame;

@end





@implementation RUPhotoLibraryCollectionViewCell

#pragma mark - UIView
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self.contentView setBackgroundColor:[UIColor blackColor]];

		_imageView = [UIImageView new];
		[self.imageView setBackgroundColor:[UIColor clearColor]];
		[self.imageView setClipsToBounds:YES];
		[self.imageView setContentMode:UIViewContentModeScaleAspectFill];
		[self.contentView addSubview:self.imageView];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	[self.imageView setFrame:self.imageViewFrame];
}

#pragma mark - Frames
-(CGRect)imageViewFrame
{
	return self.contentView.bounds;
}

#pragma mark - Setters
-(void)setAsset:(ALAsset *)asset
{
	if (self.asset == asset)
	{
		return;
	}
	
	_asset = asset;
	
	[self.imageView setImage:(self.asset.aspectRatioThumbnail ? [UIImage imageWithCGImage:self.asset.aspectRatioThumbnail] : nil)];
}

@end
