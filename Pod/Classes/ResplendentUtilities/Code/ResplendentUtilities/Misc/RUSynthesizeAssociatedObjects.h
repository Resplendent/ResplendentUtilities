//
//  RUSynthesizeAssociatedObjects.h
//  Resplendent
//
//  Created by Benjamin Maer on 10/7/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "RUClassOrNilUtil.h"


//++++
//Setters
#define RU_Synthesize_AssociatedObject_Setter_Implementation(v,V,arName,varType,constVoidKey,objc_AssociationPolicy) \
-(void)set##V##arName:(varType)v##arName \
{ \
    objc_setAssociatedObject(self, constVoidKey, v##arName, objc_AssociationPolicy); \
}

#define RU_Synthesize_AssociatedObject_SetterNumberFromPrimative_Implementation(v,V,arName,primativeType,constVoidKey,objc_AssociationPolicy) \
-(void)set##V##arName:(primativeType)v##arName \
{ \
    objc_setAssociatedObject(self, constVoidKey, @(v##arName), objc_AssociationPolicy); \
}
//----




//++++
//Getters
#define RU_Synthesize_AssociatedObject_Getter_Implementation(varName,varType,constVoidKey) \
-(varType)varName \
{ \
    return objc_getAssociatedObject(self, constVoidKey); \
}

#define RU_Synthesize_AssociatedObject_GetterNumberFromPrimative_Implementation(varName,primativeType,NSNumberGetter,constVoidKey) \
-(primativeType)varName \
{ \
    return kRUNumberOrNil(objc_getAssociatedObject(self, constVoidKey)).NSNumberGetter; \
}
//----




//++++
//GetterAndSetter
#define RU_Synthesize_AssociatedObject_GetterSetter_Implementation(v,V,arName,varType,constVoidKey,objc_AssociationPolicy) \
RU_Synthesize_AssociatedObject_Setter_Implementation(v,V,arName,varType,constVoidKey,objc_AssociationPolicy) \
RU_Synthesize_AssociatedObject_Getter_Implementation(v##arName,varType,constVoidKey)

#define RU_Synthesize_AssociatedObject_GetterSetterNumberFromPrimative_Implementation(v,V,arName,primativeType,NSNumberGetter,constVoidKey,objc_AssociationPolicy) \
RU_Synthesize_AssociatedObject_SetterNumberFromPrimative_Implementation(v,V,arName,primativeType,constVoidKey,objc_AssociationPolicy) \
RU_Synthesize_AssociatedObject_GetterNumberFromPrimative_Implementation(v##arName,primativeType,NSNumberGetter,constVoidKey)
//----
