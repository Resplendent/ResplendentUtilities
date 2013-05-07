//
//  RUStaticVariableSynthesization.h
//  Albumatic
//
//  Created by Benjamin Maer on 3/7/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RUStaticVariableSynthesization(varType,varName) \
static varType * varName##StaticVariable;

#define RUStaticVariableSynthesizationGetterDeclaration(varType,varName) \
+(varType *)varName;

#define RUStaticVariableSynthesizationWithGetter(varType,varName,allocStatment) \
RUStaticVariableSynthesization(varType,varName); \
 \
+(varType *)varName \
{ \
    if (!varName##StaticVariable) \
        varName##StaticVariable = allocStatment; \
    return varName##StaticVariable; \
}

//++++ UIImage helpers
#define RUStaticVariableSynthesizationGetterImageDeclaration(varName) \
RUStaticVariableSynthesizationGetterDeclaration(UIImage, varName);

#define RUStaticVariableSynthesizationWithGetterImage(varName,imageNameString) \
RUStaticVariableSynthesizationWithGetter(UIImage,varName,[UIImage imageNamed:imageNameString]) \
//----

//++++ UIFont helpers
#define RUStaticVariableSynthesizationGetterFontDeclaration(varName) \
RUStaticVariableSynthesizationGetterDeclaration(UIFont, varName);

#define RUStaticVariableSynthesizationWithGetterFont(varName,fontName,fontSize) \
RUStaticVariableSynthesizationWithGetter(UIFont,varName,[UIFont fontWithName:fontName size:fontSize]) \
//----

//++++ UIColor helpers
#define RUStaticVariableSynthesizationGetterColorDeclaration(varName) \
RUStaticVariableSynthesizationGetterDeclaration(UIColor, varName);

#define RUStaticVariableSynthesizationWithGetterColor(varName,allocStatment) \
RUStaticVariableSynthesizationWithGetter(UIColor,varName,allocStatment) \

#define RUStaticVariableSynthesizationWithGetterColorHex(varName,colorHexColor) \
RUStaticVariableSynthesizationWithGetterColor(varName,[UIColor colorWithHexString:colorHexColor]) \

#define RUStaticVariableSynthesizationWithGetterColorWhiteAlpha(varName,whiteVal,alphaVal) \
RUStaticVariableSynthesizationWithGetterColor(varName,[UIColor colorWithWhite:(whiteVal) alpha:(alphaVal)]) \
//----

