//
//  RUMainViewController.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 6/7/16.
//  Copyright © 2016 Resplendent. All rights reserved.
//

#import "RUMainViewController.h"
#import "RUUnitTestManager.h"
#import "RUGradientViewController.h"

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>





typedef NS_ENUM(NSInteger, RUMainViewController__tableSection) {
	RUMainViewController__tableSection_gradientView,
	
	RUMainViewController__tableSection__first	= RUMainViewController__tableSection_gradientView,
	RUMainViewController__tableSection__last	= RUMainViewController__tableSection_gradientView,
};

@interface RUMainViewController () <UITableViewDataSource, UITableViewDelegate>

#pragma mark - tableSectionManager
@property (nonatomic, readonly, strong, nullable) RTSMTableSectionManager* tableSectionManager;

#pragma mark - tableView
@property (nonatomic, strong, nullable) IBOutlet UITableView* tableView;

#pragma mark - tableViewCell
-(nullable NSString*)tableViewCell_text_for_tableSection:(RUMainViewController__tableSection)tableSection;

#pragma mark - unitTest
-(void)unitTest_begin;
-(void)unitTest_perform;

@end





@implementation RUMainViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];

	_tableSectionManager = [[RTSMTableSectionManager alloc] initWithFirstSection:RUMainViewController__tableSection__first
																	 lastSection:RUMainViewController__tableSection__last];

	[self unitTest_begin];
}

#pragma mark - tableViewCell
-(nullable NSString*)tableViewCell_text_for_tableSection:(RUMainViewController__tableSection)tableSection
{
	switch (tableSection)
	{
		case RUMainViewController__tableSection_gradientView:
			return @"Gradient View";
			break;
	}

	NSAssert(false, @"unhandled tableSection %li",(long)tableSection);
	return nil;
}

#pragma mark - unitTest
-(void)unitTest_begin
{
	[self.view setBackgroundColor:[UIColor redColor]];

	__weak typeof(self) const self_weak = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		[self_weak unitTest_perform];
	});
}

-(void)unitTest_perform
{
	[RUUnitTestManager runUnitTests];
	
	[self.view setBackgroundColor:[UIColor greenColor]];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.tableSectionManager numberOfSectionsAvailable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* const dequeIdentifier = NSStringFromClass([UITableViewCell class]);
	UITableViewCell* const tableViewCell =
	([tableView dequeueReusableCellWithIdentifier:dequeIdentifier]
	 ?:
	 [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeIdentifier]
	);

	RUMainViewController__tableSection const tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	[tableViewCell.textLabel setText:[self tableViewCell_text_for_tableSection:tableSection]];

	return tableViewCell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RUMainViewController__tableSection const tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	switch (tableSection)
	{
		case RUMainViewController__tableSection_gradientView:
			[self gradientViewController_push];
			break;
	}
}

#pragma mark - gradientViewController
-(void)gradientViewController_push
{
	Class const RUGradientViewControllerClass = [RUGradientViewController class];
	RUGradientViewController* const gradientViewController =
	[[RUGradientViewControllerClass alloc] initWithNibName:NSStringFromClass(RUGradientViewControllerClass) bundle:nil];
//	[RUGradientViewController new];
	[self.navigationController pushViewController:gradientViewController animated:YES];
}

@end
