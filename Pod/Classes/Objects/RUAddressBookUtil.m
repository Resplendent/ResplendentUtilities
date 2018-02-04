//
//  AddressBookUtil.m
//  Resplendent
//
//  Created by Benjamin Maer on 2/4/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "RUAddressBookUtil.h"
#import "RUDLog.h"
#import "RUConstants.h"
#import "NSString+RUMacros.h"
#import "RUConditionalReturn.h"
#import "NSBundle+RUPListGetters.h"

#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, RUAddressBookUtilABMultiValueRefType) {
	RUAddressBookUtilABMultiValueRefType_Unknown,
	RUAddressBookUtilABMultiValueRefType_NSString,
	RUAddressBookUtilABMultiValueRefType_Array,
	RUAddressBookUtilABMultiValueRefType_Data,

	RUAddressBookUtilABMultiValueRefType__first		= RUAddressBookUtilABMultiValueRefType_NSString,
	RUAddressBookUtilABMultiValueRefType__last		= RUAddressBookUtilABMultiValueRefType_Data,
};





kRUDefineNSStringConstant(kRUAddressBookUtilHasAskedUserForContacts);

//++++ RUAddressBookUtilImageRequestQueue
const char * kRUAddressBookUtilGetImageDataQueueLabel = "RUAddressBookUtil.RUAddressBookUtilImageRequestQueue.getImageDataQueueLabel";
const char * kRUAddressBookUtilManageQueueArrayLabel = "RUAddressBookUtil.RUAddressBookUtilImageRequestQueue.manageQueueArrayLabel";





@interface RUAddressBookUtilImageRequestQueue : NSObject
{
    dispatch_queue_t _getImageDataQueue;
    dispatch_queue_t _manageQueueArrayQueue;
}

#pragma mark - queueArray
@property (nonatomic, strong, nullable) NSMutableArray<RUAddressBookUtilImageRequest*>* queueArray;

#pragma mark - currentImageRequest
@property (nonatomic, strong, nullable) RUAddressBookUtilImageRequest* currentImageRequest;

-(void)addRequestToQueue:(nonnull RUAddressBookUtilImageRequest*)request;
-(void)removeRequestFromQueue:(nonnull RUAddressBookUtilImageRequest*)request;
-(void)clearCurrentRequestAndCheckForNextRequest;
-(void)checkForNextRequest;
-(void)runCurrentRequest;

@end
//-----





@interface RUAddressBookUtilImageRequest ()

@property (nonatomic, assign) RUAddressBookUtilImageRequestQueue* queue;

-(id)initWithContactIndex:(CFIndex)contactIndex queue:(RUAddressBookUtilImageRequestQueue*)queue completionBlock:(RUAddressBookUtilGetImageDataBlock)completionBlock;

/* Synchronously loads image data, so should be done with thread competency. Will throw exception if request is already fetching. */
-(nullable NSData*)fetchImageData;

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

//+(ABAddressBookRef)currentAddressBook;
+(void)currentAddressBook:(ABAddressBookRef*)addressBookRef;

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
        case RUAddressBookUtilABMultiValueRefType_NSString:
		{
			CFTypeRef const recordRef = ABRecordCopyValue(person, abMultiValueRefForPersonWithPropertyType(type));
			kRUConditionalReturn_ReturnValueNil(recordRef == nil, NO);

			NSArray* const records = [NSArray arrayWithArray:(__bridge NSArray*)recordRef];
			CFRelease(recordRef);
			return records;
		}
            break;

        case RUAddressBookUtilABMultiValueRefType_Array:
		{
			ABMultiValueRef const personPropertiesRecord = ABRecordCopyValue(person, abMultiValueRefForPersonWithPropertyType(type));
			id property = kRUAddressBookUtilPersonPropertiesArray(personPropertiesRecord);
			CFRelease(personPropertiesRecord);

			return property;
		}
            break;

        case RUAddressBookUtilABMultiValueRefType_Data:
		{
			CFDataRef const dataRef = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
			kRUConditionalReturn_ReturnValueNil(dataRef == nil, NO);

			NSData* const data = [NSData dataWithData:(__bridge NSData*)dataRef];
			CFRelease(dataRef);
			return data;
		}
            break;

        case RUAddressBookUtilABMultiValueRefType_Unknown:
            break;
    }

    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:RUStringWithFormat(@"unhandled property type %i",type) userInfo:nil];
}

