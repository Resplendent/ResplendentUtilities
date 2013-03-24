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

//++++ UIImage helpers
#define RUStaticVariableSynthesizationGetterColorDeclaration(varName) \
RUStaticVariableSynthesizationGetterDeclaration(UIColor, varName);

#define RUStaticVariableSynthesizationWithGetterColorHex(varName,colorHexColor) \
RUStaticVariableSynthesizationWithGetter(UIColor,varName,[UIColor colorWithHexString:colorHexColor]) \
//----

