//
//  UIImage+RUDebug.m
//  Resplendent
//
//  Created by Benjamin Maer on 3/18/13.
//  Copyright (c) 2013 Resplendent G.P. All rights reserved.
//

#import "UIImage+RUDebug.h"
#import "RUConstants.h"

@implementation UIImage (RUDebug)

-(NSString*)imageDebugDescription
{
    NSMutableArray* imageDebugDescriptionArray = [NSMutableArray array];

    [imageDebugDescriptionArray addObject:RUStringWithFormat(@"self: %@",self)];
    [imageDebugDescriptionArray addObject:RUStringWithFormat(@"imageOrientation: %li",(long)self.imageOrientation)];
    [imageDebugDescriptionArray addObject:RUStringWithFormat(@"CGImage: %@",self.CGImage)];
    [imageDebugDescriptionArray addObject:RUStringWithFormat(@"size: %@",NSStringFromCGSize(self.size))];
    [imageDebugDescriptionArray addObject:RUStringWithFormat(@"cgimage width: %zu",CGImageGetWidth(self.CGImage))];
    [imageDebugDescriptionArray addObject:RUStringWithFormat(@"cgimage height: %zu",CGImageGetHeight(self.CGImage))];

    return [imageDebugDescriptionArray componentsJoinedByString:@"\n"];
}

@end