NSMutableArray* kRUAddressBookUtilPersonPropertiesArray(ABMultiValueRef personPropertiesRecord)
{
    CFIndex const personPropertiesCount = ABMultiValueGetCount(personPropertiesRecord);

    NSMutableArray* const personPropertiesArray = [NSMutableArray array];

    for (int phoneIndex = 0; phoneIndex < personPropertiesCount; phoneIndex++)
    {
		CFTypeRef const personProperty_ref = ABMultiValueCopyValueAtIndex(personPropertiesRecord, phoneIndex);
		if (personProperty_ref)
		{
			NSString* const personProperty = (__bridge NSString*)personProperty_ref;

			if (personProperty)
			{
				[personPropertiesArray addObject:personProperty];
			}

			CFRelease(personProperty_ref);
		}
    }

    return personPropertiesArray;
}

RUAddressBookUtilABMultiValueRefType abMultiValueRefTypeForPersonWithPropertyType(kRUAddressBookUtilPhonePropertyType propertyType)
{
    switch (propertyType)
    {
        case kRUAddressBookUtilPhonePropertyTypeEmail:
        case kRUAddressBookUtilPhonePropertyTypePhone:
            return RUAddressBookUtilABMultiValueRefType_Array;

        case kRUAddressBookUtilPhonePropertyTypeFirstName:
        case kRUAddressBookUtilPhonePropertyTypeLastName:
            return RUAddressBookUtilABMultiValueRefType_NSString;
            break;

        case kRUAddressBookUtilPhonePropertyTypeImage:
            return RUAddressBookUtilABMultiValueRefType_Data;
            break;
    }

    RUDLog(@"unknown property type %i",propertyType);
    return RUAddressBookUtilABMultiValueRefType_Unknown;
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

	ABAddressBookRef addressbook = nil;
	[self currentAddressBook:&addressbook];
	kRUConditionalReturn_ReturnValueNil(addressbook == nil, YES);

//	ABAddressBookRef const addressbook = [self currentAddressBook];
//	kRUConditionalReturn_ReturnValueNil(addressbook == nil, YES);

	CFArrayRef const people = ABAddressBookCopyArrayOfAllPeople(addressbook);
	CFRelease(addressbook);
	kRUConditionalReturn_ReturnValueNil(people == nil, YES);

	if (people)
	{
		ABRecordRef const person = CFArrayGetValueAtIndex(people, contactIndex);
		CFRelease(people);
		
		if (person)
		{
			NSData* const imageData = kRUAddressBookUtilPersonPropertyForPhonePropertyType(person, kRUAddressBookUtilPhonePropertyTypeImage);
			
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

+(nullable RUAddressBookUtilImageRequest*)getImageDataFromAddressBookForContactIndex:(CFIndex)contactIndex
																		  completion:(nonnull RUAddressBookUtilGetImageDataBlock)completion
{
	kRUConditionalReturn_ReturnValueNil(completion == nil, YES);

	RUAddressBookUtilImageRequest* const request = [[RUAddressBookUtilImageRequest alloc] initWithContactIndex:contactIndex queue:getImageDataRequestQueue completionBlock:completion];
	[getImageDataRequestQueue addRequestToQueue:request];
	return request;
}

#pragma mark - Static methods
+(BOOL)usesNativePermissions
{
    return (&ABAddressBookRequestAccessWithCompletion != nil);
}

#pragma mark - askUserForPermission
+(void)askUserForPermissionWithCompletion:(nullable RUAddressBookUtilAskForPermissionsCompletionBlock)completion
{
	RUAddressBookUtilAskForPermissionsCompletionBlock const completion_with_check = ^(BOOL alreadyAsked, BOOL granted) {
		kRUConditionalReturn(completion == nil, NO);

		completion(alreadyAsked,granted);
	};

    if ([self usesNativePermissions])
    {
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
        {
			ABAddressBookRef addressbook = nil;
			[self currentAddressBook:&addressbook];
			kRUConditionalReturn(addressbook == nil, YES);

            ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error) {
				CFRelease(addressbook);
				completion_with_check(NO,granted);
            });
        }
        else
        {
            if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
            {
				completion_with_check(YES,YES);
            }
            else
            {
				completion_with_check(YES,NO);
            }
        }
    }
    else
    {
        NSNumber* const hasAskedForPermission = [self cachedHasAskedUserForContacts];
        if (hasAskedForPermission)
        {
            completion_with_check(YES,hasAskedForPermission.boolValue);
        }
        else
        {
            RUAddressBookUtil* addressBookUtilInstance = [RUAddressBookUtil new];
            [addressBookUtilInstance setAlertViewCompletion:completion];

            if (!sharedInstances)
                sharedInstances = [NSMutableArray array];

            [sharedInstances addObject:addressBookUtilInstance];

            [[[UIAlertView alloc] initWithTitle:RUStringWithFormat(@"%@ Would Like to Access Your Contacts",[[NSBundle mainBundle] ru_CFBundleName])
										message:nil
									   delegate:addressBookUtilInstance
							  cancelButtonTitle:@"Don't Allow"
							  otherButtonTitles:@"OK", nil]
			 show];
        }
    }
}

#pragma mark - getFromAddressBook
+(nullable NSDictionary<NSString*,NSArray<NSString*>*>*)getArraysFromAddressBookWithPhonePropertyTypes:(nullable NSArray<NSNumber*>*)phoneProperties
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
		NSNumber* const askedPermission = [self cachedHasAskedUserForContacts];

		if (!(askedPermission && askedPermission.boolValue))
			return nil;
	}

	ABAddressBookRef addressbook = nil;
	[self currentAddressBook:&addressbook];
	kRUConditionalReturn_ReturnValueNil(addressbook == nil, YES);

	CFArrayRef const people =  ABAddressBookCopyArrayOfAllPeople(addressbook);
	CFRelease(addressbook);
	kRUConditionalReturn_ReturnValueNil(people == nil, YES);

	NSMutableDictionary<NSString*,NSMutableArray<NSString*>*>* const arrayDictionary_mutable = [NSMutableDictionary<NSString*,NSMutableArray<NSString*>*> dictionaryWithCapacity:phoneProperties.count];

	[phoneProperties enumerateObjectsUsingBlock:^(NSNumber * _Nonnull phoneProperty, NSUInteger idx, BOOL * _Nonnull stop) {
		[arrayDictionary_mutable setObject:[NSMutableArray<NSString*> array] forKey:phoneProperty.stringValue];
	}];


	if (people)
	{
		CFIndex const contactCount = CFArrayGetCount(people);

		for (int contact_index = 0; contact_index < contactCount; contact_index++)
		{
			ABRecordRef const person = CFArrayGetValueAtIndex(people, contact_index);

			if (person != nil)
			{
				for (NSNumber* phoneProperty in phoneProperties)
				{
					NSMutableArray<NSString*>* const propArray = [arrayDictionary_mutable objectForKey:phoneProperty.stringValue];
					CFTypeRef const person_record = ABRecordCopyValue(person, abMultiValueRefForPersonWithPropertyType((kRUAddressBookUtilPhonePropertyType)phoneProperty.integerValue));
					ABMultiValueRef const personProperties = (ABMultiValueRef)person_record;

					CFIndex const personPropertiesCount = ABMultiValueGetCount(personProperties);

					for (int phoneIndex = 0; phoneIndex < personPropertiesCount; phoneIndex++)
					{
						CFTypeRef const personProperty_ref = ABMultiValueCopyValueAtIndex(personProperties, phoneIndex);
						if (personProperty_ref)
						{
							NSString* const personProperty = (__bridge NSString*)personProperty_ref;

							if (personProperty)
							{
								[propArray addObject:personProperty];
							}

							CFRelease(personProperty_ref);
						}
					}

					CFRelease(person_record);
				}
			}
		}

		CFRelease(people);
	}

	NSMutableDictionary<NSString*,NSArray<NSString*>*>* const arrayDictionary = [NSMutableDictionary<NSString*,NSArray<NSString*>*> dictionaryWithCapacity:phoneProperties.count];
	[arrayDictionary_mutable enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
		[arrayDictionary setObject:[NSArray<NSString*> arrayWithArray:obj] forKey:key];
	}];

	return [NSDictionary<NSString*,NSArray<NSString*>*> dictionaryWithDictionary:arrayDictionary];
}

