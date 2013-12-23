//
//  RUFourSquareVenuePhoto.h
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUFourSquareVenuePhoto : NSObject

@property (nonatomic, readonly) NSDictionary* infoDict;

@property (nonatomic, readonly) NSString* urlPrefix;
@property (nonatomic, readonly) NSString* urlSuffix;
@property (nonatomic, readonly) NSString* urlFormatString;

-(id)initWithInfoDict:(NSDictionary*)infoDict;

-(NSString*)urlWithSizeComponent:(NSString*)urlSizeComponent;

+(instancetype)fourSquareVenuePhotoForJsonDict:(NSDictionary*)jsonDict;
+(NSMutableArray*)fourSquareVenuePhotosForResponseDict:(NSDictionary*)responseDict;

+(NSString*)urlSizeComponentCappedWidth:(NSInteger)width;

+(NSString*)urlFromFormatString:(NSString*)urlFormatString withSizeComponent:(NSString*)sizeComponent;

@end
