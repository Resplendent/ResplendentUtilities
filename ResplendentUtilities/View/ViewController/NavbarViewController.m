//
//  NavbarViewController.m
//  Everycam
//
//  Created by Benjamin Maer on 10/2/12.
//  Copyright (c) 2012 Resplendent G.P. All rights reserved.
//

#import "NavbarViewController.h"
#import "Navbar.h"

@implementation NavbarViewController

@synthesize navbar;

-(void)loadNavBar
{
    [NSException raise:NSInternalInconsistencyException format:@"method %@ for class %@ must be overloaded", NSStringFromSelector(_cmd),NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadNavBar];
    [self.view addSubview:self.navbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [self.navbar removeFromSuperview];
    [self setNavbar:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(CGRect)contentFrame
{
    return CGRectMake(0, CGRectGetMaxY(self.navbar.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.navbar.frame));
}

@end
