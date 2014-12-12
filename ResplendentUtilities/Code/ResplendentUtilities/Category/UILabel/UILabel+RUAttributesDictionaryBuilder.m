//
//  UILabel+RUAttributesDictionaryBuilder.m
//  Nifti
//
//  Created by Benjamin Maer on 12/12/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "UILabel+RUAttributesDictionaryBuilder.h"
#import "RUAttributesDictionaryBuilder.h"





@implementation UILabel (RUAttributesDictionaryBuilder)

-(void)ru_absorbPropertiesFromAttributesDictionaryBuilder:(RUAttributesDictionaryBuilder*)attributesDictionaryBuilder
{
	[self setFont:attributesDictionaryBuilder.font];
	[self setTextColor:attributesDictionaryBuilder.textColor];
	[self setLineBreakMode:attributesDictionaryBuilder.lineBreakMode];
	[self setTextAlignment:attributesDictionaryBuilder.textAlignment];
}

@end
