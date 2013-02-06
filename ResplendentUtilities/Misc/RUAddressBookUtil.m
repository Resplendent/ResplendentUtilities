//
//  AddressBookUtil.m
//  Albumatic
//
//  Created by Benjamin Maer on 2/4/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUAddressBookUtil.h"
#import <AddressBook/AddressBook.h>
#import "RUConstants.h"

@implementation RUAddressBookUtil

ABPropertyID abMultiValueRefForPersonWithPropertyType(ABRecordRef person,kRUAddressBookUtilPhonePropertyType propertyType)
{
    switch (propertyType)
    {
        case kRUAddressBookUtilPhonePropertyTypeEmail:
            return kABPersonEmailProperty;
            break;

        case kRUAddressBookUtilPhonePropertyTypePhone:
            return kABPersonPhoneProperty;
            break;
    }

    [NSException raise:NSInvalidArgumentException format:@"unhandled property type %i",propertyType];
}

+(void)askUserForPermissionWithCompletion:(void (^)(BOOL, BOOL))completion
{
    ABAddressBookRef addressbook = ABAddressBookCreate();

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            if (granted)
                RUDLog(@"got permission");
            else
                RUDLog(@"rejected");

            if (completion)
                completion(NO,granted);
        });
    }
    else
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            if (completion)
                completion(YES,YES);
        }
        else
        {
            if (completion)
                completion(YES,NO);
        }
    }
}

//phoneProperties must be an array of ABPropertyID types
+(NSDictionary*)getArraysFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties
{
    ABAddressBookRef addressbook = ABAddressBookCreate();

    if(addressbook)
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
        {
            // The user has previously given access, add the contact
            RUDLog(@"has permission");
        }
        else
        {
            RUDLog(@"previously rejected permission");
            return nil;
        }

        NSMutableDictionary* arrayDictionary = [NSMutableDictionary dictionaryWithCapacity:phoneProperties.count];
        
        //Add the arrays to the dictionary
        for (NSNumber* phoneProperty in phoneProperties)
        {
            [arrayDictionary setObject:[NSMutableArray array] forKey:phoneProperty.stringValue];
        }

//        ABRecordRef source = ABAddressBookCopyDefaultSource(addressbook);
        
        CFArrayRef people =  ABAddressBookCopyArrayOfAllPeople(addressbook);
        
//        CFArrayRef people = ABAddressBookCopyArrayOfAllPeopleInSource(addressbook, source);
        
        if( people )
        {
            CFIndex contactCount = CFArrayGetCount(people);
            
            for (int contantIndex = 0; contantIndex < contactCount; contantIndex++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex(people, contantIndex);

                for (NSNumber* phoneProperty in phoneProperties)
                {
                    NSMutableArray* propArray = [arrayDictionary objectForKey:phoneProperty.stringValue];
                    ABMultiValueRef personProperties = (ABMultiValueRef)ABRecordCopyValue(person, abMultiValueRefForPersonWithPropertyType(person, phoneProperty.integerValue));

                    NSString* personProperty = nil;

                    CFIndex personPropertiesCount = ABMultiValueGetCount(personProperties);

                    for (int phoneIndex = 0; phoneIndex < personPropertiesCount; phoneIndex++)
                    {
                        personProperty = (__bridge NSString*)ABMultiValueCopyValueAtIndex(personProperties, phoneIndex);

                        if (personProperty)
                            [propArray addObject:personProperty];
                    }
                }
            }
        }

        return arrayDictionary;
    }
    else
    {
        RUDLog(@"no address book");
        return nil;
    }
}

+(NSArray*)getContactsPhoneNumbersArray
{
    NSMutableArray* phoneNumbersArray = [NSMutableArray array];
    ABAddressBookRef addressbook = ABAddressBookCreate();
    if( addressbook )
    {
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressbook);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeopleInSource(addressbook, source);

        if( people )
        {
            CFIndex contactCount = CFArrayGetCount(people);
            
            for (int contantIndex = 0; contantIndex < contactCount; contantIndex++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex(people, contantIndex);
                ABMultiValueRef phoneNumbers = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
                NSString* phoneNumber = nil;

                for (int phoneIndex = 0; phoneIndex < ABMultiValueGetCount(phoneNumbers); phoneIndex++)
                {
//                    phoneNumberLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phoneNumbers, phoneIndex);
//                    RUDLog(@"phoneNumberLabel: %@",phoneNumberLabel);
                    phoneNumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, phoneIndex);

                    if (phoneNumber)
                        [phoneNumbersArray addObject:phoneNumber];

//                    if([phoneNumberLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
//                        NSLog(@"mobile:");
//                        RUDLog(@"phoneNumber: %@",phoneNumber);
//                    } else if ([phoneNumberLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel]) {
//                        NSLog(@"iphone:");
//                    } else if ([phoneNumberLabel isEqualToString:(NSString*)kABPersonPhonePagerLabel]) {
//                        NSLog(@"pager:");
//                    }
                }
            }
        }
    }

    RUDLog(@"phoneNumbersArray: %@",phoneNumbersArray);
    return phoneNumbersArray;
}

@end
