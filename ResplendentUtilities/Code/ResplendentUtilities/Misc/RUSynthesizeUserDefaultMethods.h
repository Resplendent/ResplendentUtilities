//
//  RUSynthesizeUserDefaultMethods.h
//  Resplendent
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName,key,completion) \
NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
if (varName && !kRUClassOrNil(varName,NSNull)) [userDefaults setObject:varName forKey:key]; \
else [userDefaults removeObjectForKey:key]; \
[userDefaults synchronize]; \
if (completion) \
{ \
void (^completionBlock)() = completion; \
completionBlock(varName); \
} \


#define RUSynthesizeSetUserDefaultsMethodCompletion(varName,varType,key,completion) \
-(void)set##varName:(varType *)varName \
{ \
    kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName,key,completion) \
}

#define RUSynthesizeSetUserDefaultsMethod(varName,varType,key) \
RUSynthesizeSetUserDefaultsMethodCompletion(varName,varType,key,nil)

#define RUSynthesizeGetUserDefaultsMethod(varName,varType,key) \
-(varType *)varName \
{ \
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
    return [userDefaults objectForKey:key]; \
}

#define RUSynthesizeSetGetUserDefaultsMethod(VarName,varName,varType,key) \
RUSynthesizeSetUserDefaultsMethod(VarName,varType,key) \
RUSynthesizeGetUserDefaultsMethod(varName,varType,key)

//Static, Declaration
#define RUSynthesizeStaticSetGetUserDefaultsMethodDeclarations_Primitive(VarName,varName,varType) \
+(void)set##VarName:(varType)varName; \
+(varType)varName;

#define RUSynthesizeStaticSetGetUserDefaultsMethodDeclarations(VarName,varName,varType) \
RUSynthesizeStaticSetGetUserDefaultsMethodDeclarations_Primitive(VarName,varName,varType *)

//Static, Implementation Setter
#define RUSynthesizeStaticSetUserDefaultsMethodCompletion_Primitive(varName,varType,key,completion) \
+(void)set##varName:(varType)varName \
{ \
kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(@(varName),key,completion) \
}

#define RUSynthesizeStaticSetUserDefaultsMethodCompletion(varName,varType,key,completion) \
+(void)set##varName:(varType *)varName \
{ \
kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName,key,completion) \
}

//Static, Implementation Getter
#define RUSynthesizeStaticSetUserDefaultsMethod(varName,varType,key) \
RUSynthesizeStaticSetUserDefaultsMethodCompletion(varName,varType,key,nil)

#define RUSynthesizeStaticGetUserDefaultsMethod(varName,varType,key) \
+(varType *)varName \
{ \
NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
return [userDefaults objectForKey:key]; \
}

//Static, Implementation Setter and Getter
#define RUSynthesizeStaticSetGetUserDefaultsMethod(VarName,varName,varType,key) \
RUSynthesizeStaticSetUserDefaultsMethod(VarName,varType,key) \
RUSynthesizeStaticGetUserDefaultsMethod(varName,varType,key)

#define RUSynthesizeStaticSetGetUserDefaultsMethod_SynthesizeKey(VarName,varName,varType) \
static NSString* __RUSynthesizeUserDefaultMethods_##varName##_AssociatedKey = @"__RUSynthesizeUserDefaultMethods_##varName##_AssociatedKey"; \
RUSynthesizeStaticSetUserDefaultsMethod(VarName,varType,__RUSynthesizeUserDefaultMethods_##varName##_AssociatedKey) \
RUSynthesizeStaticGetUserDefaultsMethod(varName,varType,__RUSynthesizeUserDefaultMethods_##varName##_AssociatedKey)
