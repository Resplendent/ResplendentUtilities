//
//  RUHorizontalTitlePagingViewCollectionViewCell.m
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/14/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import "RUHorizontalTitlePagingViewCollectionViewCell.h"





@interface RUHorizontalTitlePagingViewCollectionViewCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* imageView;;

@property (nonatomic, readonly) CGRect titleLabelFrame;
@property (nonatomic, readonly) CGRect imageViewFrame;

@end





@implementation RUHorizontalTitlePagingViewCollectionViewCell

#pragma mark - UIView
-(void)layoutSubviews
{
	[super layoutSubviews];
	
	if (self.titleLabel)
	{
		[self.titleLabel setFrame:self.titleLabelFrame];
	}
	
	if (self.imageView)
	{
		[self.imageView setFrame:self.imageViewFrame];
	}
}

#pragma mark - Getters
-(NSString *)title
{
	return self.titleLabel.text;
}

#pragma mark - Setters
-(void)setTitle:(NSString *)title
{
	if ([self.title isEqual:title])
		return;
	
	if (title.length)
	{
		if (!self.titleLabel)
		{
			[self setTitleLabel:[UILabel new]];
			[self.titleLabel setBackgroundColor:[UIColor clearColor]];
			[self.titleLabel setTextAlignment:NSTextAlignmentCenter];
//			[self.titleLabel setTextColor:[UIColor wfRedColor]];
//			[self.titleLabel setFont:[UIFont wfGillSansMTProMediumFontWithSize:18.0f]];
			[self.titleLabel setNumberOfLines:0];
			[self.contentView addSubview:self.titleLabel];
			[self setNeedsLayout];
		}
		
		[self.titleLabel setText:title];
	}
	else
	{
		if (self.titleLabel)
		{
			[self.titleLabel removeFromSuperview];
			[self setTitleLabel:nil];
		}
	}
}

#pragma mark - Frames
-(CGRect)titleLabelFrame
{
	return self.bounds;
}

@end
