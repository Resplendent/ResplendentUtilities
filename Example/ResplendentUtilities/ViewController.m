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

@end





@implementation ViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor redColor]];
	
	[RUUnitTestManager runUnitTests];
	
	[self.view setBackgroundColor:[UIColor greenColor]];
}

@end