+(nullable NSArray<id>*)getObjectsFromAddressBookWithPhonePropertyTypes:(nullable NSArray<NSNumber*>*)phoneProperties
													objectCreationBlock:(nonnull RUAddressBookUtilCreateObjectWithDictBlock)objectCreationBlock
{
	kRUConditionalReturn_ReturnValueNil(objectCreationBlock == nil, YES);

	if ([self usesNativePermissions])
	{
		/* If the user hasn't previously authorized, then don't add the contact. */
		kRUConditionalReturn_ReturnValueNil(ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized, NO);
	}
	else
	{
		NSNumber* const askedPermission = [self cachedHasAskedUserForContacts];

		kRUConditionalReturn_ReturnValueNil((askedPermission == nil)
											||
											(askedPermission.boolValue == false),
											NO);
	}

	ABAddressBookRef addressbook = nil;
	[self currentAddressBook:&addressbook];
	kRUConditionalReturn_ReturnValueNil(addressbook == nil, YES);

	CFArrayRef const people =  ABAddressBookCopyArrayOfAllPeople(addressbook);
	CFRelease(addressbook);
	kRUConditionalReturn_ReturnValueNil(people == nil, YES);

	NSMutableArray<id>* const objectsArray = [NSMutableArray array];
	CFIndex const contactCount = CFArrayGetCount(people);

	for (int contact_index = 0;
		 contact_index < contactCount;
		 contact_index++)
	{
		ABRecordRef const person = CFArrayGetValueAtIndex(people, contact_index);

		NSMutableDictionary* const personPropertyDictionary = [NSMutableDictionary dictionary];
		[phoneProperties enumerateObjectsUsingBlock:^(NSNumber * _Nonnull phoneProperty, NSUInteger idx, BOOL * _Nonnull stop) {
			id const personPropertiesRecord = kRUAddressBookUtilPersonPropertyForPhonePropertyType(person, (kRUAddressBookUtilPhonePropertyType)phoneProperty.integerValue);

			if (personPropertiesRecord)
			{
				[personPropertyDictionary setObject:personPropertiesRecord forKey:phoneProperty.stringValue];
			}
		}];

		id const object = objectCreationBlock(personPropertyDictionary,contact_index);
		if (object)
		{
			[objectsArray addObject:object];
		}
	}

	CFRelease(people);

	return objectsArray;
}

