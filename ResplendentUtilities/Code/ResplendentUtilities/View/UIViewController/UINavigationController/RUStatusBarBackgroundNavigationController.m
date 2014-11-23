//
//  RUStatusBarBackgroundNavigationController.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/22/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUStatusBarBackgroundNavigationController.h"





@interface RUStatusBarBackgroundNavigationController ()

@property (nonatomic, readonly) UIView* statusBarBackgroundView;
@property (nonatomic, readonly) CGRect statusBarBackgroundViewFrame;

@end





@implementation RUStatusBarBackgroundNavigationController

@synthesize statusBarBackgroundView = _statusBarBackgroundView;

#pragma mark - RUStatusBarBackgroundNavigationController
-(instancetype)initWithStaticBarBackgroundColor:(UIColor*)staticBarBackgroundColor
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
	
	[self.view addSubview:self.statusBarBackgroundView];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	[self.statusBarBackgroundView setFrame:self.statusBarBackgroundViewFrame];
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

#pragma mark - Dynamic Getters
-(UIView *)statusBarBackgroundView
{
	if (_statusBarBackgroundView == nil)
	{
		_statusBarBackgroundView = [UIView new];
		[self setStatusBarBackgroundColor:[UIColor whiteColor]];
	}
	
	return _statusBarBackgroundView;
}

#pragma mark - Setters
-(UIColor *)statusBarBackgroundColor
{
	return self.statusBarBackgroundView.backgroundColor;
}

-(void)setStatusBarBackgroundColor:(UIColor *)statusBarBackgroundColor
{
	kRUConditionalReturn(self.statusBarBackgroundColor == statusBarBackgroundColor, NO);
	
	[self.statusBarBackgroundView setBackgroundColor:statusBarBackgroundColor];
}

@end
