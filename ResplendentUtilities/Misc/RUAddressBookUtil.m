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

typedef enum {
    RUAddressBookUtilABMultiValueRefTypeUnknown,
    RUAddressBookUtilABMultiValueRefTypeNSString,
    RUAddressBookUtilABMultiValueRefTypeArray,
    RUAddressBookUtilABMultiValueRefTypeData
}RUAddressBookUtilABMultiValueRefType;

NSString* const kRUAddressBookUtilHasAskedUserForContacts = @"kRUAddressBookUtilHasAskedUserForContacts";

const char * getImageDataQueueLabel = "RUAddressBookUtil.getImageDataQueueLabel";
static dispatch_queue_t getImageDataQueue;
//static NSMutableArray* getImageDataRequestQueue;

//void kRUAddressBookUtilAddPersonPropertiesArrayToPersonPropertiesDictionary(CFTypeRef personPropertiesRecord, NSMutableDictionary* personPropertyDictionary,NSString* phoneProperty);

id kRUAddressBookUtilPersonPropertyForPhonePropertyType(ABRecordRef person,kRUAddressBookUtilPhonePropertyType type);
NSMutableArray* kRUAddressBookUtilPersonPropertiesArray(ABMultiValueRef personPropertiesRecord);
ABPropertyID abMultiValueRefForPersonWithPropertyType(kRUAddressBookUtilPhonePropertyType propertyType);
RUAddressBookUtilABMultiValueRefType abMultiValueRefTypeForPersonWithPropertyType(kRUAddressBookUtilPhonePropertyType propertyType);

static NSMutableArray* sharedInstances;

@interface RUAddressBookUtil () <UIAlertViewDelegate>

@property (nonatomic, strong) RUAddressBookUtilAskForPermissionsCompletionBlock alertViewCompletion;

+(BOOL)usesNativePermissions;

//+(void)removeRequestFromQueue:(RUAddressBookUtilImageRequest*)request;  
+(NSData*)imageDataFromAddressBookForContactIndex:(CFIndex)contactIndex;

@end



@interface RUAddressBookUtil (UserDefaults)

+(NSNumber*)cachedHasAskedUserForContacts;
+(void)setCachedHasAskedUserForContacts:(NSNumber*)number;

@end




@implementation RUAddressBookUtil

+(void)initialize
{
    if (self == [RUAddressBookUtil class])
    {
        getImageDataQueue = dispatch_queue_create(getImageDataQueueLabel, 0);
//        getImageDataRequestQueue = [NSMutableArray array];
    }
}

#pragma mark - UIAlertViewDelegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL allowedPermission = (buttonIndex != alertView.cancelButtonIndex);

    [RUAddressBookUtil setCachedHasAskedUserForContacts:@(allowedPermission)];
    _alertViewCompletion(NO,allowedPermission);
    _alertViewCompletion = nil;

    [sharedInstances removeObject:self];
}

#pragma mark - C methods
id kRUAddressBookUtilPersonPropertyForPhonePropertyType(ABRecordRef person,kRUAddressBookUtilPhonePropertyType type)
{
    switch (abMultiValueRefTypeForPersonWithPropertyType(type))
    {
        case RUAddressBookUtilABMultiValueRefTypeNSString:
            return (__bridge NSArray*)ABRecordCopyValue(person, abMultiValueRefForPersonWithPropertyType(type));
            break;

        case RUAddressBookUtilABMultiValueRefTypeArray:
            return kRUAddressBookUtilPersonPropertiesArray(ABRecordCopyValue(person, abMultiValueRefForPersonWithPropertyType(type)));
            break;

        case RUAddressBookUtilABMultiValueRefTypeData:
            return (__bridge NSData*)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            break;

        case RUAddressBookUtilABMultiValueRefTypeUnknown:
            break;
    }
    
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:RUStringWithFormat(@"unhandled property type %i",type) userInfo:nil];
}

NSMutableArray* kRUAddressBookUtilPersonPropertiesArray(ABMultiValueRef personPropertiesRecord)
{
    CFIndex personPropertiesCount = ABMultiValueGetCount(personPropertiesRecord);
    
    NSMutableArray* personPropertiesArray = [NSMutableArray array];
    
    for (int phoneIndex = 0; phoneIndex < personPropertiesCount; phoneIndex++)
    {
        NSString* personProperty = (__bridge NSString*)ABMultiValueCopyValueAtIndex(personPropertiesRecord, phoneIndex);
        
        if (personProperty)
            [personPropertiesArray addObject:personProperty];
    }
    
    return personPropertiesArray;
}

