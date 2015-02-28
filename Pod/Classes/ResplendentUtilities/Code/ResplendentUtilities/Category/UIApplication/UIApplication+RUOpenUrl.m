//
//  UIApplication+RUOpenUrl.m
//  VibeWithIt
//
//  Created by Benjamin Maer on 12/1/14.
//  Copyright (c) 2014 VibeWithIt. All rights reserved.
//

#import "UIApplication+RUOpenUrl.h"
#import "RUDLog.h"





@implementation UIApplication (RUOpenUrl)

#pragma mark - Open url
-(BOOL)ru_attemptToOpenUrls:(NSArray*)urls
{
	for (NSURL* url in urls)
	{
		if ([self openURL:url])
		{
			RUDLog(@"openUrl: %@",url);
			return YES;
		}
	}
	
	return NO;
}


@end
