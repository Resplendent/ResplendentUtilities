//
//  RUTextViewWithPlaceholderContainerView.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUTextViewWithPlaceholderContainerView.h"
#import "UILabel+RUTextSize.h"





@interface RUTextViewWithPlaceholderContainerView ()

@end





@implementation RUTextViewWithPlaceholderContainerView

#pragma mark - UIView
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		_textView = [UITextView new];
		[self.textView setDelegate:self];
		[self addSubview:self.textView];

		_textViewPlaceholderLabel = [UILabel new];
		[self.textView addSubview:self.textViewPlaceholderLabel];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	[self.textView setFrame:self.textViewFrame];
	[self.textViewPlaceholderLabel setFrame:self.textViewPlaceholderLabelFrame];
}

#pragma mark - Frames
-(CGRect)textViewFrame
{
	return self.bounds;
}

-(CGRect)textViewPlaceholderLabelFrame
{
	CGSize textSize = [self.textViewPlaceholderLabel ruTextSize];

	return CGRectCeilOrigin((CGRect){
		.origin.y		= CGRectGetVerticallyAlignedYCoordForHeightOnHeight(textSize.height, CGRectGetHeight(self.bounds)),
		.size.width		= CGRectGetWidth(self.bounds),
		.size.height	= textSize.height,
	});
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)theTextView
{
	[self updateTextViewPlaceholderLabelVisilibity];
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self updateTextViewPlaceholderLabelVisilibity];
}

#pragma mark - Update Content
-(void)updateTextViewPlaceholderLabelVisilibity
{
	[self.textViewPlaceholderLabel setHidden:(self.textView.text.length > 0)];
}

@end
