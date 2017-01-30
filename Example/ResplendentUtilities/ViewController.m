//
//  ViewController.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 6/7/16.
//  Copyright © 2016 Resplendent. All rights reserved.
//

#import "ViewController.h"

#import "RUUnitTestManager.h"





@interface ViewController ()

#pragma mark - unitTest
-(void)unitTest_begin;
-(void)unitTest_perform;

@end





@implementation ViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];

	[self unitTest_begin];
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

@end
