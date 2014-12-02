//
//  UINavigationController+RUColoredStatusBarView.m
//  Nifti
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "UINavigationController+RUColoredStatusBarView.h"
#import "RUSynthesizeAssociatedObjects.h"
#import "RUConditionalReturn.h"





NSString* const kUINavigationController_RUColoredStatusBarView_StatusBarBackgroundView_TapAssociatedKey = @"kUINavigationController_RUColoredStatusBarView_StatusBarBackgroundView_TapAssociatedKey";





@implementation UINavigationController (RUColoredStatusBarView)

#pragma mark - ru_statusBarBackgroundColor
-(UIColor *)ru_statusBarBackgroundColor
{
	return self.ru_statusBarBackgroundView.backgroundColor;
}

-(void)setRu_statusBarBackgroundColor:(UIColor *)ru_statusBarBackgroundColor
{
	kRUConditionalReturn(self.ru_statusBarBackgroundColor == ru_statusBarBackgroundColor, NO);
	
	if (ru_statusBarBackgroundColor)
	{
		if (self.ru_statusBarBackgroundView == nil)
		{
			[self setRu_statusBarBackgroundView:[UIView new]];
			[self.ru_statusBarBackgroundView setFrame:(CGRect){
				.size.width		= CGRectGetWidth(self.view.bounds),
				.size.height	= CGRectGetHeight([UIApplication sharedApplication].statusBarFrame),
			}];
			
			[self.ru_statusBarBackgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin)];
			[self.view setAutoresizesSubviews:YES];
			
			[self.view addSubview:self.ru_statusBarBackgroundView];
		}
		
		[self.ru_statusBarBackgroundView setBackgroundColor:ru_statusBarBackgroundColor];
	}
	else
	{
		if (self.ru_statusBarBackgroundView)
		{
			[self.ru_statusBarBackgroundView removeFromSuperview];
			[self setRu_statusBarBackgroundView:nil];
		}
	}
}

#pragma mark - Synthesize Associated Objects
RU_Synthesize_AssociatedObject_GetterSetter_Implementation(ru, Ru, _statusBarBackgroundView, UIView*, &kUINavigationController_RUColoredStatusBarView_StatusBarBackgroundView_TapAssociatedKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

@end
