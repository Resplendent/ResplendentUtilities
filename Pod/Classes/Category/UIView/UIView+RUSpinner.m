//
//  UIView+RUSpinner.m
//  Resplendent
//
//  Created by Benjamin Maer on 4/7/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "UIView+RUSpinner.h"
#import "RUSynthesizeAssociatedObjects.h"
#import "UIView+RUUtility.h"





NSString* const kUIView_RUSpinner_AssociatedObject_Name_ruSpinner = @"kUIView_RUSpinner_AssociatedObject_Name_ruSpinner";





@interface UIView (_RUSpinner)

-(void)_ruUpdateSpinnerFrame;

@end




@implementation UIView (_RUSpinner)

-(void)_ruUpdateSpinnerFrame
{
    if (self.ruSpinner)
    {
        CGSize size = [self.ruSpinner sizeThatFits:(CGSize){
			.width = CGRectGetWidth(self.bounds),
			.height = CGRectGetHeight(self.bounds)
		}];

        [self.ruSpinner setFrame:(CGRect){
			.origin.x = CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(size.width, CGRectGetWidth(self.bounds)),
            .origin.y = CGRectGetVerticallyAlignedYCoordForHeightOnHeight(size.height, CGRectGetHeight(self.bounds)),
            .size = size
        }];
    }
}

@end




@implementation UIView (RUSpinner)

#pragma mark - ruSpinnerVisibility
-(BOOL)ruSpinnerVisibility
{
	return (self.ruSpinner != nil);
}

-(void)setRuSpinnerVisibility:(BOOL)ruSpinnerVisibility
{
	if (self.ruSpinnerVisibility == ruSpinnerVisibility)
		return;

	if (ruSpinnerVisibility)
	{
		if (!self.ruSpinner)
		{
			[self setRuSpinner:[UIActivityIndicatorView new]];
			[self _ruUpdateSpinnerFrame];
			[self addSubview:self.ruSpinner];
			[self setAutoresizesSubviews:YES];
			[self.ruSpinner setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
		}

        [self.ruSpinner startAnimating];
	}
	else
	{
		if (self.ruSpinner)
		{
			[self.ruSpinner removeFromSuperview];
			[self setRuSpinner:nil];
		}
	}
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru, Ru, Spinner, UIActivityIndicatorView*, &kUIView_RUSpinner_AssociatedObject_Name_ruSpinner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end
