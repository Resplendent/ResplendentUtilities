//
//  RUColoredNavigationBar.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUColoredNavigationBar.h"





@implementation RUColoredNavigationBar

#pragma mark - UIView
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	if (self.navigationBarDrawColor)
	{
		[super drawRect:rect];
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetFillColorWithColor(context, self.navigationBarDrawColor.CGColor);
		CGContextFillRect(context, rect);
	}
}

#pragma mark - Setters
-(void)setNavigationBarDrawColor:(UIColor *)navigationBarDrawColor
{
	kRUConditionalReturn(self.navigationBarDrawColor == navigationBarDrawColor, NO);
	
	_navigationBarDrawColor = navigationBarDrawColor;

	[self setNeedsDisplay];
}

@end
