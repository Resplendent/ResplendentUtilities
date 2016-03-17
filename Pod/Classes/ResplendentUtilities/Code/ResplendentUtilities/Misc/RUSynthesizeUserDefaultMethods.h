//
//  RUSynthesizeUserDefaultMethods.h
//  Resplendent
//
//  Created by Benjamin Maer on 2/2/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUClassOrNilUtil.h"





//General
#define __kRUSynthesizeUserDefaultMethods_AssociatedKey_Name(varName) __RUSynthesizeUserDefaultMethods_##varName##_AssociatedKey
#define __kRUSynthesizeUserDefaultMethods_AssociatedKey_String(varName) @"__RUSynthesizeUserDefaultMethods_" #varName @"_AssociatedKey"

#define __kRUSynthesizeUserDefaultMethods_Synthesize_AssociatedKey(varName) \
static NSString* __kRUSynthesizeUserDefaultMethods_AssociatedKey_Name(varName) = __kRUSynthesizeUserDefaultMethods_AssociatedKey_String(varName); \

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


//Instance, Setter Implementation
#define RUSynthesizeSetUserDefaultsMethodCompletion(varName,varType,key,completion) \
-(void)set##varName:(varType *)varName \
{ \
	kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName,key,completion) \
}

#define RUSynthesizeSetUserDefaultsMethod(varName,varType,key) \
RUSynthesizeSetUserDefaultsMethodCompletion(varName,varType,key,nil)

//Instance, Getter Implementation
#define RUSynthesizeGetUserDefaultsMethod(varName,varType,key) \
-(varType *)varName \
{ \
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
	return [userDefaults objectForKey:key]; \
}

//Instance, Setter and Getter Implementation
#define RUSynthesizeSetGetUserDefaultsMethod(VarName,varName,varType,key) \
RUSynthesizeSetUserDefaultsMethod(VarName,varType,key) \
RUSynthesizeGetUserDefaultsMethod(varName,varType,key)

//Instance, Setter and Getter Implementation with synthesized key
#define RUSynthesizeSetGetUserDefaultsMethod_SynthesizeKey(VarName,varName,varType) \
__kRUSynthesizeUserDefaultMethods_Synthesize_AssociatedKey(varName) \
RUSynthesizeSetGetUserDefaultsMethod(VarName,varName,varType,__RUSynthesizeUserDefaultMethods_##varName##_AssociatedKey) \


// ++ Instance or Static, Declaration
#define RUSynthesizeSetGetUserDefaultsMethodDeclarations(plusOrMinus,VarName,varName,varType) \
plusOrMinus(void)set##VarName:(varType)varName; \
plusOrMinus(varType)varName;

// ++ Instance, Declaration
#define RUSynthesizeSetGetUserDefaultsMethodDeclarations_Instance(VarName,varName,varType) \
RUSynthesizeSetGetUserDefaultsMethodDeclarations(-,VarName,varName,varType)

// ++ Static, Declaration
#define RUSynthesizeSetGetUserDefaultsMethodDeclarations_Static(VarName,varName,varType) \
RUSynthesizeSetGetUserDefaultsMethodDeclarations(+,VarName,varName,varType)

//Static, Setter Implementation
#define RUSynthesizeStaticSetUserDefaultsMethodCompletion(varName,varType,key,completion) \
+(void)set##varName:(varType *)varName \
{ \
	kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName,key,completion) \
}

#define RUSynthesizeStaticSetUserDefaultsMethod(varName,varType,key) \
RUSynthesizeStaticSetUserDefaultsMethodCompletion(varName,varType,key,nil)

//Static, Getter Implementation
#define RUSynthesizeStaticGetUserDefaultsMethod(varName,varType,key) \
+(varType *)varName \
{ \
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
	return [userDefaults objectForKey:key]; \
}

//Static, Getter and Setter Implementation
#define RUSynthesizeStaticSetGetUserDefaultsMethod(VarName,varName,varType,key) \
RUSynthesizeStaticSetUserDefaultsMethod(VarName,varType,key) \
RUSynthesizeStaticGetUserDefaultsMethod(varName,varType,key)

