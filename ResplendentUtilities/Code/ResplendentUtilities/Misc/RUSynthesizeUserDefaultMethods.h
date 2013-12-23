//
//  RUSynthesizeUserDefaultMethods.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName,varType,key,completion) \
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
    kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName,varType,key,completion) \
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

//Static
#define RUSynthesizeStaticSetGetUserDefaultsMethodDeclarations(VarName,varName,varType) \
+(void)set##VarName:(varType *)varName; \
+(varType *)varName;

#define RUSynthesizeStaticSetUserDefaultsMethodCompletion(varName,varType,key,completion) \
+(void)set##varName:(varType *)varName \
{ \
kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName,varType,key,completion) \
}


#define RUSynthesizeStaticSetUserDefaultsMethod(varName,varType,key) \
RUSynthesizeStaticSetUserDefaultsMethodCompletion(varName,varType,key,nil)

#define RUSynthesizeStaticGetUserDefaultsMethod(varName,varType,key) \
+(varType *)varName \
{ \
NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
return [userDefaults objectForKey:key]; \
}

#define RUSynthesizeStaticSetGetUserDefaultsMethod(VarName,varName,varType,key) \
RUSynthesizeStaticSetUserDefaultsMethod(VarName,varType,key) \
RUSynthesizeStaticGetUserDefaultsMethod(varName,varType,key)

