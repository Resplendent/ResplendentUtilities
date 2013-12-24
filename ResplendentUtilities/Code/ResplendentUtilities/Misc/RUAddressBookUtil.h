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
typedef id (^RUAddressBookUtilCreateObjectWithDictBlock)(NSDictionary* properites,NSUInteger contactIndex);
typedef void (^RUAddressBookUtilGetImageDataBlock)(NSData* imageData,RUAddressBookUtilImageRequest* request);

typedef enum {
    RUAddressBookUtilImageRequestStateNone = 0,
    RUAddressBookUtilImageRequestStatePending = 100,
    RUAddressBookUtilImageRequestStateFetching = 200,
    RUAddressBookUtilImageRequestStateFinished,
    RUAddressBookUtilImageRequestStateCanceled = 300,
}RUAddressBookUtilImageRequestState;

//++++Image load request interface
@interface RUAddressBookUtilImageRequest : NSObject

//@property (nonatomic, readonly) BOOL canceled;
//@property (nonatomic, readonly) BOOL fetching;
@property (nonatomic, readonly) RUAddressBookUtilImageRequestState state;
@property (nonatomic, readonly) RUAddressBookUtilGetImageDataBlock completionBlock;
@property (nonatomic, readonly) CFIndex contactIndex;

-(void)cancel;

@end
//----




typedef enum
{
    kRUAddressBookUtilPhonePropertyTypePhone = 100,
    kRUAddressBookUtilPhonePropertyTypeEmail,
    kRUAddressBookUtilPhonePropertyTypeFirstName,
    kRUAddressBookUtilPhonePropertyTypeLastName,
    kRUAddressBookUtilPhonePropertyTypeImage
}kRUAddressBookUtilPhonePropertyType;

@interface RUAddressBookUtil : NSObject

+(void)askUserForPermissionWithCompletion:(RUAddressBookUtilAskForPermissionsCompletionBlock)completion;

+(NSDictionary*)getArraysFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties;
+(NSArray*)getContactsPhoneNumbersArray;

//+(NSArray*)getDictionariesFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties;
+(NSArray*)getObjectsFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties objectCreationBlock:(RUAddressBookUtilCreateObjectWithDictBlock)objectCreationBlock;

+(RUAddressBookUtilImageRequest*)getImageDataFromAddressBookForContactIndex:(CFIndex)contactIndex completion:(RUAddressBookUtilGetImageDataBlock)completion;

@end
