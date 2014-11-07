//
//  RUAttributesDictionaryBuilder.m
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import "RUAttributesDictionaryBuilder.h"
#import "NSMutableDictionary+RUUtil.h"

#import <CoreText/CoreText.h>





@implementation RUAttributesDictionaryBuilder

#pragma mark - Absorb
-(void)absorbPropertiesFromLabel:(UILabel*)label
{
	[self setFont:label.font];
	[self setTextColor:label.textColor];
	[self setLineBreakMode:label.lineBreakMode];
}

-(void)absorbPropertiesFromButton:(UIButton*)button
{
	[self absorbPropertiesFromLabel:button.titleLabel];
}

-(void)absorbPropertiesFromTextField:(UITextField*)textField
{
	[self setFont:textField.font];
	[self setTextColor:textField.textColor];
}

#pragma mark - Create Attributes Dictionary
-(NSDictionary*)createAttributesDictionary
{
	NSMutableDictionary* attributesDictionary = [NSMutableDictionary dictionary];

	[attributesDictionary setObjectOrRemoveIfNil:self.font forKey:NSFontAttributeName];

	if (&kCTForegroundColorAttributeName)
	{
		[attributesDictionary setObjectOrRemoveIfNil:self.textColor forKey:(NSString *)kCTForegroundColorAttributeName];
	}
	else
	{
		[attributesDictionary setObjectOrRemoveIfNil:self.textColor forKey:NSForegroundColorAttributeName];
	}

	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[style setLineBreakMode:self.lineBreakMode];
	[style setAlignment:self.textAlignment];

	if (self.lineSpacing)
	{
		[style setLineSpacing:self.lineSpacing.floatValue];
	}

	[attributesDictionary setObjectOrRemoveIfNil:style forKey:NSParagraphStyleAttributeName];
	
	return [attributesDictionary copy];
}

/*
 NSInteger strLength = [myString length];
 NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
 [style setLineSpacing:24];
 [attString addAttribute:NSParagraphStyleAttributeName
 value:style
 range:NSMakeRange(0, strLength)];
 */
@end
