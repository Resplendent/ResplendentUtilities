//
//  UITextField+RUAttributes.m
//  Resplendent
//
//  Created by Benjamin Maer on 5/31/14.
//  Copyright (c) 2014 Resplendent. All rights reserved.
//

#import "UITextField+RUAttributes.h"





@implementation UITextField (RUAttributes)

-(NSParagraphStyle*)ruParagraphStyle
{
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[style setAlignment:self.textAlignment];
	[style setLineBreakMode:NSLineBreakByWordWrapping];
	
	return [style copy];
}

-(NSDictionary*)ruAttributes
{
	return @{
			 NSFontAttributeName: self.font,
			 NSForegroundColorAttributeName: self.textColor,
			 NSParagraphStyleAttributeName: self.ruParagraphStyle
			 };
}

@end
