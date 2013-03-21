//
//  AddressBookUtil.h
//  Albumatic
//
//  Created by Benjamin Maer on 2/4/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RUAddressBookUtilAskForPermissionsCompletionBlock)(BOOL alreadyAsked, BOOL granted);
typedef id (^RUAddressBookUtilCreateObjectWithDictBlock)(NSDictionary* properites,NSUInteger contactIndex);
typedef void (^RUAddressBookUtilGetImageBlock)(NSData* imageData,CFIndex contactIndex);

typedef enum
{
    kRUAddressBookUtilPhonePropertyTypePhone = 100,
    kRUAddressBookUtilPhonePropertyTypeEmail,
    kRUAddressBookUtilPhonePropertyTypeFirstName,
    kRUAddressBookUtilPhonePropertyTypeLastName,
    kRUAddressBookUtilPhonePropertyTypeImage
}kRUAddressBookUtilPhonePropertyType;
//    NSArray* properties = @[[NSNumber numberWithInt:kABPersonPhoneProperty],[NSNumber numberWithInt:kABPersonEmailProperty]];

@interface RUAddressBookUtilImageRequest : NSObject

@property (nonatomic, readonly) BOOL canceled;
@property (nonatomic, readonly) RUAddressBookUtilGetImageBlock completionBlock;
@property (nonatomic, readonly) CFIndex contactIndex;

-(id)initWithContactIndex:(CFIndex)contactIndex completionBlock:(RUAddressBookUtilGetImageBlock)completionBlock;

-(void)cancel;

@end

@interface RUAddressBookUtil : NSObject

+(void)askUserForPermissionWithCompletion:(RUAddressBookUtilAskForPermissionsCompletionBlock)completion;

+(NSDictionary*)getArraysFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties;
+(NSArray*)getContactsPhoneNumbersArray;

//+(NSArray*)getDictionariesFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties;
+(NSArray*)getObjectsFromAddressBookWithPhonePropertyTypes:(NSArray*)phoneProperties objectCreationBlock:(RUAddressBookUtilCreateObjectWithDictBlock)objectCreationBlock;

+(RUAddressBookUtilImageRequest*)getImageDataFromAddressBookForContactIndex:(CFIndex)contactIndex completion:(RUAddressBookUtilGetImageBlock)completion;

@end
