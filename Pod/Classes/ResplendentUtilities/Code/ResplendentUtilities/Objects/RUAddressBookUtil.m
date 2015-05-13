//
//  AddressBookUtil.m
//  Resplendent
//
//  Created by Benjamin Maer on 2/4/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUAddressBookUtil.h"
#import <AddressBook/AddressBook.h>
#import "RUDLog.h"
#import "RUConstants.h"
#import <UIKit/UIKit.h>





typedef enum {
    RUAddressBookUtilABMultiValueRefTypeUnknown,
    RUAddressBookUtilABMultiValueRefTypeNSString,
    RUAddressBookUtilABMultiValueRefTypeArray,
    RUAddressBookUtilABMultiValueRefTypeData
}RUAddressBookUtilABMultiValueRefType;





NSString* const kRUAddressBookUtilHasAskedUserForContacts = @"kRUAddressBookUtilHasAskedUserForContacts";

//++++ RUAddressBookUtilImageRequestQueue
const char * kRUAddressBookUtilGetImageDataQueueLabel = "RUAddressBookUtil.RUAddressBookUtilImageRequestQueue.getImageDataQueueLabel";
const char * kRUAddressBookUtilManageQueueArrayLabel = "RUAddressBookUtil.RUAddressBookUtilImageRequestQueue.manageQueueArrayLabel";
//static dispatch_queue_t getImageDataQueue;





@interface RUAddressBookUtilImageRequestQueue : NSObject
{
    dispatch_queue_t _getImageDataQueue;
    dispatch_queue_t _manageQueueArrayQueue;

    NSMutableArray* _queueArray;
    RUAddressBookUtilImageRequest* _currentImageRequest;
}

-(void)addRequestToQueue:(RUAddressBookUtilImageRequest*)request;
-(void)removeRequestFromQueue:(RUAddressBookUtilImageRequest*)request;
-(void)clearCurrentRequestAndCheckForNextRequest;
-(void)checkForNextRequest;
-(void)runCurrentRequest;

@end
//-----





@interface RUAddressBookUtilImageRequest ()

@property (nonatomic, assign) RUAddressBookUtilImageRequestQueue* queue;

-(id)initWithContactIndex:(CFIndex)contactIndex queue:(RUAddressBookUtilImageRequestQueue*)queue completionBlock:(RUAddressBookUtilGetImageDataBlock)completionBlock;

//Synchronously loads image data, so should be done with thread competency. Will throw exception if request is already fetching
-(NSData*)fetchImageData;

@end





static RUAddressBookUtilImageRequestQueue* getImageDataRequestQueue;

//void kRUAddressBookUtilAddPersonPropertiesArrayToPersonPropertiesDictionary(CFTypeRef personPropertiesRecord, NSMutableDictionary* personPropertyDictionary,NSString* phoneProperty);

id kRUAddressBookUtilPersonPropertyForPhonePropertyType(ABRecordRef person,kRUAddressBookUtilPhonePropertyType type);
NSMutableArray* kRUAddressBookUtilPersonPropertiesArray(ABMultiValueRef personPropertiesRecord);
ABPropertyID abMultiValueRefForPersonWithPropertyType(kRUAddressBookUtilPhonePropertyType propertyType);
RUAddressBookUtilABMultiValueRefType abMultiValueRefTypeForPersonWithPropertyType(kRUAddressBookUtilPhonePropertyType propertyType);

static NSMutableArray* sharedInstances;





@interface RUAddressBookUtil () <UIAlertViewDelegate>

@property (nonatomic, strong) RUAddressBookUtilAskForPermissionsCompletionBlock alertViewCompletion;

+(BOOL)usesNativePermissions;

+(NSData*)imageDataFromAddressBookForContactIndex:(CFIndex)contactIndex;

+(ABAddressBookRef)currentAddressBook;

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
//        getImageDataQueue = dispatch_queue_create(getImageDataQueueLabel, 0);
        getImageDataRequestQueue = [RUAddressBookUtilImageRequestQueue new];
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
    ABAddressBookRef addressbook = self.currentAddressBook;
    
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

