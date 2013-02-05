//
//  AddressBookUtil.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/4/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kRUAddressBookUtilPhonePropertyTypePhone = 100,
    kRUAddressBookUtilPhonePropertyTypeEmail
}kRUAddressBookUtilPhonePropertyType;
//    NSArray* properties = @[[NSNumber numberWithInt:kABPersonPhoneProperty],[NSNumber numberWithInt:kABPersonEmailProperty]];

@interface RUAddressBookUtil : NSObject

+(void)askUserForPermissionWithCompletion:(void(^)(BOOL alreadyAsked, BOOL granted))completion;

+(NSDictionary*)getArraysFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties;
+(NSArray*)getContactsPhoneNumbersArray;

@end
