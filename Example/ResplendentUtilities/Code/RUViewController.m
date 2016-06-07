//
//  RUViewController.m
//  ResplendentUtilities
//
//  Created by Benjamin Maer on 06/07/2016.
//  Copyright (c) 2016 Benjamin Maer. All rights reserved.
//

#import "RUViewController.h"
#import "RUUnitTestManager.h"





@interface RUViewController ()

@end





@implementation RUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.view setBackgroundColor:[UIColor redColor]];

	[RUUnitTestManager runUnitTests];

	[self.view setBackgroundColor:[UIColor greenColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
