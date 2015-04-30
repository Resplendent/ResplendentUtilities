//
//  RUCrossView.m
//  Resplendent
//
//  Created by Benjamin Maer on 5/8/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "RUCrossView.h"





@implementation RUCrossView

#pragma mark - UIView
-(void)drawRect:(CGRect)rect
{
	CGFloat width = CGRectGetWidth(self.bounds);
	CGFloat height = CGRectGetWidth(self.bounds);
	CGPoint center = (CGPoint){
		.x = width / 2.0f,
		.y = height / 2.0f,
	};
	CGFloat crossThickness = self.crossThickness;
	CGFloat crossThicknessHalved = crossThickness / 2.0f;;

    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextBeginPath(context);
	
	CGContextMoveToPoint   (context, center.x - crossThicknessHalved, 0);  // top top left
	CGContextAddLineToPoint(context, center.x + crossThicknessHalved, 0);  // top top right
	CGContextAddLineToPoint(context, center.x + crossThicknessHalved, center.y - crossThicknessHalved);  // middle top right
	CGContextAddLineToPoint(context, width, center.x - crossThicknessHalved);  // right top right
	CGContextAddLineToPoint(context, width, center.x + crossThicknessHalved);  // right bottom right
	CGContextAddLineToPoint(context, center.x + crossThicknessHalved, center.y + crossThicknessHalved);  // middle bottom right
	CGContextAddLineToPoint(context, center.x + crossThicknessHalved, height);  // bottom right
	CGContextAddLineToPoint(context, center.x - crossThicknessHalved, height);  // bottom left
	CGContextAddLineToPoint(context, center.x - crossThicknessHalved, center.y + crossThicknessHalved);  // middle bottom left
	CGContextAddLineToPoint(context, 0, center.y + crossThicknessHalved);  // left bottom
	CGContextAddLineToPoint(context, 0, center.y - crossThicknessHalved);  // left top
	CGContextAddLineToPoint(context, center.x - crossThicknessHalved, center.y - crossThicknessHalved);  // middle left top
	
    CGContextClosePath(context);
	
    if (self.fillCross)
    {
        CGContextSetFillColorWithColor(context, self.crossColor.CGColor);
        CGContextFillPath(context);
    }
    else
    {
        CGContextSetStrokeColorWithColor(context, self.crossColor.CGColor);
        CGContextStrokePath(context);
    }
}

#pragma mark - Setters
-(void)setCrossThickness:(CGFloat)crossThickness
{
	if (self.crossThickness == crossThickness)
	{
		return;
	}
	
	_crossThickness = crossThickness;
	
	[self setNeedsDisplay];
}

-(void)setCrossColor:(UIColor *)crossColor
{
	if (self.crossColor == crossColor)
	{
		return;
	}
	
	_crossColor = crossColor;
	
	[self setNeedsDisplay];
}

-(void)setFillCross:(BOOL)fillCross
{
	if (self.fillCross == fillCross)
	{
		return;
	}
	
	_fillCross = fillCross;
	
	[self setNeedsDisplay];
}

@end
