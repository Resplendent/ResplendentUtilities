//
//  UIViewController+RUDismissOrPop.m
//  Shimmur
//
//  Created by Benjamin Maer on 12/16/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "UIViewController+RUDismissOrPop.h"





@implementation UIViewController (RUDismissOrPop)

-(void)ru_dismissOrPop
{
	if (self.navigationController.presentingViewController)
	{
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	else
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end
