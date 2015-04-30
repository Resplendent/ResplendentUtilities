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





@implementation UIFont (RUHelveticaNeue)

#if DEBUG
#pragma mark - NSObject
__attribute__((constructor)) static void ru_UIFont_RUHelveticaNeue_initializeSomethingMore(void)
{
	[UIFont ru_validateAllHelveticaNeueFonts];
}
#endif

#pragma mark - RUHelvetica
+(instancetype)ru_helveticaNeueFontWithType:(RU_UIFont_HelveticaNeue_type)type size:(CGFloat)size
{
	NSString* fontName = [self ru_helveticaNeueFontNameForType:type];
	kRUConditionalReturn_ReturnValueNil(fontName.length == 0, YES);
	
	UIFont* font = [UIFont fontWithName:fontName size:size];
	kRUConditionalReturn_ReturnValueNil([font.fontName isEqualToString:fontName] == false, YES);
	
	return font;
}

#pragma mark - Naming
+(NSString*)ru_helveticaNeueFontNameForType:(RU_UIFont_HelveticaNeue_type)type
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

+(NSString *)ru_helveticaNeueFontNameComponentsForType:(RU_UIFont_HelveticaNeue_type)type
{
	switch (type)
	{
		case RU_UIFont_HelveticaNeue_type_regular:
			return nil;
		case RU_UIFont_HelveticaNeue_type_bold:
			return @"Bold";
		case RU_UIFont_HelveticaNeue_type_boldItalic:
			return @"BoldItalic";
		case RU_UIFont_HelveticaNeue_type_condensedBlack:
			return @"CondensedBlack";
		case RU_UIFont_HelveticaNeue_type_condensedBold:
			return @"CondensedBold";
		case RU_UIFont_HelveticaNeue_type_italic:
			return @"Italic";
		case RU_UIFont_HelveticaNeue_type_light:
			return @"Light";
		case RU_UIFont_HelveticaNeue_type_lightItalic:
			return @"LightItalic";
		case RU_UIFont_HelveticaNeue_type_medium:
			return @"Medium";
		case RU_UIFont_HelveticaNeue_type_mediumItalic:
			return @"MediumItalic";
		case RU_UIFont_HelveticaNeue_type_ultraLight:
			return @"UltraLight";
		case RU_UIFont_HelveticaNeue_type_ultraLightItalic:
			return @"UltraLightItalic";
		case RU_UIFont_HelveticaNeue_type_thin:
			return @"Thin";
		case RU_UIFont_HelveticaNeue_type_thinItalic:
			return @"ThinItalic";
	}
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
