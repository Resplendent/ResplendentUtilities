//
//  AddressBookUtil.h
//  Resplendent
//
//  Created by Benjamin Maer on 2/4/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RUAddressBookUtilImageRequest;

typedef void (^RUAddressBookUtilAskForPermissionsCompletionBlock)(BOOL alreadyAsked, BOOL granted);
typedef id _Nonnull (^RUAddressBookUtilCreateObjectWithDictBlock)(NSDictionary* _Nonnull properites, NSUInteger contactIndex);
typedef void (^RUAddressBookUtilGetImageDataBlock)(NSData* _Nonnull imageData,RUAddressBookUtilImageRequest* _Nonnull request);

typedef enum {
    RUAddressBookUtilImageRequestStateNone = 0,
    RUAddressBookUtilImageRequestStatePending = 100,
    RUAddressBookUtilImageRequestStateFetching = 200,
    RUAddressBookUtilImageRequestStateFinished,
    RUAddressBookUtilImageRequestStateCanceled = 300,
}RUAddressBookUtilImageRequestState;





/* Image load request interface */
@interface RUAddressBookUtilImageRequest : NSObject

@property (nonatomic, readonly, assign) RUAddressBookUtilImageRequestState state;
@property (nonatomic, readonly, strong, nullable) RUAddressBookUtilGetImageDataBlock completionBlock;
@property (nonatomic, readonly, assign) CFIndex contactIndex;

-(void)cancel;

@end




typedef enum
{
    kRUAddressBookUtilPhonePropertyTypePhone = 100,
    kRUAddressBookUtilPhonePropertyTypeEmail,
    kRUAddressBookUtilPhonePropertyTypeFirstName,
    kRUAddressBookUtilPhonePropertyTypeLastName,
    kRUAddressBookUtilPhonePropertyTypeImage
}kRUAddressBookUtilPhonePropertyType;





@interface RUAddressBookUtil : NSObject

#pragma mark - askUserForPermission
+(void)askUserForPermissionWithCompletion:(nullable RUAddressBookUtilAskForPermissionsCompletionBlock)completion;

#pragma mark - getFromAddressBook
/**
 Gets contacts values from the address book given the types passed in.

 @param phoneProperties An array of numbers. Each number should be a valid `kRUAddressBookUtilPhonePropertyType` integer.
 @return Get back a dictionary where each value from `phoneProperties` is a key, and the value is the array of
 */
+(nullable NSDictionary<NSString*,NSArray<NSString*>*>*)getArraysFromAddressBookWithPhonePropertyTypes:(nullable NSArray<NSNumber*>*)phoneProperties;

+(nullable NSArray*)getContactsPhoneNumbersArray;

+(nullable NSArray<id>*)getObjectsFromAddressBookWithPhonePropertyTypes:(nullable NSArray<NSNumber*>*)phoneProperties
													objectCreationBlock:(nonnull RUAddressBookUtilCreateObjectWithDictBlock)objectCreationBlock;

+(nullable RUAddressBookUtilImageRequest*)getImageDataFromAddressBookForContactIndex:(CFIndex)contactIndex
																		  completion:(nonnull RUAddressBookUtilGetImageDataBlock)completion;

@end