RUAddressBookUtilABMultiValueRefType abMultiValueRefTypeForPersonWithPropertyType(kRUAddressBookUtilPhonePropertyType propertyType)
{
    switch (propertyType)
    {
        case kRUAddressBookUtilPhonePropertyTypeEmail:
        case kRUAddressBookUtilPhonePropertyTypePhone:
            return RUAddressBookUtilABMultiValueRefTypeArray;

        case kRUAddressBookUtilPhonePropertyTypeFirstName:
        case kRUAddressBookUtilPhonePropertyTypeLastName:
            return RUAddressBookUtilABMultiValueRefTypeNSString;
            break;

        case kRUAddressBookUtilPhonePropertyTypeImage:
            return RUAddressBookUtilABMultiValueRefTypeData;
            break;
    }

    RUDLog(@"unknown property type %i",propertyType);
    return RUAddressBookUtilABMultiValueRefTypeUnknown;
}

ABPropertyID abMultiValueRefForPersonWithPropertyType(kRUAddressBookUtilPhonePropertyType propertyType)
{
    switch (propertyType)
    {
        case kRUAddressBookUtilPhonePropertyTypeEmail:
            return kABPersonEmailProperty;
            break;

        case kRUAddressBookUtilPhonePropertyTypePhone:
            return kABPersonPhoneProperty;
            break;

        case kRUAddressBookUtilPhonePropertyTypeFirstName:
            return kABPersonFirstNameProperty;
            break;

        case kRUAddressBookUtilPhonePropertyTypeLastName:
            return kABPersonLastNameProperty;
            break;

        case kRUAddressBookUtilPhonePropertyTypeImage:
            break;
    }

    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:RUStringWithFormat(@"unhandled property type %i",propertyType) userInfo:nil];
}

#pragma mark - Image methods
+(NSData*)imageDataFromAddressBookForContactIndex:(CFIndex)contactIndex
{
    ABAddressBookRef addressbook = ABAddressBookCreate();
    
    if(addressbook)
    {
        if ([self usesNativePermissions])
        {
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
            {
                // The user has previously given access, add the contact
            }
            else
            {
                RUDLog(@"previously rejected permission");
                return nil;
            }
        }
        else
        {
            NSNumber* askedPermission = [self cachedHasAskedUserForContacts];
            
            if (!(askedPermission && askedPermission.boolValue))
                return nil;
        }
        
        CFArrayRef people =  ABAddressBookCopyArrayOfAllPeople(addressbook);
        
        if (people)
        {
            ABRecordRef person = CFArrayGetValueAtIndex(people, contactIndex);
            
            if (person)
            {
                NSData* imageData = kRUAddressBookUtilPersonPropertyForPhonePropertyType(person, kRUAddressBookUtilPhonePropertyTypeImage);
                
                return imageData;
            }
            else
            {
                RUDLog(@"no person");
                return nil;
            }
        }
        else
        {
            RUDLog(@"no people");
            return nil;
        }
    }
    else
    {
        RUDLog(@"no address book");
        return nil;
    }
}

//+(void)removeRequestFromQueue:(RUAddressBookUtilImageRequest*)request
//{
//    RUDLog(@"will remove %@ from getImageDataRequestQueue: %@",request,getImageDataRequestQueue);
//    [getImageDataRequestQueue removeObject:request];
//    RUDLog(@"removed %@ from getImageDataRequestQueue: %@",request,getImageDataRequestQueue);
//}

+(RUAddressBookUtilImageRequest*)getImageDataFromAddressBookForContactIndex:(CFIndex)contactIndex completion:(RUAddressBookUtilGetImageBlock)completion
{
    if (completion)
    {
        __block RUAddressBookUtilImageRequest* request = [[RUAddressBookUtilImageRequest alloc] initWithContactIndex:contactIndex completionBlock:completion];
        if (request)
        {
//            RUDLog(@"will add to getImageDataRequestQueue: %@",getImageDataRequestQueue);
//            [getImageDataRequestQueue addObject:request];
//            RUDLog(@"added to getImageDataRequestQueue: %@",getImageDataRequestQueue);
            dispatch_async(getImageDataQueue, ^{
                if (request.canceled)
                {
//                    [self removeRequestFromQueue:request];
                }
                else
                {
                    NSData* imageData = [self imageDataFromAddressBookForContactIndex:request.contactIndex];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!request.canceled)
                            request.completionBlock(imageData,request.contactIndex);

//                        [self removeRequestFromQueue:request];
                    });
                }
            });
            return request;
        }
        else
        {
            RUDLog(@"nil request");
            return nil;
        }
    }
    else
    {
        RUDLog(@"must pass completion block");
        return nil;
    }
}

#pragma mark - Static methods
+(BOOL)usesNativePermissions
{
    return (ABAddressBookRequestAccessWithCompletion != nil);
}

