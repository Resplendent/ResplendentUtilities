//
//  RUAttributesDictionaryBuilder.m
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import "RUAttributesDictionaryBuilder.h"
#import "NSMutableDictionary+RUUtil.h"





@implementation RUAttributesDictionaryBuilder

#pragma mark - Absorb
-(void)absorbPropertiesFromLabel:(UILabel*)label
{
	[self setFont:label.font];
	[self setLineBreakMode:label.lineBreakMode];
}

-(NSDictionary*)createAttributesDictionary
{
	NSMutableDictionary* attributesDictionary = [NSMutableDictionary dictionary];

	[attributesDictionary setObjectOrRemoveIfNil:self.font forKey:NSFontAttributeName];

	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[style setLineBreakMode:self.lineBreakMode];

	[attributesDictionary setObjectOrRemoveIfNil:style forKey:NSParagraphStyleAttributeName];
	
//	NSDictionary *attributes = @{NSFontAttributeName: font,		: style};

	return [attributesDictionary copy];
}

@end