#define RUSynthesizeStaticSetGetUserDefaultsMethod_SynthesizeKey(VarName,varName,varType) \
__kRUSynthesizeUserDefaultMethods_Synthesize_AssociatedKey(varName) \
RUSynthesizeStaticSetUserDefaultsMethod(VarName,varType,__RUSynthesizeUserDefaultMethods_##varName##_AssociatedKey) \
RUSynthesizeStaticGetUserDefaultsMethod(varName,varType,__RUSynthesizeUserDefaultMethods_##varName##_AssociatedKey)



// ++ Primitive, Declaration
#define RUSynthesizeSetGetUserDefaultsMethodDeclarations_Primitive(plusOrMinus,VarName,varName,varType) \
RUSynthesizeSetGetUserDefaultsMethodDeclarations(plusOrMinus,VarName,varName,varType) \
plusOrMinus(NSNumber*)varName##_numberWrapper;

//Primitive Instance, Declaration
#define RUSynthesizeInstanceSetGetUserDefaultsMethodDeclarations_Primitive(VarName,varName,varType) \
RUSynthesizeSetGetUserDefaultsMethodDeclarations_Primitive(-,VarName,varName,varType)

//Primitive Static, Declaration
#define RUSynthesizeStaticSetGetUserDefaultsMethodDeclarations_Primitive(VarName,varName,varType) \
RUSynthesizeSetGetUserDefaultsMethodDeclarations_Primitive(+,VarName,varName,varType)

#define RUSynthesizeStaticSetGetUserDefaultsMethodDeclarations(VarName,varName,varType) \
RUSynthesizeStaticSetGetUserDefaultsMethodDeclarations_Primitive(VarName,varName,varType *)

// -- Primitive, Declaration


// ++ Primitive, Implementation Setter
#define RUSynthesizeSetUserDefaultsMethodCompletion_Primitive(plusOrMinus,varName,varType,key,completion) \
plusOrMinus(void)set##varName:(varType)varName \
{ \
	[self set##varName##_numberWrapper:@(varName)]; \
} \
\
plusOrMinus(void)set##varName##_numberWrapper:(NSNumber*)varName##_number \
{ \
	kRUSynthesizeSetUserDefaultsMethodCompletionImplementation(varName##_number,key,completion) \
}

//Primitive Instance, Setter Implementation
#define RUSynthesizeInstanceSetUserDefaultsMethodCompletion_Primitive(varName,varType,key,completion) \
RUSynthesizeSetUserDefaultsMethodCompletion_Primitive(-,varName,varType,key,completion)

//Primitive Static, Setter Implementation
#define RUSynthesizeStaticSetUserDefaultsMethodCompletion_Primitive(varName,varType,key,completion) \
RUSynthesizeSetUserDefaultsMethodCompletion_Primitive(+,varName,varType,key,completion)
// -- Primitive, Implementation Setter


// ++ Primitive, Getter Implementation
#define RUSynthesizeGetUserDefaultsMethod_Primitive_SynthesizeKey(plusOrMinus,varName,varType,NSNumberGetter) \
plusOrMinus(NSNumber*)varName##_numberWrapper \
{ \
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
	NSString* key = __kRUSynthesizeUserDefaultMethods_AssociatedKey_Name(varName); \
	NSNumber* varNumber = [userDefaults objectForKey:key]; \
	return varNumber; \
} \
\
plusOrMinus(varType)varName \
{ \
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults]; \
	NSString* key = __kRUSynthesizeUserDefaultMethods_AssociatedKey_Name(varName); \
	NSNumber* varNumber = [userDefaults objectForKey:key]; \
	return varNumber.NSNumberGetter; \
}

//Primitive Instance, Getter Implementation
#define RUSynthesizeInstanceGetUserDefaultsMethod_Primitive_SynthesizeKey(varName,varType,NSNumberGetter) \
RUSynthesizeGetUserDefaultsMethod_Primitive_SynthesizeKey(-,varName,varType,NSNumberGetter)

//Primitive Static, Getter Implementation
#define RUSynthesizeStaticGetUserDefaultsMethod_Primitive_SynthesizeKey(varName,varType,NSNumberGetter) \
RUSynthesizeGetUserDefaultsMethod_Primitive_SynthesizeKey(+,varName,varType,NSNumberGetter)

// -- Primitive, Getter Implementation

// ++ Primitive, Getter and Setter Implementation And Declaration

//Static Primitive, Getter and Setter Implementation And Declaration
#define RUSynthesizeStaticSetGetUserDefaultsMethod_Primitive_SynthesizeKey(VarName,varName,varType,NSNumberGetter) \
__kRUSynthesizeUserDefaultMethods_Synthesize_AssociatedKey(varName) \
RUSynthesizeStaticSetUserDefaultsMethodCompletion_Primitive(VarName,varType,__kRUSynthesizeUserDefaultMethods_AssociatedKey_String(varName),nil) \
RUSynthesizeStaticGetUserDefaultsMethod_Primitive_SynthesizeKey(varName,varType,NSNumberGetter)

#define RUSynthesizeInstanceSetGetUserDefaultsMethod_Primitive_SynthesizeKey(VarName,varName,varType,NSNumberGetter) \
__kRUSynthesizeUserDefaultMethods_Synthesize_AssociatedKey(varName) \
RUSynthesizeInstanceSetUserDefaultsMethodCompletion_Primitive(VarName,varType,__kRUSynthesizeUserDefaultMethods_AssociatedKey_String(varName),nil) \
RUSynthesizeInstanceGetUserDefaultsMethod_Primitive_SynthesizeKey(varName,varType,NSNumberGetter)
