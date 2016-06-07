//
//  UIImage+RUImageColorMasking.m
//  Shimmur
//
//  Created by Benjamin Maer on 7/31/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "UIImage+RUImageColorMasking.h"





@implementation UIImage (RUImageColorMasking)

-(UIImage*)ruImageByApplyingMaskWithColor:(UIColor*)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);

	// get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // set the fill color
    [color setFill];
	
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
	
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
	CGRect rect = (CGRect){
		.size = self.size
	};

//    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, self.CGImage);
	
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
	
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    //return the color-burned image
    return coloredImg;
}

@end
