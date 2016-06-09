//
//  NSString+RUEncodedUrl.m
//  Nifti
//
//  Created by Benjamin Maer on 12/23/14.
//  Copyright (c) 2014 Nifti. All rights reserved.
//

#import "NSString+RUEncodedUrl.h"





@implementation NSString (RUEncodedUrl)

-(NSString *)ru_encodedURLString
{
	NSString * ru_encodedURLString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																							   NULL,
																							   (CFStringRef)self,
																							   NULL,
																							   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																							   kCFStringEncodingUTF8 ));

	return ru_encodedURLString;
}

@end
