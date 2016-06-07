//
//  UIFont+RUHelvetica.m
//  Shimmur
//
//  Created by Benjamin Maer on 4/6/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import "UIFont+RUHelvetica.h"
#import "RUConstants.h"
#import "RUConditionalReturn.h"





@implementation UIFont (RUHelvetica)

#if DEBUG
#pragma mark - NSObject
__attribute__((constructor)) static void ru_UIFont_RUHelvetica_initializeSomethingMore(void)
{
	[UIFont ru_validateAllHelveticaFonts];
}
#endif

#pragma mark - RUHelvetica
+(instancetype)ru_helveticaFontWithType:(RU_UIFont_Helvetica_type)type size:(CGFloat)size
{
	NSString* fontName = [self ru_helveticaFontNameForType:type];
	kRUConditionalReturn_ReturnValueNil(fontName.length == 0, YES);

	UIFont* font = [UIFont fontWithName:fontName size:size];
	kRUConditionalReturn_ReturnValueNil([font.fontName isEqualToString:fontName] == false, YES);

	return font;
}

#pragma mark - Naming
+(NSString*)ru_helveticaFontNameForType:(RU_UIFont_Helvetica_type)type
{
	NSString* const prefix = @"Helvetica";
	NSString* components = [self ru_helveticaFontNameComponentsForType:type];
	if (components.length)
	{
		return RUStringWithFormat(@"%@-%@",prefix,components);
	}
	else
	{
		return prefix;
	}
}

+(NSString *)ru_helveticaFontNameComponentsForType:(RU_UIFont_Helvetica_type)type
{
	switch (type)
	{
		case RU_UIFont_Helvetica_type_regular:
			return nil;
		case RU_UIFont_Helvetica_type_bold:
			return @"Bold";
		case RU_UIFont_Helvetica_type_boldOblique:
			return @"BoldOblique";
		case RU_UIFont_Helvetica_type_light:
			return @"Light";
		case RU_UIFont_Helvetica_type_lightOblique:
			return @"LightOblique";
		case RU_UIFont_Helvetica_type_oblique:
			return @"Oblique";
	}
}

#if DEBUG
#pragma mark - Validation
+(void)ru_validateAllHelveticaFonts
{
	for (RU_UIFont_Helvetica_type fontType = RU_UIFont_Helvetica_type_first;
		 fontType <= RU_UIFont_Helvetica_type_last;
		 fontType++)
	{
		NSAssert(([self ru_helveticaFontWithType:fontType size:10] != nil), @"unhandled");
	}
}
#endif

@end
