//
//  AddressBookUtil.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/4/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RUAddressBookUtilAskForPermissionsCompletionBlock)(BOOL alreadyAsked, BOOL granted);
typedef id (^RUAddressBookUtilCreateObjectWithDictBlcok)(NSDictionary* properites);

typedef enum
{
    kRUAddressBookUtilPhonePropertyTypePhone = 100,
    kRUAddressBookUtilPhonePropertyTypeEmail,
    kRUAddressBookUtilPhonePropertyTypeFirstName,
    kRUAddressBookUtilPhonePropertyTypeLastName,
    kRUAddressBookUtilPhonePropertyTypeData
}kRUAddressBookUtilPhonePropertyType;
//    NSArray* properties = @[[NSNumber numberWithInt:kABPersonPhoneProperty],[NSNumber numberWithInt:kABPersonEmailProperty]];

@interface RUAddressBookUtil : NSObject

+(void)askUserForPermissionWithCompletion:(RUAddressBookUtilAskForPermissionsCompletionBlock)completion;

+(NSDictionary*)getArraysFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties;
+(NSArray*)getContactsPhoneNumbersArray;

//+(NSArray*)getDictionariesFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties;
+(NSArray*)getObjectsFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties objectCreationBlock:(RUAddressBookUtilCreateObjectWithDictBlcok)objectCreationBlock;

@end
