//
//  RUSlideMenuNavigationController.m
//  Nifti
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "RUSlideMenuNavigationController.h"
#import "RUProtocolOrNil.h"
#import "RUConditionalReturn.h"





CGFloat const kRUSlideMenuNavigationController_MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION = 1200.0f;
CGFloat const kRUSlideMenuNavigationController_MENU_QUICK_SLIDE_ANIMATION_DURATION = .18f;
CGFloat const kRUSlideMenuNavigationController_MENU_SLIDE_ANIMATION_DURATION = .3f;





@interface RUSlideMenuNavigationController ()

@property (nonatomic, readonly) UIViewController<RUSlideNavigationController_DisplayDelegate>* currentViewControllerForDisplayActions;
@property (nonatomic, readonly) UIView* currentViewControllerMenuView;
-(UIView *)currentViewControllerMenuViewForMenuType:(RUSlideNavigationController_MenuType)menuType;
-(UIView *)defaultMenuViewForMenuType:(RUSlideNavigationController_MenuType)menuType;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint draggingPoint;

@property (nonatomic, readonly) CGFloat horizontalLocation;
@property (nonatomic, readonly) CGFloat horizontalLocationWithMovement;
-(RUSlideNavigationController_MenuType)menuTypeForHorizontalLocation:(CGFloat)horizontalLocation;
- (CGRect)initialRectForMenu:(RUSlideNavigationController_MenuType)menu;
@property (nonatomic, readonly) CGFloat horizontalSize;

@property (nonatomic, readonly) CGFloat minXForDragging;
@property (nonatomic, readonly) CGFloat maxXForDragging;
@property (nonatomic, readonly) CGFloat slideOffset;

@property (nonatomic, assign) RUSlideNavigationController_MenuType lastMenu;

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer;
- (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer;

- (void)prepareMenuForReveal:(RUSlideNavigationController_MenuType)menu forcePrepare:(BOOL)forcePrepare;
- (BOOL)shouldDisplayMenu:(RUSlideNavigationController_MenuType)menu forViewController:(UIViewController *)vc;

- (void)updateMenuFrameAndTransformAccordingToOrientation;

- (void)moveHorizontallyToLocation:(CGFloat)location;
- (void)updateMenuAnimation:(RUSlideNavigationController_MenuType)menu;
- (void)openMenu:(RUSlideNavigationController_MenuType)menu withDuration:(float)duration andCompletion:(void (^)())completion;
- (void)closeMenuWithDuration:(float)duration andCompletion:(void (^)())completion;
- (void)toggleMenu:(RUSlideNavigationController_MenuType)menu withCompletion:(void (^)())completion;

- (void)enableTapGestureToCloseMenu:(BOOL)enable;

@end





@implementation RUSlideMenuNavigationController

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self setEnableSwipeGesture:YES];
}

#pragma mark - Update Content
- (void)updateMenuFrameAndTransformAccordingToOrientation
{
	// Animate rotatation when menu is open and device rotates
	CGAffineTransform transform = self.view.transform;
	self.defaultLeftMenuView.transform = transform;
	self.defaultLeftMenuView.frame = [self initialRectForMenu:RUSlideNavigationController_MenuType_Left];

	self.defaultRightMenuView.transform = transform;
	self.defaultRightMenuView.frame = [self initialRectForMenu:RUSlideNavigationController_MenuType_Right];

	if (self.currentViewControllerMenuView)
	{
		self.currentViewControllerMenuView.transform = transform;
		self.currentViewControllerMenuView.frame = [self initialRectForMenu:[self menuTypeForHorizontalLocation:self.horizontalLocationWithMovement]];
	}
}

- (void)moveHorizontallyToLocation:(CGFloat)location
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = self.interfaceOrientation;
	RUSlideNavigationController_MenuType menu = ((self.horizontalLocation >= 0 && location >= 0) ?
												 RUSlideNavigationController_MenuType_Left :
												 RUSlideNavigationController_MenuType_Right);
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		rect.origin.x = 0;
		rect.origin.y = (orientation == UIInterfaceOrientationLandscapeRight) ? location : location*-1;
	}
	else
	{
		rect.origin.x = (orientation == UIInterfaceOrientationPortrait) ? location : location*-1;
		rect.origin.y = 0;
	}
	
	self.view.frame = rect;
	[self updateMenuAnimation:menu];
}

