//
//  RUImageCompatability.h
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/21/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUCompatability.h"






//++++
//460 and 480
#define RUUIImageScreenSizeCompatibleSynthesize460or480BasedOnIOS7ReturnStatement(varName) ([RUCompatability isIOS7] ? [self varName##h480] : [self varName])

#define RUUIImageScreenSizeCompatibleSynthesize460and480Declarations(varName) \
RUStaticVariableSynthesizationGetterImageDeclaration(varName); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##h480);

#define RUUIImageScreenSizeCompatibleSynthesize460and480Implementations(varName,imageName) \
RUStaticVariableSynthesizationWithGetterImage(varName, imageName); \
RUStaticVariableSynthesizationWithGetterImage(varName##h480, imageName@"-480h");
//----





//++++
//460 and 568
#define RUUIImageScreenSizeCompatibleSynthesize460and568Declarations(varName) \
RUStaticVariableSynthesizationGetterImageDeclaration(varName); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##h568);

#define RUUIImageScreenSizeCompatibleSynthesize480and568Implementations(varName,imageName) \
RUStaticVariableSynthesizationWithGetterImage(varName, imageName); \
RUStaticVariableSynthesizationWithGetterImage(varName##h568, imageName@"-568h");
//----





//++++
//460, 480, and 568
#define RUUIImageScreenSizeCompatibleSynthesize460and480and568Declarations(varName) \
RUStaticVariableSynthesizationGetterImageDeclaration(varName); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##h480); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##h568);

#define RUUIImageScreenSizeCompatibleSynthesize460and480and568Implementations(varName,imageName) \
RUStaticVariableSynthesizationWithGetterImage(varName, imageName); \
RUStaticVariableSynthesizationWithGetterImage(varName##h480, imageName@"-480h"); \
RUStaticVariableSynthesizationWithGetterImage(varName##h568, imageName@"-568h");
//----




//Getters
#define RUUIImageScreenSizeCompatibleSynthesize480IfIOS7Else460(varName) ([RUCompatability isIOS7] ? [self varName##h480] : [self varName])
#define RUUIImageScreenSizeCompatibleSynthesize568If4Inch480IfIOS7Else460(varName) ([RUCompatability screenSizeIs4inch] ? [self varName##h568] : RUUIImageScreenSizeCompatibleSynthesize480IfIOS7Else460(varName))
#define RUUIImageScreenSizeCompatibleSynthesize480or568BasedOnScreenSizeReturnStatement(varName) ([RUCompatability screenSizeIs4inch] ? [self varName##h568] : [self varName])
#define RUUIImageScreenSizeCompatibleSynthesize480or568BasedOnIOS7ReturnStatement(varName) ([RUCompatability isIOS7] ? [self varName##h568] : [self varName])





@interface RUImageCompatability : NSObject

@end