+(nullable NSArray*)getContactsPhoneNumbersArray
{
	ABAddressBookRef addressbook = nil;
	[self currentAddressBook:&addressbook];
	kRUConditionalReturn_ReturnValueNil(addressbook == nil, YES);

	ABRecordRef const source = ABAddressBookCopyDefaultSource(addressbook);
	CFRelease(addressbook);
	kRUConditionalReturn_ReturnValueNil(source == nil, NO);

	CFArrayRef const people = ABAddressBookCopyArrayOfAllPeopleInSource(addressbook, source);
	CFRelease(source);
	kRUConditionalReturn_ReturnValueNil(people == nil, NO);

	NSMutableArray* const phoneNumbersArray = [NSMutableArray array];

	CFIndex const contactCount = CFArrayGetCount(people);

	for (int contact_index = 0; contact_index < contactCount; contact_index++)
	{
		ABRecordRef const person = CFArrayGetValueAtIndex(people, contact_index);
		ABMultiValueRef const phoneNumbers = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);

		for (int phoneIndex = 0; phoneIndex < ABMultiValueGetCount(phoneNumbers); phoneIndex++)
		{
			CFTypeRef const phoneNumber_ref = ABMultiValueCopyValueAtIndex(phoneNumbers, phoneIndex);
			if (phoneNumber_ref)
			{
				NSString* const phoneNumber = (__bridge NSString*)phoneNumber_ref;

				if (phoneNumber)
				{
					[phoneNumbersArray addObject:phoneNumber];
				}

				CFRelease(phoneNumber_ref);
			}
		}

		CFRelease(phoneNumbers);
	}

	CFRelease(people);

    return phoneNumbersArray;
}

