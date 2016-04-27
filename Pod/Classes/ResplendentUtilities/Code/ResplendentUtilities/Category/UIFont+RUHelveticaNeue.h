//
//  UIFont+RUHelveticaNeue.h
//  Shimmur
//
//  Created by Benjamin Maer on 4/6/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, RU_UIFont_HelveticaNeue_type) {
	RU_UIFont_HelveticaNeue_type_regular,
	RU_UIFont_HelveticaNeue_type_bold,
	RU_UIFont_HelveticaNeue_type_boldItalic,
	RU_UIFont_HelveticaNeue_type_condensedBlack,
	RU_UIFont_HelveticaNeue_type_condensedBold,
	RU_UIFont_HelveticaNeue_type_italic,
	RU_UIFont_HelveticaNeue_type_light,
	RU_UIFont_HelveticaNeue_type_lightItalic,
	RU_UIFont_HelveticaNeue_type_medium,
	RU_UIFont_HelveticaNeue_type_mediumItalic,
	RU_UIFont_HelveticaNeue_type_ultraLight,
	RU_UIFont_HelveticaNeue_type_ultraLightItalic,
	RU_UIFont_HelveticaNeue_type_thin,
	RU_UIFont_HelveticaNeue_type_thinItalic,
	
#if DEBUG
	RU_UIFont_HelveticaNeue_type_first	= RU_UIFont_HelveticaNeue_type_regular,
	RU_UIFont_HelveticaNeue_type_last	= RU_UIFont_HelveticaNeue_type_thinItalic,
#endif
};





@interface UIFont (RUHelveticaNeue)

+(nullable instancetype)ru_helveticaNeueFontWithType:(RU_UIFont_HelveticaNeue_type)type size:(CGFloat)size;
+(nullable NSString*)ru_helveticaNeueFontNameForType:(RU_UIFont_HelveticaNeue_type)type;
+(nullable NSString*)ru_helveticaNeueFontNameComponentsForType:(RU_UIFont_HelveticaNeue_type)type;

#if DEBUG
+(void)ru_validateAllHelveticaNeueFonts;
#endif

@end
