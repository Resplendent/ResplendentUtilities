//
//  RUFourSquareVenuePhoto.m
//  Pineapple
//
//  Created by Benjamin Maer on 8/11/13.
//  Copyright (c) 2013 Pineapple. All rights reserved.
//

#import "RUFourSquareVenuePhoto.h"
#import "RUConstants.h"

@implementation RUFourSquareVenuePhoto

-(id)initWithInfoDict:(NSDictionary*)infoDict
{
    if (self = [self init])
    {
        _infoDict = infoDict;
    }

    return self;
}

-(NSString *)description
{
    return RUStringWithFormat(@"%@ info dict: '%@'",[super description],self.infoDict);
}

#pragma mark - Getter methods
-(NSString *)urlPrefix
{
    return [self.infoDict objectForKey:@"prefix"];
}

-(NSString *)urlSuffix
{
    return [self.infoDict objectForKey:@"suffix"];
}

-(NSString *)urlFormatString
{
    return RUStringWithFormat(@"%@%@%@",self.urlPrefix,@"%@",self.urlSuffix);
}

-(NSString*)urlWithSizeComponent:(NSString*)urlSizeComponent
{
    return [[self class]urlFromFormatString:self.urlFormatString withSizeComponent:urlSizeComponent];
}

#pragma mark - Static
+(NSString*)urlFromFormatString:(NSString*)urlFormatString withSizeComponent:(NSString*)sizeComponent
{
    if (!urlFormatString)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Must pass non-nil urlFormatString"];
    }

    if (!sizeComponent.length)
    {
        sizeComponent = @"original";
    }
    
    return RUStringWithFormat(urlFormatString,sizeComponent);
}

+(NSString*)urlSizeComponentCappedWidth:(NSInteger)width
{
    return RUStringWithFormat(@"width%i",width);
}

#pragma mark - Public methods
NSInteger PAFourSquareVenuePhotoDistanceOfClosestDimension(CGSize size1,CGSize size2)
{
    return MIN(abs(size1.width - size2.width), abs(size1.height - size2.height));
}

#pragma mark - Static Constructor methods
+(NSMutableArray*)fourSquareVenuePhotosForResponseDict:(NSDictionary*)responseDict
{
    NSDictionary* photosJsonDict = [responseDict objectForKey:@"photos"];
    //    NSNumber* photosCount = [photosJsonDict objectForKey:@"count"];
    NSArray* photoItemsJsonArray = [photosJsonDict objectForKey:@"items"];
    //    PAFourSquareVenuePhotosResponseObjectPhotoItem* photosGroup = PAFourSquareVenuePhotoGroupForPhotosFromPhotoItemsJsonArray(photoItemsJsonArray);

    NSMutableArray* fourSquareVenuePhotos = [NSMutableArray arrayWithCapacity:photoItemsJsonArray.count];
    
//    limit = MIN(limit, photoItemsJsonArray.count);

    for (NSDictionary* photoItemJsonDict in photoItemsJsonArray)
    {
        RUFourSquareVenuePhoto* fsPhoto = [RUFourSquareVenuePhoto fourSquareVenuePhotoForJsonDict:photoItemJsonDict];
        if (fsPhoto)
            [fourSquareVenuePhotos addObject:fsPhoto];
    }
//    for (int index = 0; index < limit; index++)
//    {
//        NSDictionary* photoItemJsonDict = [photoItemsJsonArray objectAtIndex:index];
//
//        RUFourSquareVenuePhoto* fsPhoto = [RUFourSquareVenuePhoto fourSquareVenuePhotoForJsonDict:photoItemJsonDict];
//        if (fsPhoto)
//            [fourSquareVenuePhotos addObject:fsPhoto];
//    }
    
    return fourSquareVenuePhotos;
}

+(instancetype)fourSquareVenuePhotoForJsonDict:(NSDictionary *)jsonDict
{
    return [[self alloc]initWithInfoDict:jsonDict];
}

@end