- (void)updateMenuAnimation:(RUSlideNavigationController_MenuType)menu
{
	CGFloat progress = (menu == RUSlideNavigationController_MenuType_Left)
	? (self.horizontalLocation / (self.horizontalSize - self.slideOffset))
	: (self.horizontalLocation / ((self.horizontalSize - self.slideOffset) * -1));
	
	[self.menuAnimator animateMenu:menu withProgress:progress];
}

- (void)openMenu:(RUSlideNavigationController_MenuType)menu withDuration:(float)duration andCompletion:(void (^)())completion
{
	[self enableTapGestureToCloseMenu:YES];
	
	[self prepareMenuForReveal:menu forcePrepare:NO];
	
	[UIView animateWithDuration:duration
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 CGRect rect = self.view.frame;
						 CGFloat width = self.horizontalSize;
						 rect.origin.x = (menu == RUSlideNavigationController_MenuType_Left) ? (width - self.slideOffset) : ((width - self.slideOffset )* -1);
						 [self moveHorizontallyToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
					 }];
}

- (void)openMenu:(RUSlideNavigationController_MenuType)menu withCompletion:(void (^)())completion
{
	[self openMenu:menu withDuration:kRUSlideMenuNavigationController_MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
}

- (void)closeMenuWithCompletion:(void (^)())completion
{
	[self closeMenuWithDuration:kRUSlideMenuNavigationController_MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
}

- (void)closeMenuWithDuration:(float)duration andCompletion:(void (^)())completion
{
	[self enableTapGestureToCloseMenu:NO];
	
	[UIView animateWithDuration:duration
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 CGRect rect = self.view.frame;
						 rect.origin.x = 0;
						 [self moveHorizontallyToLocation:rect.origin.x];
					 }
					 completion:^(BOOL finished) {
						 if (completion)
							 completion();
					 }];
}

#pragma mark - Menu
- (void)bounceMenu:(RUSlideNavigationController_MenuType)menu withCompletion:(void (^)())completion
{
	[self prepareMenuForReveal:menu forcePrepare:YES];
	NSInteger movementDirection = (menu == RUSlideNavigationController_MenuType_Left) ? 1 : -1;
	
	[UIView animateWithDuration:.16 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self moveHorizontallyToLocation:30*movementDirection];
	} completion:^(BOOL finished){
		[UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			[self moveHorizontallyToLocation:0];
		} completion:^(BOOL finished){
			[UIView animateWithDuration:.12 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				[self moveHorizontallyToLocation:16*movementDirection];
			} completion:^(BOOL finished){
				[UIView animateWithDuration:.08 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
					[self moveHorizontallyToLocation:0];
				} completion:^(BOOL finished){
					[UIView animateWithDuration:.08 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
						[self moveHorizontallyToLocation:6*movementDirection];
					} completion:^(BOOL finished){
						[UIView animateWithDuration:.06 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
							[self moveHorizontallyToLocation:0];
						} completion:^(BOOL finished){
							if (completion)
								completion();
						}];
					}];
				}];
			}];
		}];
	}];
}

- (BOOL)isMenuOpen
{
	return (self.horizontalLocation == 0) ? NO : YES;
}

