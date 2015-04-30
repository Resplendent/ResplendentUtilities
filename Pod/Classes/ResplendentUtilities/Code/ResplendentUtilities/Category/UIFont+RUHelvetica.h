//
//  UIFont+RUHelvetica.h
//  Shimmur
//
//  Created by Benjamin Maer on 4/6/15.
//  Copyright (c) 2015 ShimmurInc. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, RU_UIFont_Helvetica_type) {
	RU_UIFont_Helvetica_type_regular,
	RU_UIFont_Helvetica_type_bold,
	RU_UIFont_Helvetica_type_boldOblique,
	RU_UIFont_Helvetica_type_light,
	RU_UIFont_Helvetica_type_lightOblique,
	RU_UIFont_Helvetica_type_oblique,
	
#if DEBUG
	RU_UIFont_Helvetica_type_first	= RU_UIFont_Helvetica_type_regular,
	RU_UIFont_Helvetica_type_last	= RU_UIFont_Helvetica_type_oblique,
#endif
};





@interface UIFont (RUHelvetica)

+(instancetype)ru_helveticaFontWithType:(RU_UIFont_Helvetica_type)type size:(CGFloat)size;
+(NSString*)ru_helveticaFontNameForType:(RU_UIFont_Helvetica_type)type;
+(NSString*)ru_helveticaFontNameComponentsForType:(RU_UIFont_Helvetica_type)type;

#if DEBUG
+(void)ru_validateAllHelveticaFonts;
#endif

@end
