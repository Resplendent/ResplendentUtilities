//
//  UIFont+RUHelveticaNeue.m
//  Shimmur
//
//  Created by Benjamin Maer on 4/6/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import "UIFont+RUHelveticaNeue.h"
#import "RUConditionalReturn.h"
#import "RUConstants.h"
#import "RUSystemVersionUtils.h"

#import <CoreText/CoreText.h>





@implementation UIFont (RUHelveticaNeue)

#if DEBUG
#pragma mark - NSObject
__attribute__((constructor)) static void ru_UIFont_RUHelveticaNeue_initializeSomethingMore(void)
{
	[UIFont ru_validateAllHelveticaNeueFonts];
}
#endif

#pragma mark - RUHelvetica
+(nullable instancetype)ru_helveticaNeueFontWithType:(RU_UIFont_HelveticaNeue_type)type size:(CGFloat)size
{
	NSString* fontName = [self ru_helveticaNeueFontNameForType:type];
	kRUConditionalReturn_ReturnValueNil(fontName.length == 0, YES);
	
	UIFont* font = [UIFont fontWithName:fontName size:size];

	/**
	 To deal with an Apple bug, where they accidentally removed Helvetia Neue Italic for iOS version v, where 7.1 > v >= 7.0.3
	 http://stackoverflow.com/questions/19527962/what-happened-to-helveticaneue-italic-on-ios-7-0-3
	 */
	if (
		(type == RU_UIFont_HelveticaNeue_type_italic) &&
		SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.3") &&
		SYSTEM_VERSION_LESS_THAN(@"7.1"))
	{
		if (
			(font == nil) &&
			([UIFontDescriptor class] != nil)
			)
		{
			font = (__bridge_transfer UIFont*)CTFontCreateWithName(CFSTR("HelveticaNeue-Italic"), size, NULL);
		}
	}
	
	NSAssert(font != nil, @"couldn't create font of type %li and size %f",type,size);

	kRUConditionalReturn_ReturnValueNil([font.fontName isEqualToString:fontName] == false, YES);
	
	return font;
}

#pragma mark - Naming
+(nullable NSString*)ru_helveticaNeueFontNameForType:(RU_UIFont_HelveticaNeue_type)type
{
	NSString* const prefix = @"HelveticaNeue";
	NSString* components = [self ru_helveticaNeueFontNameComponentsForType:type];
	if (components.length)
	{
		return RUStringWithFormat(@"%@-%@",prefix,components);
	}
	else
	{
		return prefix;
	}
}

+(nullable NSString*)ru_helveticaNeueFontNameComponentsForType:(RU_UIFont_HelveticaNeue_type)type
{
	switch (type)
	{
		case RU_UIFont_HelveticaNeue_type_regular:
			return nil;
			break;

		case RU_UIFont_HelveticaNeue_type_bold:
			return @"Bold";
			break;
			
		case RU_UIFont_HelveticaNeue_type_boldItalic:
			return @"BoldItalic";
			break;
			
		case RU_UIFont_HelveticaNeue_type_condensedBlack:
			return @"CondensedBlack";
			break;
			
		case RU_UIFont_HelveticaNeue_type_condensedBold:
			return @"CondensedBold";
			break;
			
		case RU_UIFont_HelveticaNeue_type_italic:
			return @"Italic";
			break;
			
		case RU_UIFont_HelveticaNeue_type_light:
			return @"Light";
			break;
			
		case RU_UIFont_HelveticaNeue_type_lightItalic:
			return @"LightItalic";
			break;
			
		case RU_UIFont_HelveticaNeue_type_medium:
			return @"Medium";
			break;
			
		case RU_UIFont_HelveticaNeue_type_mediumItalic:
			return @"MediumItalic";
			break;
			
		case RU_UIFont_HelveticaNeue_type_ultraLight:
			return @"UltraLight";
			break;
			
		case RU_UIFont_HelveticaNeue_type_ultraLightItalic:
			return @"UltraLightItalic";
			break;
			
		case RU_UIFont_HelveticaNeue_type_thin:
			return @"Thin";
			break;
			
		case RU_UIFont_HelveticaNeue_type_thinItalic:
			return @"ThinItalic";
			break;
	}

	NSAssert(false, @"unhandled type %li",type);
	return nil;
}

#if DEBUG
#pragma mark - Validation
+(void)ru_validateAllHelveticaNeueFonts
{
	for (RU_UIFont_HelveticaNeue_type fontType = RU_UIFont_HelveticaNeue_type_first;
		 fontType <= RU_UIFont_HelveticaNeue_type_last;
		 fontType++)
	{
		NSAssert(([self ru_helveticaNeueFontWithType:fontType size:10] != nil), @"unhandled");
	}
}
#endif

@end