- (void)prepareMenuForReveal:(RUSlideNavigationController_MenuType)menu forcePrepare:(BOOL)forcePrepare
{
	UIView *removingMenuView = [self currentViewControllerMenuViewForMenuType:RUSlideNavigationController_MenuType_Opposite(menu)];

	UIViewController<RUSlideNavigationController_DisplayDelegate>* currentViewControllerForDisplayActions = self.currentViewControllerForDisplayActions;
	_currentViewControllerMenuView = ((currentViewControllerForDisplayActions &&
									   [currentViewControllerForDisplayActions respondsToSelector:@selector(ru_slideNavigationController_viewForMenuType:)]) ?
									  [currentViewControllerForDisplayActions ru_slideNavigationController_viewForMenuType:menu] :
									  nil);
	
	UIView *menuView = [self currentViewControllerMenuViewForMenuType:menu];

	kRUConditionalReturn(menuView == removingMenuView, NO);
//	UIView *menuView = (menu == RUSlideNavigationController_MenuType_Left) ? self.defaultLeftMenuView : self.defaultRightMenuView;
//	UIView *removingMenuView = (menu == RUSlideNavigationController_MenuType_Left) ? self.defaultRightMenuView : self.defaultLeftMenuView;
	
	// If menu is already open don't prepare, unless forcePrepare is set to true
	if ([self isMenuOpen] && !forcePrepare)
		return;
	
	[removingMenuView removeFromSuperview];
	[self.view.window insertSubview:menuView atIndex:0];
	
	[self updateMenuFrameAndTransformAccordingToOrientation];
	
	[self.menuAnimator prepareMenuForAnimation:menu];
}

- (BOOL)shouldDisplayMenu:(RUSlideNavigationController_MenuType)menu forViewController:(UIViewController *)vc
{
	if ((menu == RUSlideNavigationController_MenuType_Left ? self.defaultLeftMenuView : self.defaultRightMenuView) == nil)
		return NO;
	
	if ([vc conformsToProtocol:@protocol(RUSlideNavigationController_DisplayDelegate)] &&
		[vc respondsToSelector:@selector(ru_slideNavigationController_shouldDisplayMenuType:)])
	{
		return [(id<RUSlideNavigationController_DisplayDelegate>)vc ru_slideNavigationController_shouldDisplayMenuType:menu];
	}
	
	return YES;
}

- (void)toggleLeftMenu
{
	[self toggleMenu:RUSlideNavigationController_MenuType_Left withCompletion:nil];
}

- (void)toggleRightMenu
{
	[self toggleMenu:RUSlideNavigationController_MenuType_Right withCompletion:nil];
}

- (void)toggleMenu:(RUSlideNavigationController_MenuType)menu withCompletion:(void (^)())completion
{
	if ([self isMenuOpen])
		[self closeMenuWithCompletion:completion];
	else
		[self openMenu:menu withCompletion:completion];
}

#pragma mark - horizontalLocation
- (CGFloat)horizontalLocation
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = self.interfaceOrientation;

	
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		return (orientation == UIInterfaceOrientationLandscapeRight)
		? rect.origin.y
		: rect.origin.y*-1;
	}
	else
	{
		return (orientation == UIInterfaceOrientationPortrait)
		? rect.origin.x
		: rect.origin.x*-1;
	}
}

-(CGFloat)horizontalLocationWithMovement
{
	CGPoint translation = [self.panRecognizer translationInView:self.panRecognizer.view];
	CGFloat movement = translation.x - self.draggingPoint.x;

	return self.horizontalLocation + movement;
}

#pragma mark - Frames
-(RUSlideNavigationController_MenuType)menuTypeForHorizontalLocation:(CGFloat)horizontalLocation
{
//	return ((horizontalLocation > 0 || (horizontalLocation == 0 && movement > 0)) ?
	return ((horizontalLocation > 0) ?
			RUSlideNavigationController_MenuType_Left :
			RUSlideNavigationController_MenuType_Right);
}