#pragma mark - Getters
+(void)currentAddressBook:(ABAddressBookRef*)addressBookRef
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
	*addressBookRef = ABAddressBookCreate();
#else
	CFErrorRef error = nil;
	*addressBookRef = ABAddressBookCreateWithOptions(NULL, (CFErrorRef *)&error);
	if (error)
	{
		RUDLog(@"error: %@",error);
	}
#endif
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
    return RUStringWithFormat(@"%@ at '%p' queueArray: '%@'",NSStringFromClass(self.class),self,self.queueArray);
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
-(void)removeRequestFromQueue:(nonnull RUAddressBookUtilImageRequest*)request
{
	kRUConditionalReturn(request == nil, YES);

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
			__weak typeof(self) const self_weak = self;
			dispatch_async(_manageQueueArrayQueue, ^{
				NSInteger requestIndex = [self_weak.queueArray indexOfObject:request];
				if (requestIndex == NSNotFound)
				{
					RUDLog(@"Already removed");
				}
				else
				{
					//                        RUDLog(@"removing %@ from queue: %@",request,_queueArray);
					[self_weak.queueArray removeObjectAtIndex:requestIndex];
					//                        RUDLog(@"removedfrom queue: %@",_queueArray);
				}
			});
		}
			break;
	}
}

-(void)addRequestToQueue:(nonnull RUAddressBookUtilImageRequest*)request
{
	kRUConditionalReturn(request == nil, YES);

	__weak typeof(self) const self_weak = self;
	dispatch_async(_manageQueueArrayQueue, ^{
		switch (request.state)
		{
			case RUAddressBookUtilImageRequestStateNone:
				[request setState:RUAddressBookUtilImageRequestStatePending];
				[self_weak.queueArray addObject:request];
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

-(void)clearCurrentRequestAndCheckForNextRequest
{
    [self removeRequestFromQueue:self.currentImageRequest];
    self.currentImageRequest = nil;
    [self checkForNextRequest];
}

-(void)checkForNextRequest
{
	__weak typeof(self) const self_weak = self;
    dispatch_async(_manageQueueArrayQueue, ^{
        if (!self_weak.currentImageRequest)
        {
            if (self_weak.queueArray.count)
            {
                RUAddressBookUtilImageRequest* firstRequest = [self_weak.queueArray objectAtIndex:0];
                switch (firstRequest.state)
                {
                    case RUAddressBookUtilImageRequestStatePending:
                        self_weak.currentImageRequest = firstRequest;
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
	__weak typeof(self) const self_weak = self;
    dispatch_async(_getImageDataQueue, ^{
        if (self_weak.currentImageRequest.state == RUAddressBookUtilImageRequestStatePending)
        {
            //Fetch and process image data
            NSData* imageData = [self_weak.currentImageRequest fetchImageData];
            if (self_weak.currentImageRequest.state == RUAddressBookUtilImageRequestStateFinished)
            {
                __block RUAddressBookUtilImageRequest* currentImageRequest = self_weak.currentImageRequest;

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (currentImageRequest.state == RUAddressBookUtilImageRequestStateFinished)
                    {
                        if (currentImageRequest.completionBlock)
                            currentImageRequest.completionBlock(imageData,currentImageRequest);
                    }
                    else
                    {
                        RUDLog(@"request: '%@' queue: '%@'",self_weak.currentImageRequest,self_weak);
                    }
                });
            }
            else
            {
                RUDLog(@"request: '%@' queue: '%@'",self_weak.currentImageRequest,self_weak);
            }

            [self clearCurrentRequestAndCheckForNextRequest];
        }
        else
        {
            RUDLog(@"request: '%@' queue: '%@'",self_weak.currentImageRequest,self_weak);
            [self clearCurrentRequestAndCheckForNextRequest];
        }
    });
}

@end


