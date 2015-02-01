//
//  RUTextViewWithPlaceholderContainerView.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUTextViewWithPlaceholderContainerView.h"
#import "UILabel+RUTextSize.h"
#import "UIView+RUUtility.h"
#import "RUConditionalReturn.h"





static void* kRUTextViewWithPlaceholderContainerView__KVOContext = &kRUTextViewWithPlaceholderContainerView__KVOContext;





@interface RUTextViewWithPlaceholderContainerView ()

-(void)ru_setRegisteredToTextView:(BOOL)registered;

@end





@implementation RUTextViewWithPlaceholderContainerView

#pragma mark - NSObject
-(void)dealloc
{
	[self ru_setRegisteredToTextView:NO];
}

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

		[self ru_setRegisteredToTextView:YES];
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

	[self.textDelegate textViewWithPlaceholderContainerView:self textViewDidChangeText:self.textView.text];
}

#pragma mark - Update Content
-(void)updateTextViewPlaceholderLabelVisilibity
{
	[self.textViewPlaceholderLabel setHidden:(self.textView.text.length > 0)];
}

#pragma mark - KVO
-(void)ru_setRegisteredToTextView:(BOOL)registered
{
	kRUConditionalReturn(self.textView == nil, NO);
	
	static NSArray* propertiesToObserve;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		propertiesToObserve = @[
								@"text",
								];
	});
	
	for (NSString* propertyToObserve in propertiesToObserve)
	{
		if (registered)
		{
			[self.textView addObserver:self forKeyPath:propertyToObserve options:(NSKeyValueObservingOptionInitial) context:&kRUTextViewWithPlaceholderContainerView__KVOContext];
		}
		else
		{
			[self.textView removeObserver:self forKeyPath:propertyToObserve context:&kRUTextViewWithPlaceholderContainerView__KVOContext];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kRUTextViewWithPlaceholderContainerView__KVOContext)
	{
		if (object == self.textView)
		{
			if ([keyPath isEqualToString:@"text"])
			{
				[self updateTextViewPlaceholderLabelVisilibity];
			}
			else
			{
				NSAssert(false, @"unhandled");
			}
		}
		else
		{
			NSAssert(false, @"unhandled");
		}
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end
