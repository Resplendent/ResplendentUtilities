//
//  NSString+MKCoordinateRegion.m
//  Resplendent
//
//  Created by Benjamin Maer on 9/17/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "NSString+MKCoordinateRegion.h"

#import "RUConstants.h"

NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region) {
    return RUStringWithFormat(@"{{%f, %f}, {%f, %f}}", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);
}

@implementation NSString (MKCoordinateRegion)

@end