+(RUAddressBookUtilImageRequest*)getImageDataFromAddressBookForContactIndex:(CFIndex)contactIndex completion:(RUAddressBookUtilGetImageDataBlock)completion
{
    if (completion)
    {
        RUAddressBookUtilImageRequest* request = [[RUAddressBookUtilImageRequest alloc] initWithContactIndex:contactIndex queue:getImageDataRequestQueue completionBlock:completion];
        [getImageDataRequestQueue addRequestToQueue:request];
        return request;
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
    return (&ABAddressBookRequestAccessWithCompletion != nil);
}

+(void)askUserForPermissionWithCompletion:(RUAddressBookUtilAskForPermissionsCompletionBlock)completion
{
    ABAddressBookRef addressbook = self.currentAddressBook;

    if ([self usesNativePermissions])
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
                // First time access has been granted, add the contact
//                if (granted)
//                    RUDLog(@"got permission");
//                else
//                    RUDLog(@"rejected");
                
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
    ABAddressBookRef addressbook = self.currentAddressBook;

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
                    ABMultiValueRef personProperties = (ABMultiValueRef)ABRecordCopyValue(person, abMultiValueRefForPersonWithPropertyType((kRUAddressBookUtilPhonePropertyType)phoneProperty.integerValue));

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

+(NSArray*)getObjectsFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties objectCreationBlock:(RUAddressBookUtilCreateObjectWithDictBlock)objectCreationBlock
{
    if (!objectCreationBlock)
    {
        RUDLog(@"need to pass non nil objectCreationBlock");
        return nil;
    }

    ABAddressBookRef addressbook = self.currentAddressBook;
    
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
                    id personPropertiesRecord = kRUAddressBookUtilPersonPropertyForPhonePropertyType(person, (kRUAddressBookUtilPhonePropertyType)phoneProperty.integerValue);

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
    ABAddressBookRef addressbook = self.currentAddressBook;
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

#pragma mark - Getters
+(ABAddressBookRef)currentAddressBook
{
    ABAddressBookRef addressBookRef = NULL;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    addressBookRef = ABAddressBookCreate();
#else
    CFErrorRef error = nil;
    //        NSError *error = nil;
    addressBookRef = ABAddressBookCreateWithOptions(NULL, (CFErrorRef *)&error);
    if (error)
    {
        RUDLog(@"error: %@",error);
    }
#endif

//    ABAddressBookRef addressBookRef = NULL;
//    if (&ABAddressBookCreateWithOptions)
//    {
//        CFErrorRef error = nil;
//        //        NSError *error = nil;
//        addressBookRef = ABAddressBookCreateWithOptions(NULL, (CFErrorRef *)&error);
//        if (error)
//        {
//            RUDLog(@"error: %@",error);
//        }
//    }
//    else
//    {
//#pragma GCC diagnostic push
//#pragma GCC diagnostic ignored "-Wdeprecated"
//        addressBookRef = ABAddressBookCreate();
//#pragma GCC diagnostic pop
//    }

    return addressBookRef;
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

//-(void)dealloc
//{
//    RUDLog(@"%@",self);
//}

-(id)init
{
    if (!_queue)
        [NSException raise:NSInternalInconsistencyException format:@"Queue not present, must use RUAddressBookUtil's getImageDataFromAddressBookForContactIndex method"];

    return (self = [super init]);
}

-(id)initWithContactIndex:(CFIndex)contactIndex queue:(RUAddressBookUtilImageRequestQueue*)queue completionBlock:(RUAddressBookUtilGetImageDataBlock)completionBlock
{
    _queue = queue;
    if (self = [self init])
    {
        _contactIndex = contactIndex;
        _completionBlock = completionBlock;
    }

    return self;
}

-(NSString *)description
{
    return RUStringWithFormat(@"%@ at '%p' contactIndex: '%li' state: '%i'",NSStringFromClass(self.class),self,_contactIndex,_state);
}

#pragma mark - Setter methods
-(void)setState:(RUAddressBookUtilImageRequestState)state
{
    _state = state;
}

#pragma mark - Private methods
-(NSData*)fetchImageData
{
    if (_state == RUAddressBookUtilImageRequestStateFetching)
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:RUStringWithFormat(@"request %@ already fetching",self) userInfo:nil];
    }
    else
    {
        [self setState:RUAddressBookUtilImageRequestStateFetching];
        NSData* imageData = [RUAddressBookUtil imageDataFromAddressBookForContactIndex:self.contactIndex];
        if (_state == RUAddressBookUtilImageRequestStateFetching)
            [self setState:RUAddressBookUtilImageRequestStateFinished];
        else
            RUDLog(@"not setting %@ to finished because state wasn't at fetching",self);
        return imageData;
    }
}

#pragma mark - Public methods
-(void)cancel
{
    switch (_state)
    {
        case RUAddressBookUtilImageRequestStateCanceled:
            RUDLog(@"already canceled");
            break;

        case RUAddressBookUtilImageRequestStateFetching:
//            RUDLog(@"Already fetching, too late to cancel");
            break;

        case RUAddressBookUtilImageRequestStateFinished:
            RUDLog(@"already finished");
            break;

        case RUAddressBookUtilImageRequestStateNone:
        case RUAddressBookUtilImageRequestStatePending:
            [self setState:RUAddressBookUtilImageRequestStateCanceled];
            [_queue removeRequestFromQueue:self];
            break;
    }
}

@end

@implementation RUAddressBookUtilImageRequestQueue

-(id)init
{
    if (self = [super init])
    {
        _getImageDataQueue = dispatch_queue_create(kRUAddressBookUtilGetImageDataQueueLabel, 0);
        _manageQueueArrayQueue = dispatch_queue_create(kRUAddressBookUtilManageQueueArrayLabel, 0);
        _queueArray = [NSMutableArray array];
    }

    return self;
}

-(NSString *)description
{
    return RUStringWithFormat(@"%@ at '%p' queueArray: '%@'",NSStringFromClass(self.class),self,_queueArray);
}

//+(void)removeRequestFromQueue:(RUAddressBookUtilImageRequest*)request
//{
//    RUDLog(@"will remove %@ from getImageDataRequestQueue: %@",request,getImageDataRequestQueue);
//    [getImageDataRequestQueue removeObject:request];
//    RUDLog(@"removed %@ from getImageDataRequestQueue: %@",request,getImageDataRequestQueue);
//}

#pragma mark - C methods
BOOL kRUAddressBookUtilImageRequestQueueRequestHasAcceptableRemoveState(RUAddressBookUtilImageRequest* request)
{
    switch (request.state)
    {
        case RUAddressBookUtilImageRequestStateCanceled:
        case RUAddressBookUtilImageRequestStateFinished:
            return YES;
            break;

        case RUAddressBookUtilImageRequestStateFetching:
        case RUAddressBookUtilImageRequestStateNone:
        case RUAddressBookUtilImageRequestStatePending:
            return NO;
    }
}

#pragma mark - Public methods
-(void)removeRequestFromQueue:(RUAddressBookUtilImageRequest*)request
{
    if (request)
    {
        switch (request.state)
        {
            case RUAddressBookUtilImageRequestStatePending:
            case RUAddressBookUtilImageRequestStateFetching:
            case RUAddressBookUtilImageRequestStateNone:
                [NSException raise:NSInternalInconsistencyException format:@"request %@ must be canceled or finished if it wants to be removed from queue %@",request,self];
                break;

            case RUAddressBookUtilImageRequestStateCanceled:
            case RUAddressBookUtilImageRequestStateFinished:
            {
                dispatch_async(_manageQueueArrayQueue, ^{
                    NSInteger requestIndex = [_queueArray indexOfObject:request];
                    if (requestIndex == NSNotFound)
                    {
                        RUDLog(@"Already removed");
                    }
                    else
                    {
//                        RUDLog(@"removing %@ from queue: %@",request,_queueArray);
                        [_queueArray removeObjectAtIndex:requestIndex];
//                        RUDLog(@"removedfrom queue: %@",_queueArray);
                    }
                });
            }
                break;
        }
    }
    else
    {
        RUDLog(@"shouldn't pass nil request");
    }
}

-(void)addRequestToQueue:(RUAddressBookUtilImageRequest*)request
{
    if (request)
    {
        dispatch_async(_manageQueueArrayQueue, ^{
            switch (request.state)
            {
                case RUAddressBookUtilImageRequestStateNone:
                    [request setState:RUAddressBookUtilImageRequestStatePending];
                    [_queueArray addObject:request];
                    [self checkForNextRequest];
                    break;

                case RUAddressBookUtilImageRequestStatePending:
                    RUDLog(@"already pending");
                    break;

                case RUAddressBookUtilImageRequestStateCanceled:
//                    RUDLog(@"request was canceled");
                    break;

                case RUAddressBookUtilImageRequestStateFetching:
                    RUDLog(@"already fetching");
                    break;

                case RUAddressBookUtilImageRequestStateFinished:
                    RUDLog(@"already finished");
                    break;
            }
        });
    }
    else
    {
        RUDLog(@"shouldn't pass a nil request");
    }
}

-(void)clearCurrentRequestAndCheckForNextRequest
{
    [self removeRequestFromQueue:_currentImageRequest];
    _currentImageRequest = nil;
    [self checkForNextRequest];
}

-(void)checkForNextRequest
{
    dispatch_async(_manageQueueArrayQueue, ^{
        if (!_currentImageRequest)
        {
            if (_queueArray.count)
            {
                RUAddressBookUtilImageRequest* firstRequest = [_queueArray objectAtIndex:0];
                switch (firstRequest.state)
                {
                    case RUAddressBookUtilImageRequestStatePending:
                        _currentImageRequest = firstRequest;
                        [self runCurrentRequest];
                        break;

                    case RUAddressBookUtilImageRequestStateCanceled:
                        RUDLog(@"already canceled");
                        break;

                    case RUAddressBookUtilImageRequestStateFinished:
                        RUDLog(@"already finished");
                        break;
                        
                    case RUAddressBookUtilImageRequestStateFetching:
                        RUDLog(@"already fetching");
                        break;
                        
                    case RUAddressBookUtilImageRequestStateNone:
                        RUDLog(@"none");
                        break;
                }
            }
//            else
//            {
//                RUDLog(@"done");
//            }
        }
//        else
//        {
//            RUDLog(@"busy");
//        }
    });
}

-(void)runCurrentRequest
{
    dispatch_async(_getImageDataQueue, ^{
        if (_currentImageRequest.state == RUAddressBookUtilImageRequestStatePending)
        {
            //Fetch and process image data
            NSData* imageData = [_currentImageRequest fetchImageData];
            if (_currentImageRequest.state == RUAddressBookUtilImageRequestStateFinished)
            {
                __block RUAddressBookUtilImageRequest* currentImageRequest = _currentImageRequest;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (currentImageRequest.state == RUAddressBookUtilImageRequestStateFinished)
                    {
                        if (currentImageRequest.completionBlock)
                            currentImageRequest.completionBlock(imageData,currentImageRequest);
                    }
                    else
                    {
                        RUDLog(@"request: '%@' queue: '%@'",_currentImageRequest,self);
                    }
                });
            }
            else
            {
                RUDLog(@"request: '%@' queue: '%@'",_currentImageRequest,self);
            }
            
            [self clearCurrentRequestAndCheckForNextRequest];
        }
        else
        {
            RUDLog(@"request: '%@' queue: '%@'",_currentImageRequest,self);
            [self clearCurrentRequestAndCheckForNextRequest];
        }
    });
}

@end


