//
//  RUImageCompatability.h
//  Wallflower Food
//
//  Created by Benjamin Maer on 3/21/14.
//  Copyright (c) 2014 Wallflower Food. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUCompatability.h"





#define RUUIImagePineappleScreenSizeCompatibleSynthesize460or480BasedOnIOS7ReturnStatement(varName) ([RUCompatability isIOS7] ? [self varName##h480] : [self varName])

//++++
//460 and 480
#define RUUIImagePineappleScreenSizeCompatibleSynthesize460and480Declarations(varName) \
RUStaticVariableSynthesizationGetterImageDeclaration(varName); \
RUStaticVariableSynthesizationGetterImageDeclaration(varName##h480);

#define RUUIImagePineappleScreenSizeCompatibleSynthesize460and480Implementations(varName,imageName) \
RUStaticVariableSynthesizationWithGetterImage(varName, imageName); \
RUStaticVariableSynthesizationWithGetterImage(varName##h480, imageName@"-480h");
//----





@interface RUImageCompatability : NSObject

@end
