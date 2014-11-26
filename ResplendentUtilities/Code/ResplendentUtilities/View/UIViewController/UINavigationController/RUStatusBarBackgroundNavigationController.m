//
//  RUStatusBarBackgroundNavigationController.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUStatusBarBackgroundNavigationController.h"
#import "RUConditionalReturn.h"





@interface RUStatusBarBackgroundNavigationController ()

@property (nonatomic, readonly) UIView* statusBarBackgroundView;
@property (nonatomic, readonly) CGRect statusBarBackgroundViewFrame;

-(void)updateStatusBarBackgroundViewColor;

@end





@implementation RUStatusBarBackgroundNavigationController

#pragma mark - RUStatusBarBackgroundNavigationController
-(instancetype)initWithStatusBarBackgroundColor:(UIColor*)staticBarBackgroundColor
{
	if (self = [self init])
	{
		[self setStatusBarBackgroundColor:staticBarBackgroundColor];
	}
	
	return self;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	_statusBarBackgroundView = [UIView new];
	[self updateStatusBarBackgroundViewColor];
	[self.view addSubview:self.statusBarBackgroundView];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	[self.statusBarBackgroundView setFrame:self.statusBarBackgroundViewFrame];
}

#pragma mark - Update Content
-(void)updateStatusBarBackgroundViewColor
{
	[self.statusBarBackgroundView setBackgroundColor:self.statusBarBackgroundColor];
}

#pragma mark - Frames
-(CGRect)statusBarBackgroundViewFrame
{
	CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
	CGFloat height = (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? CGRectGetWidth(statusBarFrame) : CGRectGetHeight(statusBarFrame));
	return (CGRect){
		.size.width = CGRectGetWidth(self.view.bounds),
		.size.height = height,
	};
}

#pragma mark - Setters
-(void)setStatusBarBackgroundColor:(UIColor *)statusBarBackgroundColor
{
	kRUConditionalReturn(self.statusBarBackgroundColor == statusBarBackgroundColor, NO);
	
	_statusBarBackgroundColor = statusBarBackgroundColor;

	[self updateStatusBarBackgroundViewColor];
}

@end