- (CGRect)initialRectForMenu:(RUSlideNavigationController_MenuType)menu
{
	CGRect rect = self.view.frame;
	CGFloat slideOffset = self.slideOffset;
	rect.origin.x = 0;
	rect.origin.y = 0;
	
//	BOOL isIos7 = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
//	CGFloat statusBarHeight = kPASlideNavigationControllerSTATUS_BAR_HEIGHT;
	CGFloat statusBarHeight = (CGRectGetHeight([UIScreen mainScreen].bounds) + CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame)) - CGRectGetHeight(self.view.frame);
	
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
	{
		rect.origin.x = (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) ? 0 : statusBarHeight;
		rect.size.width = self.view.frame.size.width-statusBarHeight;
//		if (!isIos7)
//		{
//			// For some reasons in landscape belos the status bar is considered y=0, but in portrait it's considered y=20
//			rect.origin.x = (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) ? 0 : statusBarHeight;
//			rect.size.width = self.view.frame.size.width-statusBarHeight;
//		}
	}
	else
	{
		rect.origin.y = (self.interfaceOrientation == UIInterfaceOrientationPortrait) ? statusBarHeight : 0;
		rect.size.height = self.view.frame.size.height-statusBarHeight;
//		if (!isIos7)
//		{
//			// For some reasons in landscape belos the status bar is considered y=0, but in portrait it's considered y=20
//			rect.origin.y = (self.interfaceOrientation == UIInterfaceOrientationPortrait) ? statusBarHeight : 0;
//			rect.size.height = self.view.frame.size.height-statusBarHeight;
//		}
	}
	
	rect.size.width -= slideOffset;
	
	if (menu == RUSlideNavigationController_MenuType_Right)
	{
		rect.origin.x += slideOffset;
	}
	
	return rect;
}

- (CGFloat)horizontalSize
{
	CGRect rect = self.view.frame;
	UIInterfaceOrientation orientation = self.interfaceOrientation;
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		return rect.size.height;
	}
	else
	{
		return rect.size.width;
	}
}

- (CGFloat)minXForDragging
{
	if ([self shouldDisplayMenu:RUSlideNavigationController_MenuType_Right forViewController:self.currentViewControllerForDisplayActions])
	{
		return (self.horizontalSize - self.slideOffset)  * -1;
	}
	
	return 0;
}

- (CGFloat)maxXForDragging
{
	if ([self shouldDisplayMenu:RUSlideNavigationController_MenuType_Left forViewController:self.currentViewControllerForDisplayActions])
	{
		return self.horizontalSize - self.slideOffset;
	}
	
	return 0;
}

- (CGFloat)slideOffset
{
	return (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
	? self.landscapeSlideOffset
	: self.portraitSlideOffset;
}

#pragma mark - Getters
- (UITapGestureRecognizer *)tapRecognizer
{
	if (!_tapRecognizer)
	{
		_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
	}
	
	return _tapRecognizer;
}

- (UIPanGestureRecognizer *)panRecognizer
{
	if (!_panRecognizer)
	{
		_panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
	}
	
	return _panRecognizer;
}

#pragma mark - Setters
- (void)setEnableSwipeGesture:(BOOL)markEnableSwipeGesture
{
	_enableSwipeGesture = markEnableSwipeGesture;
	
	if (_enableSwipeGesture)
	{
		[self.view addGestureRecognizer:self.panRecognizer];
	}
	else
	{
		[self.view removeGestureRecognizer:self.panRecognizer];
	}
}

#pragma mark - Actions
- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
	[self closeMenuWithCompletion:nil];
}