+(void)askUserForPermissionWithCompletion:(RUAddressBookUtilAskForPermissionsCompletionBlock)completion
{
    ABAddressBookRef addressbook = ABAddressBookCreate();

    if ([self usesNativePermissions])
    {
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
    else
    {
        NSNumber* hasAskedForPermission = [self cachedHasAskedUserForContacts];
        if (hasAskedForPermission)
        {
            completion(YES,hasAskedForPermission.boolValue);
        }
        else
        {
            RUAddressBookUtil* addressBookUtilInstance = [RUAddressBookUtil new];
            [addressBookUtilInstance setAlertViewCompletion:completion];
            
            if (!sharedInstances)
                sharedInstances = [NSMutableArray array];
            
            [sharedInstances addObject:addressBookUtilInstance];
            
            [[[UIAlertView alloc] initWithTitle:@"Albumatic Would Like to Access Your Contacts" message:nil delegate:addressBookUtilInstance cancelButtonTitle:@"Don't Allow" otherButtonTitles:@"OK", nil]show];
        }
    }
}

//phoneProperties must be an array of ABPropertyID types
+(NSDictionary*)getArraysFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties
{
    ABAddressBookRef addressbook = ABAddressBookCreate();

    if(addressbook)
    {
        if ([self usesNativePermissions])
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
        }
        else
        {
            NSNumber* askedPermission = [self cachedHasAskedUserForContacts];

            if (!(askedPermission && askedPermission.boolValue))
                return nil;
        }

        NSMutableDictionary* arrayDictionary = [NSMutableDictionary dictionaryWithCapacity:phoneProperties.count];
        
        //Add the arrays to the dictionary
        for (NSNumber* phoneProperty in phoneProperties)
        {
            [arrayDictionary setObject:[NSMutableArray array] forKey:phoneProperty.stringValue];
        }

        CFArrayRef people =  ABAddressBookCopyArrayOfAllPeople(addressbook);

        if( people )
        {
            CFIndex contactCount = CFArrayGetCount(people);
            
            for (int contantIndex = 0; contantIndex < contactCount; contantIndex++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex(people, contantIndex);

                for (NSNumber* phoneProperty in phoneProperties)
                {
                    NSMutableArray* propArray = [arrayDictionary objectForKey:phoneProperty.stringValue];
                    ABMultiValueRef personProperties = (ABMultiValueRef)ABRecordCopyValue(person, abMultiValueRefForPersonWithPropertyType(phoneProperty.integerValue));

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

//+(NSArray*)getDictionariesFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties
+(NSArray*)getObjectsFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties objectCreationBlock:(RUAddressBookUtilCreateObjectWithDictBlock)objectCreationBlock
{
    if (!objectCreationBlock)
    {
        RUDLog(@"need to pass non nil objectCreationBlock");
        return nil;
    }

    ABAddressBookRef addressbook = ABAddressBookCreate();
    
    if(addressbook)
    {
        if ([self usesNativePermissions])
        {
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
            {
                // The user has previously given access, add the contact
            }
            else
            {
                RUDLog(@"previously rejected permission");
                return nil;
            }
        }
        else
        {
            NSNumber* askedPermission = [self cachedHasAskedUserForContacts];
            
            if (!(askedPermission && askedPermission.boolValue))
                return nil;
        }

        NSMutableArray* objectsArray = [NSMutableArray array];

        CFArrayRef people =  ABAddressBookCopyArrayOfAllPeople(addressbook);

        if( people )
        {
            CFIndex contactCount = CFArrayGetCount(people);

            for (int contantIndex = 0; contantIndex < contactCount; contantIndex++)
            {
                ABRecordRef person = CFArrayGetValueAtIndex(people, contantIndex);

                NSMutableDictionary* personPropertyDictionary = [NSMutableDictionary dictionary];
                for (NSNumber* phoneProperty in phoneProperties)
                {
                    id personPropertiesRecord = kRUAddressBookUtilPersonPropertyForPhonePropertyType(person, phoneProperty.integerValue);

                    if (personPropertiesRecord)
                    {
                        [personPropertyDictionary setObject:personPropertiesRecord forKey:phoneProperty.stringValue];
                    }
                }

                id object = objectCreationBlock(personPropertyDictionary,contantIndex);
                if (object)
                {
                    [objectsArray addObject:object];
                }
            }
        }

        return objectsArray;
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



@implementation RUAddressBookUtil (UserDefaults)

+(NSNumber*)cachedHasAskedUserForContacts
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kRUAddressBookUtilHasAskedUserForContacts];
}

+(void)setCachedHasAskedUserForContacts:(NSNumber*)number
{
    if (!number)
        [NSException raise:NSInvalidArgumentException format:@"Can't send nil number"];

    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:number forKey:kRUAddressBookUtilHasAskedUserForContacts];
    [userDefaults synchronize];
}

@end



@implementation RUAddressBookUtilImageRequest

-(id)initWithContactIndex:(CFIndex)contactIndex completionBlock:(RUAddressBookUtilGetImageBlock)completionBlock
{
    if (self = [self init])
    {
        _contactIndex = contactIndex;
        _completionBlock = completionBlock;
    }

    return self;
}

#pragma mark - Public methods
-(void)cancel
{
    _canceled = TRUE;
}

@end


