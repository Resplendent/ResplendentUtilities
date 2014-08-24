//
//  RUImageCompatability.h
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/21/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUCompatability.h"





//Synthesize Getter
#define RUUIImageCompatible_Synthesize_Image_Getter_Implementation(varName,imageName) \
+(UIImage*)varName \
{ \
	return [UIImage imageNamed:imageName]; \
}

//++++
//460 and 480
#define RUUIImageScreenSizeCompatibleSynthesize460or480BasedOnIOS7ReturnStatement(varName) ([RUCompatability isIOS7] ? [self varName##480h] : [self varName])

#define RUUIImageScreenSizeCompatibleSynthesize460and480Declarations(varName) \
RUStaticVariableSynthesizationGetterImageDeclaration(varName); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##480h);

#define RUUIImageScreenSizeCompatibleSynthesize460and480Implementations(varName,imageName) \
RUUIImageCompatible_Synthesize_Image_Getter_Implementation(varName, imageName); \
RUUIImageCompatible_Synthesize_Image_Getter_Implementation(varName##480h, imageName@"-480h");
//----





//++++
//460 and 568
#define RUUIImageScreenSizeCompatibleSynthesize460and568Declarations(varName) \
RUStaticVariableSynthesizationGetterImageDeclaration(varName); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##568h);

#define RUUIImageScreenSizeCompatibleSynthesize480and568Implementations(varName,imageName) \
RUUIImageCompatible_Synthesize_Image_Getter_Implementation(varName, imageName); \
RUUIImageCompatible_Synthesize_Image_Getter_Implementation(varName##568h, imageName@"-568h");
//----





//++++
//460, 480, and 568
#define RUUIImageScreenSizeCompatibleSynthesize460and480and568Declarations(varName) \
RUStaticVariableSynthesizationGetterImageDeclaration(varName); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##480h); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##568h);

#define RUUIImageScreenSizeCompatibleSynthesize460and480and568Implementations(varName,imageName) \
RUUIImageCompatible_Synthesize_Image_Getter_Implementation(varName, imageName); \
RUUIImageCompatible_Synthesize_Image_Getter_Implementation(varName##480h, imageName@"-480h"); \
RUUIImageCompatible_Synthesize_Image_Getter_Implementation(varName##568h, imageName@"-568h");
//----




//Getters
#define RUUIImageScreenSizeCompatibleSynthesize480IfIOS7Else460(varName) ([RUCompatability isIOS7] ? [self varName##480h] : [self varName])
#define RUUIImageScreenSizeCompatibleSynthesize568If4Inch480IfIOS7Else460(varName) ([RUCompatability screenSizeIs4inch] ? [self varName##568h] : RUUIImageScreenSizeCompatibleSynthesize480IfIOS7Else460(varName))
#define RUUIImageScreenSizeCompatibleSynthesize480or568BasedOnScreenSizeReturnStatement(varName) ([RUCompatability screenSizeIs4inch] ? [self varName##568h] : [self varName])
#define RUUIImageScreenSizeCompatibleSynthesize480or568BasedOnIOS7ReturnStatement(varName) ([RUCompatability isIOS7] ? [self varName##568h] : [self varName])

//Testing
#define RUImageCompatability_Test_568If4Inch480IfIOS7Else460(varName) \
UIImage* image = [self varName]; \
RUDLog(@"image: %@",image); \
UIImage* image480 = [self varName##480h]; \
RUDLog(@"image480: %@",image480); \
UIImage* image568 = [self varName##568h]; \
RUDLog(@"image568: %@",image568); \
UIImage* properImage = RUUIImageScreenSizeCompatibleSynthesize568If4Inch480IfIOS7Else460(varName); \
RUDLog(@"properImage: %@",properImage);






@interface RUImageCompatability : NSObject

@end