- (void)panDetected:(UIPanGestureRecognizer *)aPanRecognizer
{
	CGPoint translation = [aPanRecognizer translationInView:aPanRecognizer.view];
	CGPoint velocity = [aPanRecognizer velocityInView:aPanRecognizer.view];
	CGFloat movement = translation.x - self.draggingPoint.x;
	CGFloat horizontalLocation = self.horizontalLocation;
	CGFloat newHorizontalLocation = horizontalLocation + movement;

	RUSlideNavigationController_MenuType menu = [self menuTypeForHorizontalLocation:newHorizontalLocation];
//	RUSlideNavigationController_MenuType menu = (self.horizontalLocation > 0 || (self.horizontalLocation == 0 && movement > 0) ) ? RUSlideNavigationController_MenuType_Left : RUSlideNavigationController_MenuType_Right;
	
	if (aPanRecognizer.state == UIGestureRecognizerStateBegan)
	{
		if (![self isMenuOpen])
			[self prepareMenuForReveal:menu forcePrepare:YES];
		
		self.draggingPoint = translation;
		[self setLastMenu:menu];
	}
	else if (aPanRecognizer.state == UIGestureRecognizerStateChanged)
	{
//		static CGFloat lastHorizontalLocation = 0;
//		CGFloat newHorizontalLocation = [self horizontalLocation];
//
		// Force prepare menu when slides quickly between left and right menu
		if (self.lastMenu != menu)
			[self prepareMenuForReveal:menu forcePrepare:YES];
		
		if (newHorizontalLocation >= self.minXForDragging && newHorizontalLocation <= self.maxXForDragging)
			[self moveHorizontallyToLocation:newHorizontalLocation];
		
		self.draggingPoint = translation;
		[self setLastMenu:menu];
	}
	else if (aPanRecognizer.state == UIGestureRecognizerStateEnded)
	{
		NSInteger currentX = [self horizontalLocation];
		NSInteger currentXOffset = (currentX > 0) ? currentX : currentX * -1;
		NSInteger positiveVelocity = (velocity.x > 0) ? velocity.x : velocity.x * -1;
		
		// If the speed is high enough follow direction
		if (positiveVelocity >= kRUSlideMenuNavigationController_MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION)
		{
			RUSlideNavigationController_MenuType menu = (velocity.x > 0) ? RUSlideNavigationController_MenuType_Left : RUSlideNavigationController_MenuType_Right;
			
			// Moving Right
			if (velocity.x > 0)
			{
				if (currentX > 0)
				{
					if ([self shouldDisplayMenu:menu forViewController:self.visibleViewController])
						[self openMenu:(velocity.x > 0) ? RUSlideNavigationController_MenuType_Left : RUSlideNavigationController_MenuType_Right withDuration:kRUSlideMenuNavigationController_MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
				else
				{
					[self closeMenuWithDuration:kRUSlideMenuNavigationController_MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
			}
			// Moving Left
			else
			{
				if (currentX > 0)
				{
					[self closeMenuWithDuration:kRUSlideMenuNavigationController_MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
				else
				{
					if ([self shouldDisplayMenu:menu forViewController:self.visibleViewController])
						[self openMenu:(velocity.x > 0) ? RUSlideNavigationController_MenuType_Left : RUSlideNavigationController_MenuType_Right withDuration:kRUSlideMenuNavigationController_MENU_QUICK_SLIDE_ANIMATION_DURATION andCompletion:nil];
				}
			}
		}
		else
		{
			if (currentXOffset < (self.horizontalSize - self.slideOffset)/2)
				[self closeMenuWithCompletion:nil];
			else
				[self openMenu:(currentX > 0) ? RUSlideNavigationController_MenuType_Left : RUSlideNavigationController_MenuType_Right withCompletion:nil];
		}
		
		[self setLastMenu:-1];
	}
}

#pragma mark - Enabling
- (void)enableTapGestureToCloseMenu:(BOOL)enable
{
	if (enable)
	{
		self.topViewController.view.userInteractionEnabled = NO;
		[self.view addGestureRecognizer:self.tapRecognizer];
	}
	else
	{
		self.topViewController.view.userInteractionEnabled = YES;
		[self.view removeGestureRecognizer:self.tapRecognizer];
	}
}

#pragma mark - currentViewControllerForDisplayActions
-(UIViewController<RUSlideNavigationController_DisplayDelegate> *)currentViewControllerForDisplayActions
{
	UIViewController<RUSlideNavigationController_DisplayDelegate>* currentViewControllerForDisplayActions = (UIViewController<RUSlideNavigationController_DisplayDelegate>*)kRUProtocolOrNil(self.topViewController, RUSlideNavigationController_DisplayDelegate);
	return currentViewControllerForDisplayActions;
}

#pragma mark - currentViewControllerMenuView
-(UIView *)currentViewControllerMenuViewForMenuType:(RUSlideNavigationController_MenuType)menuType
{
	if (self.currentViewControllerMenuView)
	{
		return self.currentViewControllerMenuView;
	}

	return [self defaultMenuViewForMenuType:menuType];
}

#pragma mark - defaultMenuView
-(UIView *)defaultMenuViewForMenuType:(RUSlideNavigationController_MenuType)menuType
{
	switch (menuType)
	{
		case RUSlideNavigationController_MenuType_Left:
			return self.defaultLeftMenuView;
			
		case RUSlideNavigationController_MenuType_Right:
			return self.defaultRightMenuView;
	}
	
	NSAssert(false, @"unhandled");
	return nil;
}

@end
